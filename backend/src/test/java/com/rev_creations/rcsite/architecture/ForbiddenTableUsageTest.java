package com.rev_creations.rcsite.architecture;

import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.junit.jupiter.api.Assumptions.assumeTrue;

/**
 * Guard for D-019: the news application must never reference
 * {@code article_category_has_articles}. That table is owned by another process
 * (the Solr indexer / commerce); touching it would cause double-writes and
 * surprising index behaviour.
 *
 * <p>The test fails if the table name appears anywhere in the production
 * sources. Add legitimate exceptions only with an owner-approved decision.
 */
class ForbiddenTableUsageTest {

    private static final String FORBIDDEN_TABLE = "article_category_has_articles";

    private static final List<String> SCANNED_EXTENSIONS =
            List.of(".java", ".sql", ".xml", ".properties", ".yml", ".yaml");

    @Test
    void should_not_reference_forbidden_table_when_scanning_production_sources() throws IOException {
        Path productionSources = Paths.get("src", "main");
        assumeTrue(Files.exists(productionSources), "src/main is not present");

        List<String> offenders = new ArrayList<>();
        try (Stream<Path> paths = Files.walk(productionSources)) {
            for (Path file : paths.filter(Files::isRegularFile).collect(Collectors.toList())) {
                if (SCANNED_EXTENSIONS.stream().noneMatch(file.toString()::endsWith)) {
                    continue;
                }
                if (Files.readString(file).contains(FORBIDDEN_TABLE)) {
                    offenders.add(productionSources.relativize(file).toString());
                }
            }
        }

        assertTrue(offenders.isEmpty(),
                "Forbidden table '" + FORBIDDEN_TABLE + "' referenced (D-019). "
                        + "It is owned by another process; the news app must not touch it. "
                        + "Offenders: " + offenders);
    }
}
