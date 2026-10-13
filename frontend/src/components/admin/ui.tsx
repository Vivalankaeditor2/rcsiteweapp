/** Small shared primitives for the admin screens (Phase 7). */

export function AdminHeading({ title, children }: { title: string; children?: React.ReactNode }) {
  return (
    <div className="mb-4 flex flex-wrap items-center justify-between gap-3">
      <h1 className="headline text-2xl">{title}</h1>
      {children}
    </div>
  );
}

export function Notice({ kind = "info", children }: { kind?: "info" | "error" | "ok"; children: React.ReactNode }) {
  const palette =
    kind === "error"
      ? "border-red-200 bg-red-50 text-red-700"
      : kind === "ok"
        ? "border-green-200 bg-green-50 text-green-700"
        : "border-line bg-brand-50 text-ink-soft";
  return (
    <p role={kind === "error" ? "alert" : undefined} className={`rounded border px-3 py-2 text-sm ${palette}`}>
      {children}
    </p>
  );
}

export function Card({ children }: { children: React.ReactNode }) {
  return <div className="rounded-lg border border-line bg-white p-5 shadow-sm">{children}</div>;
}

/** A labelled form field with a consistent look. */
export function Field({
  label,
  hint,
  children,
}: {
  label: string;
  hint?: string;
  children: React.ReactNode;
}) {
  return (
    <label className="block text-sm font-medium text-ink-soft">
      {label}
      {children}
      {hint ? <span className="mt-1 block text-xs font-normal text-ink-mute">{hint}</span> : null}
    </label>
  );
}

export const inputClass =
  "mt-1 w-full rounded border border-line px-3 py-2 text-ink outline-none focus:border-brand";

export function PrimaryButton({
  children,
  ...props
}: React.ButtonHTMLAttributes<HTMLButtonElement>) {
  return (
    <button
      {...props}
      className="rounded bg-brand px-4 py-2 font-semibold text-white transition-colors hover:bg-brand-dark disabled:opacity-60"
    >
      {children}
    </button>
  );
}
