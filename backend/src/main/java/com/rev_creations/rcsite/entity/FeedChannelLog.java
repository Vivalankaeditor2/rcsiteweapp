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

/** Feed poll log / errors. {@code channel_id} is a plain scalar id (no FK - D-008). */
@Entity
@Table(name = "feed_channel_log")
@Getter
@Setter
public class FeedChannelLog {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "channel_id")
    private Long channelId;

    @Column(name = "log_time")
    private LocalDateTime logTime;

    @Column(name = "location")
    private String location;

    @Column(name = "severity")
    private String severity;

    @Column(name = "message")
    private String message;

    @Column(name = "trace", columnDefinition = "text")
    private String trace;
}
