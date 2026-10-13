import type { Metadata } from "next";
import { PhaseNotice } from "@/components/PhaseNotice";

/**
 * Legacy {@code /news/contactus.jsp?articleid=}. The page is preserved at its
 * exact path (D-003) with the same form fields the legacy page rendered
 * (message, company, name, email, street, city, state, postalcode, country,
 * phone). The legacy page sent this by SMTP (Recaptcha-protected); outbound mail
 * is a Phase 6 concern, so the submit is not wired yet and the form is marked
 * {@code aria-disabled} rather than shipping a silent no-op.
 */
export const dynamic = "force-dynamic";

export const metadata: Metadata = { title: "Contact Us" };

const FIELDS = [
  { name: "company", label: "Company" },
  { name: "name", label: "Name" },
  { name: "email", label: "Email" },
  { name: "street", label: "Street" },
  { name: "city", label: "City" },
  { name: "state", label: "State" },
  { name: "postalcode", label: "Postal Code" },
  { name: "country", label: "Country" },
  { name: "phone", label: "Phone" },
];

export default function ContactUs() {
  return (
    <main className="mx-auto max-w-3xl px-4 py-8 sm:px-6">
      <h1 className="headline border-b border-line pb-2 text-2xl">Contact Us</h1>

      <PhaseNotice>
        Contact submissions are handled by the mail service in a later phase; the form
        is shown here so this legacy URL keeps resolving, but it does not send yet.
      </PhaseNotice>

      <form className="mt-6 grid gap-4" aria-disabled="true">
        <div>
          <label htmlFor="message" className="block text-sm font-medium">
            Message
          </label>
          <textarea
            id="message"
            name="message"
            rows={5}
            className="mt-1 w-full rounded border border-line px-3 py-2 text-sm"
          />
        </div>
        {FIELDS.map((field) => (
          <div key={field.name}>
            <label htmlFor={field.name} className="block text-sm font-medium">
              {field.label}
            </label>
            <input
              id={field.name}
              name={field.name}
              type="text"
              className="mt-1 w-full rounded border border-line px-3 py-2 text-sm"
            />
          </div>
        ))}
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
