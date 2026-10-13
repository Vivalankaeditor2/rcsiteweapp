package com.rev_creations.rcsite.service;

import com.rev_creations.rcsite.dto.FeedItemDto;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import javax.xml.XMLConstants;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import java.io.IOException;
import java.io.StringReader;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

/**
 * Parses an RSS 2.0 or Atom document into {@link FeedItemDto}s (the
 * {@code FeedGenerator} port). Parsing is namespace-prefix agnostic: elements
 * are matched on their local name, so {@code content:encoded}, {@code atom:id}
 * and their bare forms all resolve.
 *
 * <p>XXE is disabled (external entities and DTD loading are off) while a
 * {@code DOCTYPE} is still tolerated, because some real feeds declare one.
 * Items without a usable guid are dropped: without an identity the poller
 * cannot de-duplicate, and storing them would duplicate on every poll.
 */
@Component
public class FeedParser {

    private static final Logger log = LoggerFactory.getLogger(FeedParser.class);

    /** The legacy title column is varchar(255); keep writes inside it. */
    private static final int MAX_ID_LENGTH = 255;

    /**
     * Date formats seen in the wild: RFC 822 (RSS) and ISO-8601 offsets (Atom).
     * All are parsed as {@code OffsetDateTime} and converted to UTC.
     */
    private static final DateTimeFormatter[] OFFSET_FORMATTERS = {
            DateTimeFormatter.ofPattern("EEE, d MMM yyyy HH:mm:ss Z", Locale.ENGLISH),
            DateTimeFormatter.ofPattern("EEE, d MMM yyyy HH:mm:ss XX", Locale.ENGLISH),
            DateTimeFormatter.ofPattern("d MMM yyyy HH:mm:ss Z", Locale.ENGLISH),
            DateTimeFormatter.ISO_OFFSET_DATE_TIME,
            DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ssZ", Locale.ENGLISH),
    };

    /** Zone-less shapes, taken as wall-clock time. */
    private static final DateTimeFormatter[] LOCAL_FORMATTERS = {
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss", Locale.ENGLISH),
            DateTimeFormatter.ISO_LOCAL_DATE_TIME,
    };

    public List<FeedItemDto> parse(String xml) {
        if (xml == null || xml.isBlank()) {
            return List.of();
        }
        Document document;
        try {
            document = newDocumentBuilder().parse(new InputSource(new StringReader(xml)));
        } catch (SAXException | IOException | ParserConfigurationException ex) {
            log.warn("Feed parse failed: {}", ex.getMessage());
            return List.of();
        }
        Element root = document.getDocumentElement();
        if (root == null) {
            return List.of();
        }
        List<Element> items = descendantsByLocalName(root, "item");
        boolean atom = false;
        if (items.isEmpty()) {
            items = descendantsByLocalName(root, "entry");
            atom = true;
        }
        List<FeedItemDto> parsed = new ArrayList<>(items.size());
        for (Element item : items) {
            FeedItemDto dto = atom ? parseAtomEntry(item) : parseRssItem(item);
            if (dto != null) {
                parsed.add(dto);
            }
        }
        return parsed;
    }

    private FeedItemDto parseRssItem(Element item) {
        String guid = text(child(item, "guid"));
        String link = text(child(item, "link"));
        if (guid == null || guid.isBlank()) {
            // Fall back to the link as identity before giving up on the item.
            guid = link;
        }
        if (guid == null || guid.isBlank()) {
            return null;
        }
        Element encoded = child(item, "encoded");
        String content = encoded != null ? text(encoded) : null;
        return new FeedItemDto(
                truncate(guid),
                truncate(text(child(item, "title"))),
                truncate(link),
                text(child(item, "description")),
                content,
                parseDate(text(child(item, "pubDate"))),
                null);
    }

    private FeedItemDto parseAtomEntry(Element entry) {
        String guid = text(child(entry, "id"));
        String link = atomLink(entry);
        if (guid == null || guid.isBlank()) {
            guid = link;
        }
        if (guid == null || guid.isBlank()) {
            return null;
        }
        return new FeedItemDto(
                truncate(guid),
                truncate(text(child(entry, "title"))),
                truncate(link),
                text(child(entry, "summary")),
                text(child(entry, "content")),
                parseDate(text(child(entry, "published"))),
                parseDate(text(child(entry, "updated"))));
    }

    /** Atom's link is an {@code href} attribute; prefer {@code rel="alternate"}. */
    private String atomLink(Element entry) {
        String first = null;
        for (Element link : childrenByLocalName(entry, "link")) {
            String href = link.getAttribute("href");
            if (href == null || href.isBlank()) {
                continue;
            }
            String rel = link.getAttribute("rel");
            if (rel == null || rel.isBlank() || "alternate".equalsIgnoreCase(rel)) {
                return href;
            }
            if (first == null) {
                first = href;
            }
        }
        return first;
    }

