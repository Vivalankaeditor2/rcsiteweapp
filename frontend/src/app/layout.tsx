import type { Metadata } from "next";
import type { ReactNode } from "react";
import "./globals.css";
import { SiteHeader } from "@/components/SiteHeader";
import { SiteFooter } from "@/components/SiteFooter";
import { SITE_NAME, SITE_TAGLINE } from "@/lib/site";
import { SITE_URL } from "@/lib/article";

export const metadata: Metadata = {
  metadataBase: new URL(SITE_URL),
  // No title template: the legacy article <title> is the raw headline with no
  // site suffix, and that head is part of the byte-faithful contract (D-003).
  title: SITE_NAME,
  description: SITE_TAGLINE,
  icons: { icon: "/custom/template_files/vivalankalogo.png" },
};

export default function RootLayout({ children }: { children: ReactNode }) {
  return (
    <html lang="en">
      <body className="flex min-h-screen flex-col">
        <a
          href="#main"
          className="sr-only focus:not-sr-only focus:absolute focus:left-4 focus:top-4 focus:z-50 focus:rounded focus:bg-white focus:px-4 focus:py-2 focus:shadow"
        >
          Skip to content
        </a>
        <SiteHeader />
        <div id="main" className="flex-1">
          {children}
        </div>
        <SiteFooter />
      </body>
    </html>
  );
}
