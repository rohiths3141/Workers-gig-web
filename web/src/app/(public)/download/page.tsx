import type { Metadata } from 'next';
import Image from 'next/image';
import { Download, RefreshCw, ShieldAlert, Smartphone } from 'lucide-react';

import { DownloadQr } from '@/components/public/download-qr';
import { CheckList, Eyebrow, SectionHeading, StepList } from '@/components/public/marketing';
import { ButtonLink } from '@/components/ui/button';
import { publicEnv } from '@/lib/config/env';
import { absolutePublicUrl, publicRoutes } from '@/lib/config/routes';
import releases from '@/lib/data/app-releases.json';
import { formatDate } from '@/lib/utils/format';

/**
 * Direct APK downloads for both apps.
 *
 * The apps are not on the Play Store yet, so the files are served from this
 * site. Everything the page states about a file — version, size, minimum
 * Android version, checksum — is read from app-releases.json, which
 * `node scripts/publish-apks.mjs` measures from the file it copies. Nothing is
 * typed in by hand, so the page cannot drift from the download.
 */

export const metadata: Metadata = {
  title: 'Download the apps',
  description:
    'Download the Wervexa app to book verified home-service professionals, or Wervexa Captain to receive work as a professional. Android 7.0 and later.',
  alternates: { canonical: absolutePublicUrl(publicRoutes.download) },
};

// The names are the ones the phone shows under the icon once installed.
const APPS = [
  {
    id: 'customer',
    name: 'Wervexa',
    audience: 'For customers',
    summary: 'Book a verified professional for work at home.',
    features: [
      'Book electricians, plumbers, AC and appliance technicians and more',
      'See which checks a professional has passed before they arrive',
      'Approve any material before it is bought',
      'Track the job and pay in the app',
    ],
    release: releases.customer,
  },
  {
    id: 'worker',
    name: 'Wervexa Captain',
    audience: 'For workers',
    summary: 'Get verified, receive jobs and get paid.',
    features: [
      'Register with your mobile number',
      'Complete identity and qualification verification',
      'Receive jobs suited to your trade and location',
      'Track your earnings and request payouts',
    ],
    release: releases.worker,
  },
] as const;

const INSTALL_STEPS = [
  {
    title: 'Download the file',
    description: 'Tap Download APK on the app you need. It is saved to your phone’s Downloads folder.',
  },
  {
    title: 'Open it',
    description: 'Tap the finished download in the notification bar, or open Files and go to Downloads.',
  },
  {
    title: 'Allow the install',
    description:
      'The first time, Android asks whether your browser may install apps. Tap Settings, turn on “Allow from this source”, then go back.',
  },
  {
    title: 'Install and sign in',
    description: 'Tap Install, open the app, and sign in with your mobile number.',
  },
] as const;

/** Decimal megabytes, the unit Android's own file manager reports. */
function formatSize(bytes: number): string {
  return `${(bytes / 1_000_000).toFixed(1)} MB`;
}

