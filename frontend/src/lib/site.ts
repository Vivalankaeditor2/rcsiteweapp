/**
 * Site-wide constants and public navigation. URLs here are part of the frozen
 * URL contract (D-003); changing one is a breaking change to SEO.
 */

export const SITE_NAME = "VivaLanka";

export const SITE_TAGLINE = "Latest news from Sri Lanka and around the world";

export interface NavLink {
  label: string;
  href: string;
}

/**
 * Top-level navigation, mirroring the sections of the legacy site. Categories
 * with content are reached through these public listing URLs.
 */
export const MAIN_NAV: NavLink[] = [
  { label: "Home", href: "/" },
  { label: "Breaking News", href: "/news/page.jsp" },
  { label: "World", href: "/news/worldnews.jsp" },
  { label: "Sinhala", href: "/news/Sinhala.jsp" },
  { label: "Contact", href: "/news/contactus.jsp" },
];

/** A branded placeholder shown when an article has no usable image. */
export const IMAGE_PLACEHOLDER = "/custom/template_files/vivalankalogo.png";
