import type { ReactNode } from "react";

/**
 * A visible, honest banner for a legacy URL that is preserved now but whose
 * interactive behaviour belongs to a later phase. It exists so the page can be
 * served at its exact path (D-003) without pretending the action already works -
 * no silent no-op form is shipped.
 */
export function PhaseNotice({ children }: { children: ReactNode }) {
  return (
    <p
      role="note"
      className="mt-6 rounded-lg border border-dashed border-line bg-brand-50 p-4 text-sm text-ink-soft"
    >
      {children}
    </p>
  );
}
