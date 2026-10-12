package com.rev_creations.rcsite.entity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

/**
 * One article category. {@code parentid} is a self-referencing scalar id kept
 * as a plain field (MyISAM, no FKs - D-008). Charset is latin1: avoid storing
 * non-ASCII here.
 */
@Entity
@Table(name = "article_category")
@Getter
@Setter
public class ArticleCategory {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "categoryid")
    private Integer categoryId;

    @Column(name = "parentid")
    private Integer parentId;

    @Column(name = "category_name")
    private String categoryName;

    @Column(name = "title")
    private String title;

    @Column(name = "description")
    private String description;

    @Column(name = "level")
    private String level;

    @Column(name = "priority")
    private Integer priority;

    @Column(name = "active")
    private String active;
}
