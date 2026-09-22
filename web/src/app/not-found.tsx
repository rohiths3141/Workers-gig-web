import Link from 'next/link';

import { ButtonLink } from '@/components/ui/button';
import { publicRoutes } from '@/lib/config/routes';

export default function NotFound() {
  return (
    <main className="flex min-h-dvh items-center justify-center bg-ink-50 px-5">
      <div className="max-w-md text-center">
        <p className="text-sm font-semibold text-brand-700">404</p>
        <h1 className="mt-2 text-2xl font-semibold text-ink-900">This page could not be found</h1>
        <p className="mt-3 text-sm text-ink-600">
          The link may be out of date, or the page may have moved.
        </p>
        <div className="mt-6 flex justify-center gap-3">
          <ButtonLink href={publicRoutes.home}>Go to the homepage</ButtonLink>
          <ButtonLink href={publicRoutes.services} variant="outline">
            Browse services
          </ButtonLink>
        </div>
        <p className="mt-6 text-xs text-ink-500">
          Need help? <Link href={publicRoutes.contact} className="underline">Contact support</Link>.
        </p>
      </div>
    </main>
  );
}
