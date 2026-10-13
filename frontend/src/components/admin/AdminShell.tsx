"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import { clearSession, fetchMe, loadSession, type AdminIdentity } from "@/lib/auth";
import { cn } from "@/lib/cn";

/**
 * Shell for the authenticated admin screens: re-validates the stored token on
 * mount (a token that the backend no longer accepts bounces to the login page)
 * and renders the section navigation plus the signed-in identity.
 */
const NAV = [
  { href: "/admin", label: "Overview" },
  { href: "/admin/articles", label: "Articles" },
  { href: "/admin/categories", label: "Categories" },
  { href: "/admin/feeds", label: "Feeds" },
  { href: "/admin/config", label: "Config" },
  { href: "/admin/email", label: "Email" },
];

export function AdminShell({ children }: { children: React.ReactNode }) {
  const router = useRouter();
  const pathname = usePathname();
  const [identity, setIdentity] = useState<AdminIdentity | null>(null);

  useEffect(() => {
    const session = loadSession();
    if (!session) {
      router.replace("/admin/login");
      return;
    }
    let active = true;
    fetchMe(session.token)
      .then((me) => {
        if (active) setIdentity(me);
      })
      .catch(() => {
        clearSession();
        router.replace("/admin/login");
      });
    return () => {
      active = false;
    };
  }, [router]);

  function signOut() {
    clearSession();
    router.replace("/admin/login");
  }

  return (
    <div className="mx-auto max-w-page px-4 py-6 sm:px-6">
      <div className="flex flex-wrap items-center justify-between gap-3 border-b border-line pb-3">
        <nav aria-label="Admin sections" className="flex flex-wrap gap-1">
          {NAV.map((item) => {
            const active = item.href === "/admin" ? pathname === "/admin" : pathname.startsWith(item.href);
            return (
              <Link
                key={item.href}
                href={item.href}
                aria-current={active ? "page" : undefined}
                className={cn(
                  "rounded px-3 py-2 text-sm font-semibold transition-colors",
                  active ? "bg-brand text-white" : "text-ink-soft hover:bg-brand-50 hover:text-brand",
                )}
              >
                {item.label}
              </Link>
            );
          })}
        </nav>
        <div className="flex items-center gap-3 text-sm">
          <span className="text-ink-mute">
            {identity ? identity.displayName || identity.username : "..."}
          </span>
          <button
            type="button"
            onClick={signOut}
            className="rounded border border-line px-3 py-1.5 font-medium text-ink-soft hover:border-brand hover:text-brand"
          >
            Sign out
          </button>
        </div>
      </div>
      <div className="py-6">{identity ? children : null}</div>
    </div>
  );
}
