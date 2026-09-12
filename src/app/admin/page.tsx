import { redirect } from 'next/navigation';

import { adminRoutes } from '@/lib/config/routes';

/**
 * The admin root sends operators to the dashboard.
 *
 * A redirect rather than a duplicate of the dashboard, so there is one
 * implementation to maintain and one URL that appears in history.
 */
export default function AdminRootPage() {
  redirect(adminRoutes.dashboard());
}
