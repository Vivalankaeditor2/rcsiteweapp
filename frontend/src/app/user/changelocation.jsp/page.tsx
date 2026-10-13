import type { Metadata } from "next";
import { PhaseNotice } from "@/components/PhaseNotice";

/**
 * Legacy {@code /user/changelocation.jsp}. The legacy page resolved the visitor's
 * country/region through the MaxMind GeoIP database and let them override it.
 * This page is preserved at its exact path (D-003); the GeoIP-driven picker is a
 * later-phase concern (the {@code geo_location}/{@code geo_block} tables are
 * read-only and empty locally), so the selects are shown but not wired.
 */
export const dynamic = "force-dynamic";

export const metadata: Metadata = { title: "Change Location" };

export default function ChangeLocation() {
  return (
    <main className="mx-auto max-w-md px-4 py-8 sm:px-6">
      <h1 className="headline border-b border-line pb-2 text-2xl">Change Location</h1>

      <PhaseNotice>
        Resolving your country and region is being rebuilt in a later phase; this page
        preserves the URL and the form layout.
      </PhaseNotice>

      <form className="mt-6 grid gap-4" aria-disabled="true">
        <div>
          <label htmlFor="countryCode" className="block text-sm font-medium">
            Country
          </label>
          <select
            id="countryCode"
            name="countryCode"
            className="mt-1 w-full rounded border border-line px-3 py-2 text-sm"
          >
            <option value="">Select a country</option>
          </select>
        </div>
        <div>
          <label htmlFor="region" className="block text-sm font-medium">
            Region
          </label>
          <select
            id="region"
            name="region"
            className="mt-1 w-full rounded border border-line px-3 py-2 text-sm"
          >
            <option value="">Select a region</option>
          </select>
        </div>
        <div>
          <button
            type="submit"
            disabled
            className="rounded bg-brand px-4 py-2 text-sm font-semibold text-white disabled:opacity-50"
          >
            Save
          </button>
        </div>
      </form>
    </main>
  );
}
