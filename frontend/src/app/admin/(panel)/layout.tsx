"use client";

import type { ReactNode } from "react";
import { AdminShell } from "@/components/admin/AdminShell";

/**
 * Route-group layout for the authenticated admin panel. `/admin/login` lives
 * outside this group so the guard does not redirect the login page to itself.
 */
export default function AdminPanelLayout({ children }: { children: ReactNode }) {
  return <AdminShell>{children}</AdminShell>;
}
