import { Smartphone } from 'lucide-react';

import { ButtonLink } from '@/components/ui/button';
import { publicEnv } from '@/lib/config/env';
import { cn } from '@/lib/utils/cn';

/**
 * App download call to action.
 *
 * Store links come from environment configuration. When a link has not been
 * configured, the button is not rendered — and when neither is configured, the
 * whole block collapses to an honest "coming to the app stores" line instead of
 * pointing at a URL that does not exist.
 *
 * A dead store badge on a launch site costs more trust than an absent one.
 */

export function AppCta({
  audience,
  title,
  description,
  className,
}: {
  audience: 'customer' | 'worker';
  title: string;
  description: string;
  className?: string;
}) {
  const { apps, brand } = publicEnv();

  const android = audience === 'customer' ? apps.customerAndroid : apps.workerAndroid;
  const ios = audience === 'customer' ? apps.customerIos : apps.workerIos;
  const hasAnyLink = Boolean(android || ios);

  return (
    <div
      className={cn(
        'rounded-2xl border border-brand-200 bg-brand-50 p-6 sm:p-8',
        className,
      )}
    >
      <div className="flex flex-col gap-5 sm:flex-row sm:items-center sm:justify-between">
        <div className="max-w-xl">
          <div className="flex items-center gap-2 text-brand-800">
            <Smartphone aria-hidden className="size-5" />
            <span className="text-xs font-semibold uppercase tracking-wide">
              {audience === 'customer' ? 'Customer app' : 'Worker app'}
            </span>
          </div>

          <h2 className="mt-2 text-xl font-semibold text-ink-900 sm:text-2xl">{title}</h2>
          <p className="mt-2 text-sm leading-relaxed text-ink-700">{description}</p>
        </div>

        <div className="flex shrink-0 flex-col gap-2 sm:min-w-48">
          {android && (
            <ButtonLink href={android} external fullWidth>
              Get it on Android
            </ButtonLink>
          )}

          {ios && (
            <ButtonLink href={ios} external variant="outline" fullWidth>
              Download on iOS
            </ButtonLink>
          )}

          {!hasAnyLink && (
            <p className="rounded-lg border border-brand-200 bg-white px-4 py-3 text-sm text-ink-600">
              The {audience} app is coming to the app stores. Write to{' '}
              <a
                href={`mailto:${brand.supportEmail}`}
                className="font-medium text-brand-700 underline"
              >
                {brand.supportEmail}
              </a>{' '}
              to be told when it is available.
            </p>
          )}
        </div>
      </div>
    </div>
  );
}
