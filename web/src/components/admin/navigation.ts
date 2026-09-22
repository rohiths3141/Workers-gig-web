import {
  Bell,
  Briefcase,
  CircleDollarSign,
  ClipboardList,
  FileSearch,
  GaugeCircle,
  HandCoins,
  LifeBuoy,
  ListChecks,
  Package,
  ScrollText,
  Settings,
  ShieldAlert,
  ShieldCheck,
  Sparkles,
  Target,
  UserCheck,
  Users,
  Wallet,
  type LucideIcon,
} from 'lucide-react';

import { adminRoutes } from '@/lib/config/routes';
import type { Permission } from '@/lib/permissions/permissions';

/**
 * Admin navigation.
 *
 * Grouped by what an operator is trying to do, not by database table. Each item
 * declares the permission it needs, and the sidebar renders only the items the
 * signed-in administrator can actually use — so a Support admin does not stare
 * at a Payouts link that will refuse them.
 *
 * Hiding a link is a courtesy, not a control. The page behind it performs its
 * own check, as does its API route, as does the database.
 *
 * Every href goes through adminRoutes, so the subdomain migration needs no
 * change here.
 */

export interface NavItem {
  label: string;
  href: string;
  icon: LucideIcon;
  /** Permission required to see and use this item. */
  permission: Permission;
  /** Match child routes too, so a detail page keeps its parent highlighted. */
  matchPrefix?: boolean;
}

export interface NavSection {
  heading: string;
  items: NavItem[];
}

export const ADMIN_NAVIGATION: NavSection[] = [
  {
    heading: 'Overview',
    items: [
      {
        label: 'Dashboard',
        href: adminRoutes.dashboard(),
        icon: GaugeCircle,
        // Every administrator can see the dashboard; the tiles within it are
        // individually permission-gated.
        permission: 'services.read',
      },
    ],
  },
  {
    heading: 'Operations',
    items: [
      {
        label: 'Bookings',
        href: adminRoutes.bookings(),
        icon: ClipboardList,
        permission: 'bookings.read',
        matchPrefix: true,
      },
      {
        label: 'Matching',
        href: adminRoutes.matching(),
        icon: Target,
        permission: 'matching.read',
        matchPrefix: true,
      },
      {
        label: 'Materials',
        href: adminRoutes.materials(),
        icon: Package,
        permission: 'materials.read',
        matchPrefix: true,
      },
    ],
  },
  {
    heading: 'People',
    items: [
      {
        label: 'Workers',
        href: adminRoutes.workers(),
        icon: Briefcase,
        permission: 'workers.read',
        matchPrefix: true,
      },
      {
        label: 'Customers',
        href: adminRoutes.customers(),
        icon: Users,
        permission: 'customers.read',
        matchPrefix: true,
      },
    ],
  },
  {
    heading: 'Verification',
    items: [
      {
        label: 'Verification queue',
        href: adminRoutes.verification(),
        icon: ShieldCheck,
        permission: 'verification.read',
        matchPrefix: true,
      },
      {
        label: 'Background checks',
        href: `${adminRoutes.verification()}?type=BACKGROUND_CHECK`,
        icon: UserCheck,
        permission: 'verification.read',
      },
      {
        label: 'Gig review',
        href: adminRoutes.gigs(),
        icon: ListChecks,
        permission: 'verification.read',
        matchPrefix: true,
      },
      {
        label: 'Insurance',
        href: adminRoutes.insurance(),
        icon: FileSearch,
        permission: 'insurance.read',
        matchPrefix: true,
      },
    ],
  },
  {
    heading: 'Finance',
    items: [
      {
        label: 'Payments',
        href: adminRoutes.payments(),
        icon: CircleDollarSign,
        permission: 'payments.read',
        matchPrefix: true,
      },
      {
        label: 'Wallets',
        href: adminRoutes.wallets(),
        icon: Wallet,
        permission: 'wallets.read',
        matchPrefix: true,
      },
      {
        label: 'Payouts',
        href: adminRoutes.payouts(),
        icon: HandCoins,
        permission: 'payouts.read',
        matchPrefix: true,
      },
    ],
  },
  {
    heading: 'Trust and safety',
    items: [
      {
        label: 'Damage claims',
        href: adminRoutes.claims(),
        icon: ShieldAlert,
        permission: 'claims.read',
        matchPrefix: true,
      },
    ],
  },
  {
    heading: 'Communication',
    items: [
      {
        label: 'Support',
        href: adminRoutes.support(),
        icon: LifeBuoy,
        permission: 'support.read',
        matchPrefix: true,
      },
      {
        label: 'Notifications',
        href: adminRoutes.notifications(),
        icon: Bell,
        permission: 'notifications.read',
        matchPrefix: true,
      },
    ],
  },
  {
    heading: 'Platform',
    items: [
      {
        label: 'Services',
        href: adminRoutes.services(),
        icon: Sparkles,
        permission: 'services.read',
        matchPrefix: true,
      },
      {
        label: 'Settings',
        href: adminRoutes.settings(),
        icon: Settings,
        permission: 'settings.read',
        matchPrefix: true,
      },
    ],
  },
  {
    heading: 'System',
    items: [
      {
        label: 'Audit logs',
        href: adminRoutes.auditLogs(),
        icon: ScrollText,
        permission: 'audit_logs.read',
        matchPrefix: true,
      },
    ],
  },
];

/** Drop items and then empty sections the administrator cannot use. */
export function visibleNavigation(permissions: readonly string[]): NavSection[] {
  return ADMIN_NAVIGATION.map((section) => ({
    ...section,
    items: section.items.filter((item) => permissions.includes(item.permission)),
  })).filter((section) => section.items.length > 0);
}
