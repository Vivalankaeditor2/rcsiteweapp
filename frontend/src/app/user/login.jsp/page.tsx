import type { Metadata } from "next";
import { PhaseNotice } from "@/components/PhaseNotice";

/**
 * Legacy {@code /user/login.jsp}. Preserved at its exact path (D-003) with the
 * legacy form fields (username, password). Authentication itself is Phase 7
 * (D-022, against {@code rc_customer}); the submit is not wired yet and is
 * disabled rather than posting credentials to an endpoint that does not exist.
 */
export const dynamic = "force-dynamic";

export const metadata: Metadata = { title: "Login" };

export default function Login() {
  return (
    <main className="mx-auto max-w-md px-4 py-8 sm:px-6">
      <h1 className="headline border-b border-line pb-2 text-2xl">Login</h1>

      <PhaseNotice>
        Sign-in is being rebuilt in a later phase; this page preserves the URL and the
        form layout, but it does not authenticate yet.
      </PhaseNotice>

      <form className="mt-6 grid gap-4" aria-disabled="true">
        <div>
          <label htmlFor="username" className="block text-sm font-medium">
            Username
          </label>
          <input
            id="username"
            name="username"
            type="text"
            autoComplete="username"
            className="mt-1 w-full rounded border border-line px-3 py-2 text-sm"
          />
        </div>
        <div>
          <label htmlFor="password" className="block text-sm font-medium">
            Password
          </label>
          <input
            id="password"
            name="password"
            type="password"
            autoComplete="current-password"
            className="mt-1 w-full rounded border border-line px-3 py-2 text-sm"
          />
        </div>
        <div>
          <button
            type="submit"
            disabled
            className="rounded bg-brand px-4 py-2 text-sm font-semibold text-white disabled:opacity-50"
          >
            Login
          </button>
        </div>
      </form>
    </main>
  );
}
