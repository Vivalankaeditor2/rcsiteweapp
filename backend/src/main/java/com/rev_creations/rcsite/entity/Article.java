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

/**
 * One news article (the main content table). Left as plain fields on purpose:
 * the table is MyISAM with no foreign keys (D-008), so there are no JPA
 * relationships. {@code categoryid} and {@code feed_channel_id} are kept as
 * scalar ids.
 */
@Entity
@Table(name = "articles")
@Getter
@Setter
public class Article {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "article_id")
    private Integer articleId;

    @Column(name = "title")
    private String title;

    @Column(name = "description", columnDefinition = "text")
    private String description;

    @Column(name = "image")
    private String image;

    @Column(name = "details", columnDefinition = "text")
    private String details;

    @Column(name = "author_name")
    private String authorName;

    @Column(name = "author_intro", columnDefinition = "tinytext")
    private String authorIntro;

    /** Set by the database default; excluded from inserts/updates. */
    @Column(name = "entry_date", insertable = false, updatable = false)
    private LocalDateTime entryDate;

    @Column(name = "published")
    private LocalDateTime published;

    @Column(name = "updated")
    private LocalDateTime updated;

    @Column(name = "aproval_status")
    private String aprovalStatus;

    @Column(name = "editor_name")
    private String editorName;

    @Column(name = "editor_email")
    private String editorEmail;

    @Column(name = "categoryid")
    private Integer categoryId;

    @Column(name = "dcode")
    private String dcode;

    @Column(name = "url")
    private String url;

    @Column(name = "feed_channel_id")
    private Long feedChannelId;

    @Column(name = "process_status")
    private String processStatus;

    @Column(name = "alias")
    private String alias;

    @Column(name = "thumbnail")
    private String thumbnail;

    @Column(name = "keywords")
    private String keywords;
}
