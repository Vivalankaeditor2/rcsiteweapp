"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { loadSession, login } from "@/lib/auth";
import { SITE_NAME } from "@/lib/site";

/**
 * Admin sign-in. Written against `rc_customer` (D-022); the backend refuses
 * legacy plaintext passwords unless the owner enables the switch (NC-006), so a
 * failed login may mean "not enabled", not "wrong password".
 */
export default function AdminLoginPage() {
  const router = useRouter();
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);

  useEffect(() => {
    if (loadSession()) {
      router.replace("/admin");
    }
  }, [router]);

  async function onSubmit(event: React.FormEvent) {
    event.preventDefault();
    setBusy(true);
    setError(null);
    try {
      await login(username, password);
      router.replace("/admin");
    } catch (err) {
      setError(err instanceof Error ? err.message : "Sign-in failed");
    } finally {
      setBusy(false);
    }
  }

  return (
    <div className="mx-auto flex max-w-page items-center justify-center px-4 py-16">
      <form
        onSubmit={onSubmit}
        className="w-full max-w-sm rounded-lg border border-line bg-white p-6 shadow-sm"
      >
        <h1 className="headline text-xl">{SITE_NAME} admin</h1>
        <p className="mt-1 text-sm text-ink-mute">Sign in to manage content.</p>

        {error ? (
          <p role="alert" className="mt-4 rounded border border-red-200 bg-red-50 px-3 py-2 text-sm text-red-700">
            {error}
          </p>
        ) : null}

        <label className="mt-4 block text-sm font-medium text-ink-soft">
          Username
          <input
            type="text"
            value={username}
            onChange={(e) => setUsername(e.target.value)}
            autoComplete="username"
            required
            className="mt-1 w-full rounded border border-line px-3 py-2 text-ink outline-none focus:border-brand"
          />
        </label>

        <label className="mt-3 block text-sm font-medium text-ink-soft">
          Password
          <input
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            autoComplete="current-password"
            required
            className="mt-1 w-full rounded border border-line px-3 py-2 text-ink outline-none focus:border-brand"
          />
        </label>

        <button
          type="submit"
          disabled={busy}
          className="mt-5 w-full rounded bg-brand px-4 py-2 font-semibold text-white transition-colors hover:bg-brand-dark disabled:opacity-60"
        >
          {busy ? "Signing in..." : "Sign in"}
        </button>
      </form>
    </div>
  );
}
