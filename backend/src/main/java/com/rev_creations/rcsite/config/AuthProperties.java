package com.rev_creations.rcsite.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * Phase 7 authentication settings (D-022).
 *
 * <p>The JWT signing secret is <strong>never</strong> written here: it is
 * supplied at run time via the {@code RCSITE_AUTH_JWT_SECRET} environment
 * variable (D-005). This class only holds non-secret parameters; the secret is
 * read in {@code SecurityConfig} from the environment.
 */
@Component
@ConfigurationProperties(prefix = "rcsite.auth")
public class AuthProperties {

    /**
     * When true, an unstored legacy value (plaintext in {@code rc_customer.pword},
     * see NC-006) is accepted at login. <strong>Off by default</strong>: turning it
     * on is an owner-approved, migration-window-only setting, because it means
     * plaintext comparison and no password upgrade.
     */
    private boolean allowLegacyPlaintext = false;

    /** Token lifetime in minutes. */
    private long tokenTtlMinutes = 120;

    /** Issuer claim of issued tokens, and the expected issuer on validation. */
    private String issuer = "vivalanka";

    /** Role granted when a user's {@code rc_customer.type} matches no {@code usertype}. */
    private String defaultRole = "USER";

    /** Role-name prefix, so a usertype name maps to a Spring authority. */
    private String rolePrefix = "ROLE_";

    public boolean isAllowLegacyPlaintext() {
        return allowLegacyPlaintext;
    }

    public void setAllowLegacyPlaintext(boolean allowLegacyPlaintext) {
        this.allowLegacyPlaintext = allowLegacyPlaintext;
    }

    public long getTokenTtlMinutes() {
        return tokenTtlMinutes;
    }

    public void setTokenTtlMinutes(long tokenTtlMinutes) {
        this.tokenTtlMinutes = tokenTtlMinutes;
    }

    public String getIssuer() {
        return issuer;
    }

    public void setIssuer(String issuer) {
        this.issuer = issuer;
    }

    public String getDefaultRole() {
        return defaultRole;
    }

    public void setDefaultRole(String defaultRole) {
        this.defaultRole = defaultRole;
    }

    public String getRolePrefix() {
        return rolePrefix;
    }

    public void setRolePrefix(String rolePrefix) {
        this.rolePrefix = rolePrefix;
    }
}
