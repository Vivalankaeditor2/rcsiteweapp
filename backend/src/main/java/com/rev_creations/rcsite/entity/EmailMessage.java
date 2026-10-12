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

/** Outbound email queue. ({@code user} is the legacy column name.) */
@Entity
@Table(name = "email")
@Getter
@Setter
public class EmailMessage {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "emailid")
    private Long emailId;

    @Column(name = "entered_date", insertable = false, updatable = false)
    private LocalDateTime enteredDate;

    @Column(name = "from_name")
    private String fromName;

    @Column(name = "from_email")
    private String fromEmail;

    @Column(name = "to_name")
    private String toName;

    @Column(name = "to_email")
    private String toEmail;

    @Column(name = "subject")
    private String subject;

    @Column(name = "type")
    private String type;

    @Column(name = "attachment")
    private String attachment;

    @Column(name = "message", columnDefinition = "text")
    private String message;

    @Column(name = "description")
    private String description;

    @Column(name = "folder")
    private String folder;

    @Column(name = "user")
    private String user;
}
