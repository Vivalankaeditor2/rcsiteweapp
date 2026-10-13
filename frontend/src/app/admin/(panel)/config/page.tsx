"use client";

import { useEffect, useState } from "react";
import { updateConfig } from "@/lib/admin-api";
import { BACKEND_URL } from "@/lib/api";
import { AdminHeading, Card, Notice, PrimaryButton, inputClass } from "@/components/admin/ui";

interface ConfigRow {
  configKey: string;
  value: string | null;
  description: string | null;
  siteArea: string | null;
  active: number | null;
}

/** Site settings; each row is editable and saved individually (cache evicted). */
export default function AdminConfigPage() {
  const [rows, setRows] = useState<ConfigRow[]>([]);
  const [draft, setDraft] = useState<Record<string, string>>({});
  const [error, setError] = useState<string | null>(null);
  const [savedKey, setSavedKey] = useState<string | null>(null);
  const [busyKey, setBusyKey] = useState<string | null>(null);

  useEffect(() => {
    fetch(`${BACKEND_URL}/api/config`, { cache: "no-store" })
      .then((r) => (r.ok ? r.json() : []))
      .then((data: ConfigRow[]) => {
        setRows(data);
        setDraft(Object.fromEntries(data.map((row) => [row.configKey, row.value ?? ""])));
      })
      .catch(() => setError("Could not load settings"));
  }, []);

  async function save(key: string) {
    setBusyKey(key);
    setError(null);
    setSavedKey(null);
    try {
      await updateConfig(key, { value: draft[key] ?? "" });
      setSavedKey(key);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Save failed");
    } finally {
      setBusyKey(null);
    }
  }

  return (
    <>
      <AdminHeading title="Config" />
      {error ? <Notice kind="error">{error}</Notice> : null}
      {savedKey ? <Notice kind="ok">Saved {savedKey}.</Notice> : null}

      <Card>
        {rows.length === 0 ? (
          <p className="text-sm text-ink-mute">No settings.</p>
        ) : (
          <div className="space-y-4">
            {rows.map((row) => (
              <div key={row.configKey} className="grid gap-2 border-b border-line/60 pb-4 sm:grid-cols-[260px_1fr_auto] sm:items-end">
                <div>
                  <div className="text-sm font-semibold text-ink">{row.configKey}</div>
                  {row.description ? <div className="text-xs text-ink-mute">{row.description}</div> : null}
                </div>
                <input
                  className={inputClass}
                  value={draft[row.configKey] ?? ""}
                  onChange={(e) => setDraft((prev) => ({ ...prev, [row.configKey]: e.target.value }))}
                />
                <PrimaryButton type="button" disabled={busyKey === row.configKey} onClick={() => save(row.configKey)}>
                  {busyKey === row.configKey ? "Saving..." : "Save"}
                </PrimaryButton>
              </div>
            ))}
          </div>
        )}
      </Card>
    </>
  );
}
