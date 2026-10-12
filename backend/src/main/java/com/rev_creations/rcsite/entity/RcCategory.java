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

/** A user-submitted category. Distinct from {@code article_category}. */
@Entity
@Table(name = "rc_category")
@Getter
@Setter
public class RcCategory {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "category_id")
    private Integer categoryId;

    @Column(name = "entry_date", insertable = false, updatable = false)
    private LocalDateTime entryDate;

    @Column(name = "aproval_status")
    private String aprovalStatus;

    @Column(name = "category_name")
    private String categoryName;

    @Column(name = "description")
    private String description;

    @Column(name = "submit_url")
    private String submitUrl;

    @Column(name = "submit_name")
    private String submitName;

    @Column(name = "submit_email")
    private String submitEmail;
}