export default function DownloadPage() {
  const { brand } = publicEnv();

  return (
    <>
      <section className="border-b border-ink-200 bg-gradient-to-b from-brand-50/60 to-white">
        <div className="container-page py-14 md:py-20">
          <div className="flex items-center justify-between gap-10">
            <SectionHeading
              as="h1"
              eyebrow="Download"
              title="Get the apps on your Android phone"
              description="One app to book a verified professional, one for professionals to receive work. They are not on the Play Store yet, so download the file here and install it directly."
            />

            <div className="hidden w-60 shrink-0 rounded-2xl border border-ink-200 bg-white p-5 text-center shadow-card lg:block">
              <DownloadQr path={publicRoutes.download} className="mx-auto size-40" />
              <p className="mt-3 text-sm font-medium text-ink-900">On a computer?</p>
              <p className="mt-1 text-xs leading-relaxed text-ink-600">
                Scan with your phone’s camera to open this page there.
              </p>
            </div>
          </div>
        </div>
      </section>

      <section className="section">
        <div className="container-page">
          <div className="grid gap-6 md:grid-cols-2">
            {APPS.map((app) => (
              <article
                key={app.id}
                id={app.id}
                aria-labelledby={`${app.id}-name`}
                className="flex scroll-mt-24 flex-col rounded-2xl border border-ink-200 bg-white p-6 shadow-card sm:p-8"
              >
                <div className="flex items-center gap-4">
                  <Image
                    src={app.release.icon}
                    alt=""
                    width={64}
                    height={64}
                    className="size-16 shrink-0 rounded-2xl border border-ink-200"
                  />
                  <div className="min-w-0">
                    <Eyebrow>{app.audience}</Eyebrow>
                    <h2 id={`${app.id}-name`} className="mt-1 text-xl font-semibold text-ink-900 sm:text-2xl">
                      {app.name}
                    </h2>
                    <p className="mt-0.5 text-sm text-ink-600">{app.summary}</p>
                  </div>
                </div>

                <CheckList items={app.features} className="mt-6" />

                <div className="mt-auto pt-8">
                  <ButtonLink
                    href={app.release.href}
                    download={`${app.name.replace(/\s+/g, '-')}-${app.release.versionName}.apk`}
                    size="lg"
                    fullWidth
                  >
                    <Download aria-hidden className="size-5" />
                    Download APK
                    <span className="font-normal text-brand-100">· {formatSize(app.release.sizeBytes)}</span>
                  </ButtonLink>

                  <dl className="mt-4 grid grid-cols-3 gap-2 text-center text-xs">
                    <div className="rounded-lg bg-ink-50 px-2 py-2">
                      <dt className="text-ink-500">Version</dt>
                      <dd className="mt-0.5 font-medium text-ink-900">{app.release.versionName}</dd>
                    </div>
                    <div className="rounded-lg bg-ink-50 px-2 py-2">
                      <dt className="text-ink-500">Requires</dt>
                      <dd className="mt-0.5 font-medium text-ink-900">Android {app.release.minAndroid}+</dd>
                    </div>
                    <div className="rounded-lg bg-ink-50 px-2 py-2">
                      <dt className="text-ink-500">Updated</dt>
                      <dd className="mt-0.5 font-medium text-ink-900">{formatDate(app.release.builtAt)}</dd>
                    </div>
                  </dl>

                  <details className="group mt-3 text-xs">
                    <summary className="cursor-pointer list-none text-ink-500 hover:text-ink-700 marker:content-['']">
                      <span className="underline decoration-ink-300 underline-offset-2">Verify the file (SHA-256)</span>
                    </summary>
                    <code className="mt-2 block break-all rounded-lg bg-ink-50 px-3 py-2 font-mono text-[11px] leading-relaxed text-ink-700">
                      {app.release.sha256}
                    </code>
                  </details>
                </div>
              </article>
            ))}
          </div>
        </div>
      </section>

      <section className="border-t border-ink-200 bg-ink-50">
        <div className="container-page section">
          <div className="grid gap-12 lg:grid-cols-5">
            <div className="lg:col-span-3">
              <SectionHeading title="How to install" />
              <StepList steps={INSTALL_STEPS} className="mt-8" />
            </div>

            <div className="space-y-4 lg:col-span-2">
              <Note icon={<ShieldAlert aria-hidden className="size-5" />} title="If Play Protect warns you">
                Android may say the app is unrecognised, because it has not come from the Play Store.
                Tap <span className="font-medium">More details</span>, then{' '}
                <span className="font-medium">Install anyway</span>. To be sure the file is ours,
                compare its SHA-256 with the one shown above.
              </Note>

              <Note icon={<RefreshCw aria-hidden className="size-5" />} title="Updating">
                Download the newer file from this page and install it over the app you have — you
                stay signed in.
              </Note>

              <Note icon={<Smartphone aria-hidden className="size-5" />} title="iPhone">
                Both apps are Android-only for now.
              </Note>

              <p className="px-1 text-sm text-ink-600">
                Stuck? Write to{' '}
                <a href={`mailto:${brand.supportEmail}`} className="font-medium text-brand-700 underline">
                  {brand.supportEmail}
                </a>{' '}
                and tell us your phone model and what the screen says.
              </p>
            </div>
          </div>
        </div>
      </section>
    </>
  );
}

function Note({ icon, title, children }: { icon: React.ReactNode; title: string; children: React.ReactNode }) {
  return (
    <div className="flex gap-3.5 rounded-xl border border-ink-200 bg-white p-5">
      <div className="flex size-9 shrink-0 items-center justify-center rounded-lg bg-brand-50 text-brand-700">
        {icon}
      </div>
      <div>
        <h3 className="text-sm font-semibold text-ink-900">{title}</h3>
        <p className="mt-1 text-sm leading-relaxed text-ink-600">{children}</p>
      </div>
    </div>
  );
}
