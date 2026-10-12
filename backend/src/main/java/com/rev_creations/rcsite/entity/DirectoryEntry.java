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

/** A submitted link in the directory. */
@Entity
@Table(name = "directory")
@Getter
@Setter
public class DirectoryEntry {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "link_id")
    private Integer linkId;

    @Column(name = "entry_date", insertable = false, updatable = false)
    private LocalDateTime entryDate;

    @Column(name = "aproval_status")
    private String aprovalStatus;

    @Column(name = "url")
    private String url;

    @Column(name = "title")
    private String title;

    @Column(name = "description")
    private String description;

    @Column(name = "category1")
    private String category1;

    @Column(name = "category2")
    private String category2;

    @Column(name = "reciprocal_url")
    private String reciprocalUrl;

    @Column(name = "owner_name")
    private String ownerName;

    @Column(name = "owner_email")
    private String ownerEmail;

    @Column(name = "address1")
    private String address1;

    @Column(name = "address2")
    private String address2;

    @Column(name = "phone")
    private String phone;

    @Column(name = "dcode")
    private String dcode;
}
