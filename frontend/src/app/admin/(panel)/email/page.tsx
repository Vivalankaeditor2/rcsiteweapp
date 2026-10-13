"use client";

import { useCallback, useEffect, useState } from "react";
import { adminFetch } from "@/lib/auth";
import type { PageDto } from "@/lib/api";
import { AdminHeading, Card, Field, Notice, PrimaryButton, inputClass } from "@/components/admin/ui";

interface EmailRow {
  emailId: number;
  enteredDate: string | null;
  toEmail: string | null;
  subject: string | null;
  type: string | null;
  folder: string | null;
}

const EMPTY = { toName: "", toEmail: "", subject: "", message: "", type: "newsletter" };

/**
 * The outbound email queue plus a compose form that stages a message in the
 * `email` table. Delivery is Phase 6 mail work; here it is only queued.
 */
export default function AdminEmailPage() {
  const [rows, setRows] = useState<EmailRow[]>([]);
  const [form, setForm] = useState(EMPTY);
  const [error, setError] = useState<string | null>(null);
  const [queued, setQueued] = useState(false);
  const [busy, setBusy] = useState(false);

  const load = useCallback(() => {
    adminFetch<PageDto<EmailRow>>("/api/admin/email?page=0&size=20")
      .then((result) => setRows(result.items))
      .catch((err) => setError(err instanceof Error ? err.message : "Could not load the queue"));
  }, []);

  useEffect(() => {
    load();
  }, [load]);

  function set<K extends keyof typeof EMPTY>(key: K, value: string) {
    setForm((prev) => ({ ...prev, [key]: value }));
  }

  async function onSubmit(event: React.FormEvent) {
    event.preventDefault();
    setBusy(true);
    setError(null);
    setQueued(false);
    try {
      await adminFetch("/api/admin/email", { method: "POST", body: JSON.stringify(form) });
      setQueued(true);
      setForm(EMPTY);
      load();
    } catch (err) {
      setError(err instanceof Error ? err.message : "Could not queue the email");
    } finally {
      setBusy(false);
    }
  }

  return (
    <>
      <AdminHeading title="Email" />
      {error ? <Notice kind="error">{error}</Notice> : null}
      {queued ? <Notice kind="ok">Email queued.</Notice> : null}

      <Card>
        <h2 className="headline text-lg">Compose</h2>
        <form onSubmit={onSubmit} className="mt-3 grid gap-4">
          <div className="grid gap-4 sm:grid-cols-2">
            <Field label="To (name)">
              <input className={inputClass} value={form.toName} onChange={(e) => set("toName", e.target.value)} />
            </Field>
            <Field label="To (email)">
              <input
                className={inputClass}
                type="email"
                value={form.toEmail}
                onChange={(e) => set("toEmail", e.target.value)}
                required
              />
            </Field>
          </div>
          <Field label="Subject">
            <input className={inputClass} value={form.subject} onChange={(e) => set("subject", e.target.value)} required />
          </Field>
          <Field label="Message">
            <textarea
              className={inputClass}
              rows={6}
              value={form.message}
              onChange={(e) => set("message", e.target.value)}
            />
          </Field>
          <div>
            <PrimaryButton type="submit" disabled={busy}>
              {busy ? "Queueing..." : "Queue email"}
            </PrimaryButton>
          </div>
        </form>
      </Card>

      <Card>
        <h2 className="headline text-lg">Queue</h2>
        <div className="mt-3 overflow-x-auto">
          <table className="w-full text-left text-sm">
            <thead className="border-b border-line text-xs uppercase tracking-wide text-ink-mute">
              <tr>
                <th className="py-2 pr-3">ID</th>
                <th className="py-2 pr-3">To</th>
                <th className="py-2 pr-3">Subject</th>
                <th className="py-2 pr-3">Folder</th>
                <th className="py-2">Type</th>
              </tr>
            </thead>
            <tbody>
              {rows.map((row) => (
                <tr key={row.emailId} className="border-b border-line/60">
                  <td className="py-2 pr-3 text-ink-mute">{row.emailId}</td>
                  <td className="py-2 pr-3">{row.toEmail}</td>
                  <td className="py-2 pr-3">{row.subject}</td>
                  <td className="py-2 pr-3 text-ink-mute">{row.folder ?? "-"}</td>
                  <td className="py-2 text-ink-mute">{row.type ?? "-"}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </Card>
    </>
  );
}
