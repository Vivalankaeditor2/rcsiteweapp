/** @type {import('next').NextConfig} */
const BACKEND_URL = (process.env.BACKEND_URL ?? "http://localhost:8080").replace(/\/$/, "");

const nextConfig = {
  reactStrictMode: true,
  // The public URL contract is served from the site root (D-003): /newspage/*,
  // /news/*, /n/p, /mobile/* all come from app routes, not a basePath.
  poweredByHeader: false,
  trailingSlash: false,
  // A 200 must never become a 301, so do not redirect trailing-slash variants.
  skipTrailingSlashRedirect: true,
  async rewrites() {
    // The Spring Boot backend owns the read APIs and generates the sitemaps from
    // articles (D-020, D-025). In production IIS reverse-proxies these paths to
    // WildFly; in dev/Next these rewrites stand in for that proxy.
    return [
      { source: "/api/:path*", destination: `${BACKEND_URL}/api/:path*` },
      // New additive public RSS path (the legacy feed had no stable public URL);
      // see D-033. The backend serves it at /api/rss.
      { source: "/rss", destination: `${BACKEND_URL}/api/rss` },
      { source: "/sitemapindex.xml", destination: `${BACKEND_URL}/sitemapindex.xml` },
      { source: "/sitemapindex04302022.xml", destination: `${BACKEND_URL}/sitemapindex04302022.xml` },
      { source: "/sitemap_:n([0-9]+).xml", destination: `${BACKEND_URL}/sitemap_:n.xml` },
    ];
  },
};

export default nextConfig;
