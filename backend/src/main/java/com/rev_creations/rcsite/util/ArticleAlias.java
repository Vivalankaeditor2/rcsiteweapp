package com.rev_creations.rcsite.util;

/**
 * Builds an article {@code alias} from its title, matching the legacy
 * {@code administrator/articleadd.jsp} rule: lower-case, every run of characters
 * outside {@code [a-z0-9]} becomes a single dash, no leading/trailing dash.
 * The alias is part of the frozen public URL (D-003), so the rule is reproduced
 * exactly rather than reinvented.
 */
public final class ArticleAlias {

    private ArticleAlias() {
    }

    public static String fromTitle(String title) {
        if (title == null) {
            return null;
        }
        String slug = title.trim().toLowerCase()
                .replaceAll("[^a-z0-9]+", "-")
                .replaceAll("^-+", "")
                .replaceAll("-+$", "");
        return slug.isEmpty() ? null : slug;
    }
}
