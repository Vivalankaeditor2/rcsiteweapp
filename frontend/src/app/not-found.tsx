/**
 * The 404 surface. A missing article, an unapproved article (approval status
 * "4"), or a malformed {@code /newspage} path all land here with a real 404
 * status, never a soft-200 (a 200 must never become a 301, D-003).
 */
export default function NotFound() {
  return (
    <main className="mx-auto flex max-w-page flex-col items-center px-4 py-24 text-center sm:px-6">
      <p className="headline text-5xl text-brand">404</p>
      <h1 className="headline mt-4 text-2xl">Page not found</h1>
      <p className="mt-2 max-w-md text-sm text-ink-mute">
        The page you requested could not be found. It may have been moved or removed.
      </p>
      <a
        href="/"
        className="mt-6 rounded bg-brand px-5 py-2.5 text-sm font-semibold text-white hover:bg-brand-dark"
      >
        Back to home
      </a>
    </main>
  );
}
