package com.rev_creations.rcsite.service;

import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import com.rev_creations.rcsite.config.AuthProperties;

/**
 * Verifies a submitted password against the value stored in
 * {@code rc_customer.pword}.
 *
 * <p><strong>NC-006:</strong> the column is {@code varchar(20)} and the legacy
 * app compares it in plaintext, so it cannot hold a modern hash. This verifier
 * therefore refuses to authenticate against an <em>unstored</em> value unless the
 * owner explicitly turns on {@link AuthProperties#isAllowLegacyPlaintext()}. That
 * switch exists only for a migration window; leaving it on is insecure and is
 * recorded as an accepted risk, not a default.
 *
 * <p>A value carrying an encoder id ({@code {bcrypt}...}) is verified with the
 * delegating {@link PasswordEncoder}, so new/updated rows can be migrated to a
 * proper hash without any code change.
 */
@Component
public class LegacyPasswordVerifier {

    /**
     * A real BCrypt hash of a fixed throwaway string, computed once at startup.
     * Used to run the encoder even when no user row was found, so login latency
     * does not reveal whether a username exists (user enumeration).
     */
    private final String dummyHash;

    private final PasswordEncoder passwordEncoder;
    private final AuthProperties authProperties;

    public LegacyPasswordVerifier(PasswordEncoder passwordEncoder, AuthProperties authProperties) {
        this.passwordEncoder = passwordEncoder;
        this.authProperties = authProperties;
        this.dummyHash = passwordEncoder.encode("timing-equalizer-not-a-real-password");
    }

    /** Always call this (even for an unknown user) so the failure path costs the same. */
    public void burnCycles(String submitted) {
        passwordEncoder.matches(submitted == null ? "" : submitted, dummyHash);
    }

    public boolean matches(String submitted, String stored) {
        if (stored == null || stored.isEmpty()) {
            return false;
        }
        if (isEncoded(stored)) {
            return passwordEncoder.matches(submitted, stored);
        }
        if (authProperties.isAllowLegacyPlaintext()) {
            return constantTimeEquals(submitted, stored);
        }
        throw new BadCredentialsException(
                "This account has no supported password hash. Set rcsite.auth.allow-legacy-plaintext "
                        + "to migrate legacy passwords (NC-006) after it has been decided and approved.");
    }

    /** True when the stored value names an encoder, e.g. {@code {bcrypt}$2a$...}. */
    public boolean isEncoded(String stored) {
        return stored != null && stored.startsWith("{") && stored.contains("}");
    }

    private static boolean constantTimeEquals(String a, String b) {
        if (a == null || b == null) {
            return false;
        }
        return java.security.MessageDigest.isEqual(
                a.getBytes(java.nio.charset.StandardCharsets.UTF_8),
                b.getBytes(java.nio.charset.StandardCharsets.UTF_8));
    }
}
