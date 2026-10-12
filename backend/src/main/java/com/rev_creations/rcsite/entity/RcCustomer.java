package com.rev_creations.rcsite.entity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;
import java.math.BigDecimal;

/**
 * Site user / login. The new auth reads users from this existing table (D-022).
 *
 * <p><strong>NC-006:</strong> {@code pword} is a 20-char column compared in
 * plaintext in the legacy app. No hashing scheme is applied here; the auth
 * redesign needs an owner-approved storage change first.
 */
@Entity
@Table(name = "rc_customer")
@Getter
@Setter
public class RcCustomer {
    @Id
    @Column(name = "username")
    private String username;

    @Column(name = "pword")
    private String pword;

    @Column(name = "customer")
    private String customer;

    @Column(name = "email")
    private String email;

    @Column(name = "type")
    private String type;

    @Column(name = "consultant")
    private String consultant;

    @Column(name = "age")
    private BigDecimal age;

    @Column(name = "gender")
    private String gender;

    @Column(name = "address")
    private String address;
}
