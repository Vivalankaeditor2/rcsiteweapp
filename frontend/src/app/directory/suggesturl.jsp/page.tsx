import type { Metadata } from "next";
import { PhaseNotice } from "@/components/PhaseNotice";

/**
 * Legacy {@code /directory/suggesturl.jsp}. This URL is part of the frozen
 * contract, but no {@code directory/} source exists in the legacy tree to port
 * verbatim, so the page is a URL-preserving shell: it asks the same kind of
 * question (submit a URL for the directory) and states plainly that the
 * submission flow is not wired yet. Resolve the real behaviour with the owner
 * before implementing it.
 */
export const dynamic = "force-dynamic";

export const metadata: Metadata = { title: "Suggest a URL" };

export default function SuggestUrl() {
  return (
    <main className="mx-auto max-w-md px-4 py-8 sm:px-6">
      <h1 className="headline border-b border-line pb-2 text-2xl">Suggest a URL</h1>

      <PhaseNotice>
        The directory submission flow is not implemented yet; this page preserves the URL
        only. Confirm the intended behaviour before wiring the form.
      </PhaseNotice>

      <form className="mt-6 grid gap-4" aria-disabled="true">
        <div>
          <label htmlFor="url" className="block text-sm font-medium">
            URL
          </label>
          <input
            id="url"
            name="url"
            type="url"
            className="mt-1 w-full rounded border border-line px-3 py-2 text-sm"
          />
        </div>
        <div>
          <label htmlFor="email" className="block text-sm font-medium">
            Your Email
          </label>
          <input
            id="email"
            name="email"
            type="email"
            className="mt-1 w-full rounded border border-line px-3 py-2 text-sm"
          />
        </div>
        <div>
          <label htmlFor="comment" className="block text-sm font-medium">
            Comment
          </label>
          <textarea
            id="comment"
            name="comment"
            rows={4}
            className="mt-1 w-full rounded border border-line px-3 py-2 text-sm"
          />
        </div>
        <div>
          <button
            type="submit"
            disabled
            className="rounded bg-brand px-4 py-2 text-sm font-semibold text-white disabled:opacity-50"
          >
            Submit
          </button>
        </div>
      </form>
    </main>
  );
}
