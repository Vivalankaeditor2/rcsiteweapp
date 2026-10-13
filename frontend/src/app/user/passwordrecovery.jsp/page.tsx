import type { Metadata } from "next";
import { PhaseNotice } from "@/components/PhaseNotice";

/**
 * Legacy {@code /user/passwordrecovery.jsp}. Preserved at its exact path with the
 * {@code username}/{@code email} fields the legacy page used. The recovery mail
 * flow is a later-phase concern; the form is not wired yet.
 */
export const dynamic = "force-dynamic";

export const metadata: Metadata = { title: "Password Recovery" };

export default function PasswordRecovery() {
  return (
    <main className="mx-auto max-w-md px-4 py-8 sm:px-6">
      <h1 className="headline border-b border-line pb-2 text-2xl">Password Recovery</h1>

      <PhaseNotice>
        Password recovery is being rebuilt in a later phase; this page preserves the URL
        and the form layout, but it does not send mail yet.
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
          <label htmlFor="email" className="block text-sm font-medium">
            Email
          </label>
          <input
            id="email"
            name="email"
            type="email"
            autoComplete="email"
            className="mt-1 w-full rounded border border-line px-3 py-2 text-sm"
          />
        </div>
        <div>
          <button
            type="submit"
            disabled
            className="rounded bg-brand px-4 py-2 text-sm font-semibold text-white disabled:opacity-50"
          >
            Recover
          </button>
        </div>
      </form>
    </main>
  );
}
