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
 * One external feed the site polls. Charset latin1; {@code default_category_id}
 * is a plain scalar id (no FK - D-008).
 */
@Entity
@Table(name = "feed_channel")
@Getter
@Setter
public class FeedChannel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "name")
    private String name;

    @Column(name = "link")
    private String link;

    @Column(name = "poll_interval")
    private Long pollInterval;

    @Column(name = "feed_active")
    private Boolean feedActive;

    @Column(name = "feed_type")
    private String feedType;

    @Column(name = "poll_interval_min")
    private Long pollIntervalMin;

    @Column(name = "poll_interval_max")
    private Long pollIntervalMax;

    @Column(name = "source_site")
    private String sourceSite;

    @Column(name = "next_poll")
    private LocalDateTime nextPoll;

    @Column(name = "last_poll")
    private LocalDateTime lastPoll;

    @Column(name = "default_category_id")
    private Long defaultCategoryId;

    @Column(name = "comment")
    private String comment;
}
