package com.rev_creations.rcsite.entity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

/** Send results for a queued email. {@code emailid} is a plain scalar id (no FK). */
@Entity
@Table(name = "email_report")
@Getter
@Setter
public class EmailReport {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "reportid")
    private Long reportId;

    @Column(name = "emailid")
    private Long emailId;

    @Column(name = "sent_emails", columnDefinition = "text")
    private String sentEmails;

    @Column(name = "failed_emails", columnDefinition = "text")
    private String failedEmails;

    @Column(name = "error_mesg")
    private String errorMessage;
}
