package com.rev_creations.rcsite.service;

import com.rev_creations.rcsite.config.AuthProperties;
import com.rev_creations.rcsite.dto.AdminUser;
import com.rev_creations.rcsite.dto.LoginResponse;
import com.rev_creations.rcsite.entity.RcCustomer;
import com.rev_creations.rcsite.repository.RcCustomerRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.oauth2.jwt.JwsHeader;
import org.springframework.security.oauth2.jwt.JwtClaimsSet;
import org.springframework.security.oauth2.jwt.JwtEncoder;
import org.springframework.security.oauth2.jwt.JwtEncoderParameters;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.List;

/**
 * Authenticates a user against the existing {@code rc_customer} table (D-022)
 * and issues a stateless JWT for the admin surface.
 *
 * <p>The password check is delegated to {@link LegacyPasswordVerifier}, which
 * refuses plaintext legacy values unless the owner explicitly allows it
 * (NC-006). Responses never carry the stored password.
 */
@Service
public class AuthService {

    private static final Logger log = LoggerFactory.getLogger(AuthService.class);

    private final RcCustomerRepository customerRepository;
    private final LegacyPasswordVerifier passwordVerifier;
    private final UserRoleService roleService;
    private final JwtEncoder jwtEncoder;
    private final AuthProperties authProperties;

    public AuthService(RcCustomerRepository customerRepository,
                       LegacyPasswordVerifier passwordVerifier,
                       UserRoleService roleService,
                       JwtEncoder jwtEncoder,
                       AuthProperties authProperties) {
        this.customerRepository = customerRepository;
        this.passwordVerifier = passwordVerifier;
        this.roleService = roleService;
        this.jwtEncoder = jwtEncoder;
        this.authProperties = authProperties;
    }

    /** Verify the credentials and mint a token. Never logs the password. */
    public LoginResponse login(String username, String password) {
        RcCustomer customer = customerRepository.findById(username).orElse(null);
        if (customer == null) {
            // Same work as a real check, so a missing user is not faster than a wrong password.
            passwordVerifier.burnCycles(password);
            log.info("Login rejected for unknown user '{}'", username);
            throw new BadCredentialsException("Invalid username or password");
        }
        if (!passwordVerifier.matches(password, customer.getPword())) {
            log.info("Login rejected for user '{}' (bad credentials)", username);
            throw new BadCredentialsException("Invalid username or password");
        }

        String roleName = roleService.resolveRoleName(customer.getType());
        String authority = roleService.toAuthority(roleName);
        Instant now = Instant.now();
        Instant expiresAt = now.plus(authProperties.getTokenTtlMinutes(), ChronoUnit.MINUTES);

        JwtClaimsSet claims = JwtClaimsSet.builder()
                .issuer(authProperties.getIssuer())
                .issuedAt(now)
                .expiresAt(expiresAt)
                .subject(customer.getUsername())
                .claim("roles", List.of(authority))
                .claim("name", text(customer.getCustomer()))
                .claim("email", text(customer.getEmail()))
                .build();
        JwsHeader header = JwsHeader.with(org.springframework.security.oauth2.jose.jws.MacAlgorithm.HS256).build();
        String token = jwtEncoder.encode(JwtEncoderParameters.from(header, claims)).getTokenValue();

        AdminUser user = new AdminUser(
                customer.getUsername(),
                text(customer.getCustomer()),
                customer.getEmail(),
                List.of(roleName));
        log.info("Login succeeded for user '{}' with role '{}'", username, roleName);
        return new LoginResponse(token, "Bearer",
                authProperties.getTokenTtlMinutes() * 60, user);
    }

    private static String text(String value) {
        return value == null ? "" : value;
    }
}
