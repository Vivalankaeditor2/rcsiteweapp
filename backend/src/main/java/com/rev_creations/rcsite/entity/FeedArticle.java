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
 * One raw item pulled from a feed (staging before it becomes an article).
 * {@code channel_id} is a plain scalar id (no FK - D-008).
 */
@Entity
@Table(name = "feed_article")
@Getter
@Setter
public class FeedArticle {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "channel_id")
    private Long channelId;

    @Column(name = "guid")
    private String guid;

    @Column(name = "title")
    private String title;

    @Column(name = "link")
    private String link;

    @Column(name = "description", columnDefinition = "text")
    private String description;

    /** Set by the database default (ON UPDATE); excluded from inserts/updates. */
    @Column(name = "received", insertable = false, updatable = false)
    private LocalDateTime received;

    @Column(name = "published")
    private LocalDateTime published;

    @Column(name = "updated")
    private LocalDateTime updated;

    @Column(name = "processed")
    private Integer processed;

    @Column(name = "details", columnDefinition = "text")
    private String details;
}
