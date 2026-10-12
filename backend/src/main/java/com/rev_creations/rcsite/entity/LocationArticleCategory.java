package com.rev_creations.rcsite.entity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

/** Maps a location to the categories shown there. Plain scalar ids (no FK - D-008). */
@Entity
@Table(name = "location_article_category")
@Getter
@Setter
public class LocationArticleCategory {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "location_id")
    private Long locationId;

    @Column(name = "category_id")
    private Long categoryId;
}
