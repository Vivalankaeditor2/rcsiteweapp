import Link from "next/link";
import { MAIN_NAV, SITE_NAME, SITE_TAGLINE } from "@/lib/site";

const YEAR = new Date().getFullYear();

/** Site footer: brand, section links and a small legal line. */
export function SiteFooter() {
  return (
    <footer className="mt-16 border-t border-line bg-white">
      <div className="mx-auto grid max-w-page gap-8 px-4 py-10 sm:px-6 md:grid-cols-3">
        <div>
          <p className="headline text-lg">{SITE_NAME}</p>
          <p className="mt-2 max-w-xs text-sm text-ink-mute">{SITE_TAGLINE}</p>
        </div>

        <nav aria-label="Footer">
          <h2 className="text-xs font-semibold uppercase tracking-wide text-ink-mute">Sections</h2>
          <ul className="mt-3 space-y-2">
            {MAIN_NAV.map((item) => (
              <li key={item.href}>
                <Link href={item.href} className="text-sm text-ink-soft hover:text-brand">
                  {item.label}
                </Link>
              </li>
            ))}
          </ul>
        </nav>

        <div>
          <h2 className="text-xs font-semibold uppercase tracking-wide text-ink-mute">VivaLanka</h2>
          <p className="mt-3 text-sm text-ink-mute">
            &copy; {YEAR} {SITE_NAME}. All rights reserved.
          </p>
        </div>
      </div>
    </footer>
  );
}
