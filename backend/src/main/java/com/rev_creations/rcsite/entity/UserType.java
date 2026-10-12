package com.rev_creations.rcsite.entity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

/** Lookup of user roles. */
@Entity
@Table(name = "usertype")
@Getter
@Setter
public class UserType {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "usertypeid")
    private Long userTypeId;

    @Column(name = "usertypename")
    private String userTypeName;
}
