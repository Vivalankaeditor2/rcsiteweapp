"use client";

import { useState } from "react";
import Link from "next/link";
import { Menu, X, Search } from "lucide-react";
import { MAIN_NAV, SITE_NAME } from "@/lib/site";
import { cn } from "@/lib/cn";

/**
 * Site header: brand logo, primary navigation and a search entry point. Sticky
 * on desktop, collapsible on mobile. Navigation is keyboard operable and the
 * toggle exposes its state to assistive tech.
 */
export function SiteHeader() {
  const [open, setOpen] = useState(false);

  return (
    <header className="sticky top-0 z-40 border-b border-line bg-white/95 backdrop-blur supports-[backdrop-filter]:bg-white/80">
      <div className="mx-auto flex h-16 max-w-page items-center gap-4 px-4 sm:px-6">
        <Link href="/" className="flex shrink-0 items-center" aria-label={`${SITE_NAME} home`}>
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img
            src="/custom/template_files/vivalankalogo.png"
            alt={SITE_NAME}
            className="h-10 w-auto"
            width={160}
            height={40}
          />
        </Link>

        <nav aria-label="Primary" className="ml-auto hidden md:block">
          <ul className="flex items-center gap-1">
            {MAIN_NAV.map((item) => (
              <li key={item.href}>
                <Link
                  href={item.href}
                  className="rounded px-3 py-2 text-sm font-semibold text-ink-soft transition-colors hover:bg-brand-50 hover:text-brand"
                >
                  {item.label}
                </Link>
              </li>
            ))}
          </ul>
        </nav>

        <form action="/search" method="get" role="search" className="ml-auto hidden md:flex">
          <label htmlFor="header-search" className="sr-only">
            Search news
          </label>
          <div className="flex items-center rounded border border-line focus-within:border-brand">
            <input
              id="header-search"
              type="search"
              name="q"
              placeholder="Search news"
              className="w-40 bg-transparent px-3 py-2 text-sm outline-none lg:w-56"
            />
            <button
              type="submit"
              aria-label="Search"
              className="px-3 py-2 text-ink-mute hover:text-brand"
            >
              <Search className="h-4 w-4" aria-hidden="true" />
            </button>
          </div>
        </form>

        <button
          type="button"
          className="ml-auto rounded p-2 text-ink-soft hover:bg-brand-50 md:hidden"
          aria-expanded={open}
          aria-controls="mobile-nav"
          aria-label={open ? "Close menu" : "Open menu"}
          onClick={() => setOpen((value) => !value)}
        >
          {open ? <X className="h-6 w-6" /> : <Menu className="h-6 w-6" />}
        </button>
      </div>

      <div
        id="mobile-nav"
        className={cn("border-t border-line bg-white md:hidden", open ? "block" : "hidden")}
      >
        <nav aria-label="Primary mobile" className="mx-auto max-w-page px-4 py-2 sm:px-6">
          <ul className="flex flex-col">
            {MAIN_NAV.map((item) => (
              <li key={item.href}>
                <Link
                  href={item.href}
                  className="block rounded px-3 py-3 text-base font-semibold text-ink-soft hover:bg-brand-50 hover:text-brand"
                  onClick={() => setOpen(false)}
                >
                  {item.label}
                </Link>
              </li>
            ))}
          </ul>
        </nav>
      </div>
    </header>
  );
}
