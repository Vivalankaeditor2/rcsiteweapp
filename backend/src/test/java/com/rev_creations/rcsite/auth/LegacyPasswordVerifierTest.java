package com.rev_creations.rcsite.auth;

import com.rev_creations.rcsite.config.AuthProperties;
import com.rev_creations.rcsite.service.LegacyPasswordVerifier;
import org.junit.jupiter.api.Test;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.crypto.factory.PasswordEncoderFactories;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

/**
 * The NC-006 gate: plaintext legacy values must be refused unless the owner has
 * explicitly allowed it, and encoded values must verify normally.
 */
class LegacyPasswordVerifierTest {

    private LegacyPasswordVerifier verifier(boolean allowLegacy) {
        AuthProperties properties = new AuthProperties();
        properties.setAllowLegacyPlaintext(allowLegacy);
        return new LegacyPasswordVerifier(PasswordEncoderFactories.createDelegatingPasswordEncoder(), properties);
    }

    @Test
    void should_verify_a_bcrypt_encoded_value_regardless_of_the_legacy_switch() {
        var encoder = PasswordEncoderFactories.createDelegatingPasswordEncoder();
        String stored = encoder.encode("correct horse");
        assertThat(stored).startsWith("{bcrypt}");

        LegacyPasswordVerifier verifier = verifier(false);

        assertThat(verifier.isEncoded(stored)).isTrue();
        assertThat(verifier.matches("correct horse", stored)).isTrue();
        assertThat(verifier.matches("wrong", stored)).isFalse();
    }

    @Test
    void should_refuse_a_plaintext_value_when_legacy_is_not_allowed() {
        LegacyPasswordVerifier verifier = verifier(false);

        assertThat(verifier.isEncoded("secret")).isFalse();
        assertThatThrownBy(() -> verifier.matches("secret", "secret"))
                .isInstanceOf(BadCredentialsException.class)
                .hasMessageContaining("NC-006");
    }

    @Test
    void should_accept_a_plaintext_value_only_when_the_owner_allows_it() {
        LegacyPasswordVerifier verifier = verifier(true);

        assertThat(verifier.matches("secret", "secret")).isTrue();
        assertThat(verifier.matches("wrong", "secret")).isFalse();
    }

    @Test
    void should_never_match_an_empty_stored_value() {
        LegacyPasswordVerifier verifier = verifier(true);

        assertThat(verifier.matches("anything", null)).isFalse();
        assertThat(verifier.matches("anything", "")).isFalse();
    }
}
