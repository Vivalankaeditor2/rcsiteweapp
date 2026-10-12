package com.rev_creations.rcsite.entity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

/** Small UI/content table (email header and footer). */
@Entity
@Table(name = "webui")
@Getter
@Setter
public class WebUi {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ui_id")
    private Long uiId;

    @Column(name = "email_header", columnDefinition = "text")
    private String emailHeader;

    @Column(name = "email_footer", columnDefinition = "text")
    private String emailFooter;
}
