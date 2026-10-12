package com.rev_creations.rcsite.entity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;
import java.io.Serializable;
import java.util.Objects;

/**
 * Link table between categories and feed channels. Composite key
 * ({@code category_id}, {@code channel_id}) - no surrogate id.
 */
@Entity
@Table(name = "article_category_has_feed_channel")
@IdClass(ArticleCategoryFeedChannel.Key.class)
@Getter
@Setter
public class ArticleCategoryFeedChannel {
    @Id
    @Column(name = "category_id")
    private Long categoryId;

    @Id
    @Column(name = "channel_id")
    private Long channelId;

    /** Composite primary key. */
    @Getter
    @Setter
    public static class Key implements Serializable {
        private Long categoryId;

        private Long channelId;

        public Key() {
        }

        public Key(Long categoryId, Long channelId) {
            this.categoryId = categoryId;
            this.channelId = channelId;
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) {
                return true;
            }
            if (!(o instanceof Key other)) {
                return false;
            }
            return Objects.equals(categoryId, other.categoryId)
                    && Objects.equals(channelId, other.channelId);
        }

        @Override
        public int hashCode() {
            return Objects.hash(categoryId, channelId);
        }
    }
}