    /**
     * Parses a feed date to UTC. An unparseable value yields {@code null} rather
     * than throwing: one bad date must not fail the whole poll. Zone-carrying
     * forms (RFC 822, ISO offsets) are converted to UTC; zone-less forms are
     * taken as wall-clock time.
     */
    public LocalDateTime parseDate(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }
        String trimmed = value.trim();
        String normalised = normaliseZone(trimmed);
        for (DateTimeFormatter formatter : OFFSET_FORMATTERS) {
            try {
                return java.time.OffsetDateTime.parse(normalised, formatter)
                        .withOffsetSameInstant(ZoneOffset.UTC).toLocalDateTime();
            } catch (DateTimeParseException ignored) {
                // Try the next shape.
            }
        }
        for (DateTimeFormatter formatter : LOCAL_FORMATTERS) {
            try {
                return LocalDateTime.parse(trimmed, formatter);
            } catch (DateTimeParseException ignored) {
                // Try the next shape.
            }
        }
        try {
            return LocalDate.parse(trimmed, DateTimeFormatter.ISO_LOCAL_DATE).atStartOfDay();
        } catch (DateTimeParseException ignored) {
            log.debug("Unparseable feed date: {}", trimmed);
            return null;
        }
    }

    /**
     * RFC 822 permits alphabetic zones ({@code GMT}, {@code EST}...). Maps the
     * common ones to a numeric offset so a single offset parser handles them.
     */
    private static String normaliseZone(String value) {
        return value.replaceAll("(?i)\\b(UTC|UT|GMT)\\b", "+0000")
                .replaceAll("(?i)\\b(EDT)\\b", "-0400")
                .replaceAll("(?i)\\b(EST|CDT)\\b", "-0500")
                .replaceAll("(?i)\\b(CST|MDT)\\b", "-0600")
                .replaceAll("(?i)\\b(MST|PDT)\\b", "-0700")
                .replaceAll("(?i)\\b(PST)\\b", "-0800");
    }

    private static DocumentBuilder newDocumentBuilder() throws ParserConfigurationException {
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        factory.setNamespaceAware(false);
        factory.setXIncludeAware(false);
        factory.setExpandEntityReferences(false);
        factory.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING, true);
        // Block XXE without rejecting a benign DOCTYPE declaration.
        setFeatureQuietly(factory, "http://xml.org/sax/features/external-general-entities", false);
        setFeatureQuietly(factory, "http://xml.org/sax/features/external-parameter-entities", false);
        setFeatureQuietly(factory, "http://apache.org/xml/features/nonvalidating/load-external-dtd", false);
        return factory.newDocumentBuilder();
    }

    private static void setFeatureQuietly(DocumentBuilderFactory factory, String feature, boolean value) {
        try {
            factory.setFeature(feature, value);
        } catch (ParserConfigurationException ignored) {
            // The parser does not know this feature; secure-processing still applies.
        }
    }

    // --- small DOM helpers (local-name matching, so prefixes do not matter) ---

    private static List<Element> childrenByLocalName(Element parent, String localName) {
        List<Element> result = new ArrayList<>();
        NodeList nodes = parent.getChildNodes();
        for (int i = 0; i < nodes.getLength(); i++) {
            Node node = nodes.item(i);
            if (node.getNodeType() == Node.ELEMENT_NODE
                    && localName.equalsIgnoreCase(localPart(node.getNodeName()))) {
                result.add((Element) node);
            }
        }
        return result;
    }

    private static Element child(Element parent, String localName) {
        List<Element> matches = childrenByLocalName(parent, localName);
        return matches.isEmpty() ? null : matches.get(0);
    }

    /** Depth-first search for child elements whose local name matches. */
    private static List<Element> descendantsByLocalName(Element parent, String localName) {
        List<Element> result = new ArrayList<>();
        NodeList nodes = parent.getChildNodes();
        for (int i = 0; i < nodes.getLength(); i++) {
            Node node = nodes.item(i);
            if (node.getNodeType() != Node.ELEMENT_NODE) {
                continue;
            }
            Element element = (Element) node;
            if (localName.equalsIgnoreCase(localPart(element.getNodeName()))) {
                result.add(element);
            } else {
                result.addAll(descendantsByLocalName(element, localName));
            }
        }
        return result;
    }

    private static String localPart(String name) {
        int colon = name.indexOf(':');
        return colon < 0 ? name : name.substring(colon + 1);
    }

    private static String text(Element element) {
        return element == null ? null : element.getTextContent();
    }

    private static String truncate(String value) {
        if (value == null || value.length() <= MAX_ID_LENGTH) {
            return value;
        }
        return value.substring(0, MAX_ID_LENGTH);
    }
}
