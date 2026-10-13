"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { adminFetch } from "@/lib/auth";
import type { FeedChannelDto } from "@/lib/api";
import { AdminHeading, Card, Notice, PrimaryButton } from "@/components/admin/ui";
import { formatDate } from "@/lib/format";

interface FeedLog {
  id: number;
  channelId: number | null;
  logTime: string | null;
  location: string | null;
  severity: string | null;
  message: string | null;
  trace: string | null;
}

interface PollResult {
  ok: boolean;
  fetched: number;
  stored: number;
  message: string | null;
}

/** Feed channels: inspect them, see the last polls, and trigger a poll now. */
export default function AdminFeedsPage() {
  const [feeds, setFeeds] = useState<FeedChannelDto[]>([]);
  const [error, setError] = useState<string | null>(null);
  const [openId, setOpenId] = useState<number | null>(null);
  const [logs, setLogs] = useState<FeedLog[]>([]);
  const [pollResult, setPollResult] = useState<PollResult | null>(null);
  const [busyId, setBusyId] = useState<number | null>(null);

  useEffect(() => {
    adminFetch<FeedChannelDto[]>("/api/feeds")
      .then(setFeeds)
      .catch((err) => setError(err instanceof Error ? err.message : "Could not load feeds"));
  }, []);

  async function toggleLogs(id: number) {
    if (openId === id) {
      setOpenId(null);
      return;
    }
    setOpenId(id);
    setLogs([]);
    try {
      setLogs(await adminFetch<FeedLog[]>(`/api/feeds/${id}/log`));
    } catch (err) {
      setError(err instanceof Error ? err.message : "Could not load the log");
    }
  }

  async function poll(id: number) {
    setBusyId(id);
    setPollResult(null);
    try {
      const result = await adminFetch<PollResult>(`/api/feeds/${id}/poll`, { method: "POST" });
      setPollResult(result);
      if (openId === id) {
        setLogs(await adminFetch<FeedLog[]>(`/api/feeds/${id}/log`));
      }
    } catch (err) {
      setError(err instanceof Error ? err.message : "Poll failed");
    } finally {
      setBusyId(null);
    }
  }

  return (
    <>
      <AdminHeading title="Feeds" />
      {error ? <Notice kind="error">{error}</Notice> : null}
      {pollResult ? (
        <Notice kind={pollResult.ok ? "ok" : "info"}>
          Poll finished: fetched {pollResult.fetched}, stored {pollResult.stored}. {pollResult.message}
        </Notice>
      ) : null}

      <Card>
        <div className="overflow-x-auto">
          <table className="w-full text-left text-sm">
            <thead className="border-b border-line text-xs uppercase tracking-wide text-ink-mute">
              <tr>
                <th className="py-2 pr-3">ID</th>
                <th className="py-2 pr-3">Name</th>
                <th className="py-2 pr-3">Type</th>
                <th className="py-2 pr-3">Active</th>
                <th className="py-2 pr-3">Next poll</th>
                <th className="py-2 pr-3">Last poll</th>
                <th className="py-2">Actions</th>
              </tr>
            </thead>
            <tbody>
              {feeds.map((feed) => (
                <tr key={feed.id} className="border-b border-line/60 align-top">
                  <td className="py-2 pr-3 text-ink-mute">{feed.id}</td>
                  <td className="py-2 pr-3">
                    {feed.name ?? "(unnamed)"}
                    {feed.link ? (
                      <div className="text-xs text-ink-mute">
                        <a href={feed.link} target="_blank" rel="noreferrer">
                          {feed.link}
                        </a>
                      </div>
                    ) : null}
                    {openId === feed.id ? (
                      <div className="mt-2 rounded border border-line bg-canvas p-2 text-xs">
                        {logs.length === 0 ? (
                          <p className="text-ink-mute">No poll log.</p>
                        ) : (
                          <ul className="space-y-1">
                            {logs.map((log) => (
                              <li key={log.id} className="text-ink-soft">
                                {formatDate(log.logTime) || log.logTime} - {log.severity ?? "info"}
                                {log.message ? ` - ${log.message}` : ""}
                              </li>
                            ))}
                          </ul>
                        )}
                      </div>
                    ) : null}
                  </td>
                  <td className="py-2 pr-3 text-ink-mute">{feed.feedType ?? "-"}</td>
                  <td className="py-2 pr-3 text-ink-mute">{feed.feedActive ? "yes" : "no"}</td>
                  <td className="py-2 pr-3 text-ink-mute">{formatDate(feed.nextPoll) || "-"}</td>
                  <td className="py-2 pr-3 text-ink-mute">{formatDate(feed.lastPoll) || "-"}</td>
                  <td className="py-2">
                    <div className="flex flex-col gap-1">
                      <button type="button" onClick={() => toggleLogs(feed.id)} className="text-left text-brand">
                        {openId === feed.id ? "Hide log" : "View log"}
                      </button>
                      <PrimaryButton type="button" disabled={busyId === feed.id} onClick={() => poll(feed.id)}>
                        {busyId === feed.id ? "Polling..." : "Poll now"}
                      </PrimaryButton>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </Card>

      <p className="mt-4 text-sm">
        <Link href="/admin">Back to overview</Link>
      </p>
    </>
  );
}
