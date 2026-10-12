package com.rev_creations.rcsite.entity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

/** Per-user preferences. {@code username} is unique (plain scalar; no FK - D-008). */
@Entity
@Table(name = "preferences")
@Getter
@Setter
public class Preference {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "entryid")
    private Long entryId;

    @Column(name = "username")
    private String username;

    @Column(name = "pref1")
    private String pref1;

    @Column(name = "pref2")
    private String pref2;

    @Column(name = "pref3")
    private String pref3;

    @Column(name = "pref4")
    private String pref4;

    @Column(name = "phone")
    private String phone;

    @Column(name = "best_time_call")
    private String bestTimeCall;

    @Column(name = "entered_date", insertable = false, updatable = false)
    private LocalDateTime enteredDate;
}
