/**
 * Admin session for the React admin UI (Phase 7).
 *
 * The bearer token is minted by the backend (`POST /api/auth/login`) and kept in
 * `localStorage`: this is a browser-only admin tool, and the backend API is
 * stateless (D-036), so no cookie/session store is needed. The token is never
 * rendered - only attached as an `Authorization` header.
 */

export interface AdminIdentity {
  username: string;
  displayName: string | null;
  email: string | null;
  roles: string[];
}

export interface AdminSession {
  token: string;
  tokenType: string;
  expiresInSeconds: number;
  user: AdminIdentity;
}

const STORAGE_KEY = "rcsite.admin.session";

export function saveSession(session: AdminSession): void {
  if (typeof window === "undefined") return;
  window.localStorage.setItem(STORAGE_KEY, JSON.stringify(session));
}

export function loadSession(): AdminSession | null {
  if (typeof window === "undefined") return null;
  const raw = window.localStorage.getItem(STORAGE_KEY);
  if (!raw) return null;
  try {
    return JSON.parse(raw) as AdminSession;
  } catch {
    window.localStorage.removeItem(STORAGE_KEY);
    return null;
  }
}

export function clearSession(): void {
  if (typeof window === "undefined") return;
  window.localStorage.removeItem(STORAGE_KEY);
}

/** True if the identity carries the ADMIN role (the write API requires it). */
export function isAdmin(session: AdminSession | null): boolean {
  return session?.user.roles?.includes("ADMIN") ?? false;
}

/** Extract the message from the backend's unified error body, if present. */
export async function errorMessage(response: Response): Promise<string> {
  try {
    const body = (await response.json()) as { message?: string };
    if (body?.message) return body.message;
  } catch {
    // fall through to the status text
  }
  return `${response.status} ${response.statusText}`;
}

export async function login(username: string, password: string): Promise<AdminSession> {
  // Same-origin: Next rewrites /api/* to the Spring Boot backend (next.config.mjs).
  const response = await fetch("/api/auth/login", {
    method: "POST",
    headers: { "Content-Type": "application/json", Accept: "application/json" },
    body: JSON.stringify({ username, password }),
  });
  if (!response.ok) {
    throw new Error(await errorMessage(response));
  }
  const session = (await response.json()) as AdminSession;
  saveSession(session);
  return session;
}

/** Re-validate a stored token against the backend; throws if it is not accepted. */
export async function fetchMe(token: string): Promise<AdminIdentity> {
  const response = await fetch("/api/auth/me", {
    headers: { Authorization: `Bearer ${token}`, Accept: "application/json" },
  });
  if (!response.ok) {
    throw new Error(await errorMessage(response));
  }
  return (await response.json()) as AdminIdentity;
}

/**
 * Call the admin API with the session token attached. A 401 clears the stale
 * session and throws, so callers can bounce the user back to the login screen.
 */
export async function adminFetch<T>(path: string, init: RequestInit = {}): Promise<T> {
  const session = loadSession();
  if (!session) {
    throw new Error("Not signed in");
  }
  const response = await fetch(path, {
    ...init,
    headers: {
      Accept: "application/json",
      ...(init.body ? { "Content-Type": "application/json" } : {}),
      Authorization: `Bearer ${session.token}`,
      ...init.headers,
    },
  });
  if (response.status === 401) {
    clearSession();
    throw new Error("Your session has expired. Sign in again.");
  }
  if (!response.ok) {
    throw new Error(await errorMessage(response));
  }
  if (response.status === 204) {
    return undefined as T;
  }
  return (await response.json()) as T;
}
