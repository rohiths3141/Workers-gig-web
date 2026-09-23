import { Download, Smartphone } from 'lucide-react';

import { ButtonLink } from '@/components/ui/button';
import { publicEnv } from '@/lib/config/env';
import { publicRoutes } from '@/lib/config/routes';
import { cn } from '@/lib/utils/cn';

/**
 * App download call to action.
 *
 * Store links come from environment configuration. Until a Play Store link is
 * configured, Android goes to this site's own download page, which serves the
 * APK directly — so there is always a real way to get the app. An iOS button
 * appears only once an App Store link exists; there is no iOS build to point at
 * otherwise.
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
  const { apps } = publicEnv();

  const android = audience === 'customer' ? apps.customerAndroid : apps.workerAndroid;
  const ios = audience === 'customer' ? apps.customerIos : apps.workerIos;

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
          {android ? (
            <ButtonLink href={android} external fullWidth>
              Get it on Android
            </ButtonLink>
          ) : (
            <ButtonLink href={`${publicRoutes.download}#${audience}`} fullWidth>
              <Download aria-hidden className="size-4" />
              Download for Android
            </ButtonLink>
          )}

          {ios && (
            <ButtonLink href={ios} external variant="outline" fullWidth>
              Download on iOS
            </ButtonLink>
          )}
        </div>
      </div>
    </div>
  );
}
