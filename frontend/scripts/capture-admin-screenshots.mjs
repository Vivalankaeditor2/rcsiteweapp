// Capture screenshots of the Phase 7 admin UI for the local demo.
//
// Drives the system Microsoft Edge over the Chrome DevTools Protocol using
// Node 22's built-in fetch/WebSocket - no extra dependencies, no bundler.
// It seeds a real admin session (POST /api/auth/login), stores it under the
// same localStorage key the app reads, then screenshots each admin screen.
//
// Usage: node scripts/capture-admin-screenshots.mjs
// Requires the local stack (backend :8080, frontend :3000) to be running.

import { spawn } from "node:child_process";
import { mkdirSync, writeFileSync } from "node:fs";
import { setTimeout as sleep } from "node:timers/promises";

const EDGE = "C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe";
const BASE = process.env.DEMO_BASE ?? "http://localhost:3000";
const API = process.env.DEMO_API ?? "http://localhost:8080";
const USER = process.env.DEMO_USER ?? "demo";
const PASS = process.env.DEMO_PASS ?? "demo123";
const OUT = process.env.DEMO_OUT ?? "C:\\rcwebapp\\screenshots";
const PORT = 9222;
const STORAGE_KEY = "rcsite.admin.session";

const SHOTS = [
  { name: "02-overview", path: "/admin" },
  { name: "03-articles-list", path: "/admin/articles" },
  { name: "04-article-new", path: "/admin/articles/new" },
  { name: "05-categories", path: "/admin/categories" },
  { name: "06-feeds", path: "/admin/feeds" },
  { name: "07-config", path: "/admin/config" },
  { name: "08-email", path: "/admin/email" },
];

async function main() {
  mkdirSync(OUT, { recursive: true });

  // A real session, minted exactly as the login screen would mint it.
  const loginRes = await fetch(`${API}/api/auth/login`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ username: USER, password: PASS }),
  });
  if (!loginRes.ok) throw new Error(`login failed: ${loginRes.status}`);
  const session = await loginRes.json();
  console.log(`session for ${session.user.username} [${session.user.roles.join(",")}]`);

  // Attach to an Edge already started by the caller (PowerShell), else start one.
  let spawned = null;
  if (!(await hasEndpoint())) {
    spawned = spawn(
      EDGE,
      [
        `--remote-debugging-port=${PORT}`,
        "--remote-allow-origins=*",
        "--headless=new",
        "--disable-gpu",
        "--disable-extensions",
        "--no-first-run",
        "--no-default-browser-check",
        "--hide-scrollbars",
        `--user-data-dir=${OUT}\\.edge-profile`,
        `--window-size=1440,1000`,
        `${BASE}/admin/login`,
      ],
      { stdio: "ignore" },
    );
  }

  try {
    const target = await waitForTarget();
    const ws = new WebSocket(target.webSocketDebuggerUrl);
    await new Promise((res, rej) => {
      ws.addEventListener("open", res, { once: true });
      ws.addEventListener("error", rej, { once: true });
    });

    let nextId = 1;
    const pending = new Map();
    ws.addEventListener("message", (event) => {
      const msg = JSON.parse(event.data);
      if (msg.id && pending.has(msg.id)) {
        const { resolve, reject } = pending.get(msg.id);
        pending.delete(msg.id);
        msg.error ? reject(new Error(JSON.stringify(msg.error))) : resolve(msg.result);
      }
    });
    const send = (method, params = {}) =>
      new Promise((resolve, reject) => {
        const id = nextId++;
        pending.set(id, { resolve, reject });
        ws.send(JSON.stringify({ id, method, params }));
      });

    await send("Page.enable");
    await send("Runtime.enable");
    await send("Emulation.setDeviceMetricsOverride", {
      width: 1440,
      height: 1000,
      deviceScaleFactor: 1,
      mobile: false,
    });

    // The login screen has no session yet: capture it first, before seeding.
    await send("Page.navigate", { url: `${BASE}/admin/login` });
    await sleep(1800);
    await send("Runtime.evaluate", {
      expression: `localStorage.removeItem(${JSON.stringify(STORAGE_KEY)});"cleared"`,
    });
    await send("Page.navigate", { url: `${BASE}/admin/login` });
    await sleep(1500);
    {
      const { data } = await send("Page.captureScreenshot", { format: "png", captureBeyondViewport: true });
      writeFileSync(`${OUT}\\01-login.png`, Buffer.from(data, "base64"));
      console.log("captured 01-login");
    }

    // Seed the session the app expects, on the app origin.
    await send("Runtime.evaluate", {
      expression:
        `localStorage.setItem(${JSON.stringify(STORAGE_KEY)}, ${JSON.stringify(JSON.stringify(session))});` +
        `"seeded"`,
    });

    for (const shot of SHOTS) {
      await send("Page.navigate", { url: `${BASE}${shot.path}` });
      await sleep(2400);
      const { data } = await send("Page.captureScreenshot", { format: "png", captureBeyondViewport: true });
      const file = `${OUT}\\${shot.name}.png`;
      writeFileSync(file, Buffer.from(data, "base64"));
      console.log(`captured ${shot.name}`);
    }

    ws.close();
  } finally {
    if (spawned) spawned.kill();
  }
}

async function hasEndpoint() {
  try {
    const res = await fetch(`http://127.0.0.1:${PORT}/json/version`);
    return res.ok;
  } catch {
    return false;
  }
}

async function waitForTarget() {
  for (let i = 0; i < 40; i++) {
    try {
      const res = await fetch(`http://127.0.0.1:${PORT}/json/list`);
      const targets = await res.json();
      const page = targets.find((t) => t.type === "page" && t.webSocketDebuggerUrl);
      if (page) return page;
    } catch {
      // browser not up yet
    }
    await sleep(500);
  }
  throw new Error("Edge did not expose a debuggable page");
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
