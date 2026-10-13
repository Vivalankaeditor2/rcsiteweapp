/**
 * Date rendering for listings. Times are stored as local wall-clock
 * {@code LocalDateTime} values (the legacy DB has no zone), so the date
 * components are read straight from the string rather than through {@code Date},
 * which would shift them by the server's UTC offset. The output form is a
 * fixed, locale-stable "MMM d, yyyy" matching the legacy style.
 */

const MONTHS = [
  "Jan", "Feb", "Mar", "Apr", "May", "Jun",
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
];

const ISO_PREFIX = /^(\d{4})-(\d{2})-(\d{2})/;

/**
 * Format an ISO {@code LocalDateTime} (or a leading {@code yyyy-MM-dd}) as e.g.
 * "Dec 20, 2011". Returns the empty string for null/unparseable input.
 */
export function formatDate(value: string | null | undefined): string {
  if (!value) {
    return "";
  }
  const match = ISO_PREFIX.exec(value);
  if (!match) {
    return "";
  }
  const year = Number(match[1]);
  const monthIndex = Number(match[2]) - 1;
  const day = Number(match[3]);
  const month = MONTHS[monthIndex];
  if (month == null || Number.isNaN(year) || Number.isNaN(day)) {
    return "";
  }
  return `${month} ${day}, ${year}`;
}
