import type { Metadata, Viewport } from 'next';

import { publicEnv } from '@/lib/config/env';
import { absolutePublicUrl } from '@/lib/config/routes';

import './globals.css';

/**
 * Root layout.
 *
 * Deliberately thin. The public website and the admin panel each bring their own
 * chrome in their own layout, because they are different products with different
 * navigation, different density and — after the subdomain migration — different
 * origins. Nothing here assumes which of the two is rendering.
 */

export function generateMetadata(): Metadata {
  const { brand } = publicEnv();

  return {
    metadataBase: new URL(absolutePublicUrl('/')),
    title: {
      default: `${brand.name} — ${brand.tagline}`,
      template: `%s | ${brand.name}`,
    },
    description:
      'Book verified electricians, plumbers, AC and appliance technicians for your home. ' +
      'Identity and background checked professionals, transparent pricing, and material approval before purchase.',
    applicationName: brand.name,
    referrer: 'strict-origin-when-cross-origin',
    formatDetection: { telephone: false, address: false, email: false },
    openGraph: {
      type: 'website',
      siteName: brand.name,
      locale: 'en_IN',
    },
    twitter: {
      card: 'summary_large_image',
    },
    robots: {
      index: true,
      follow: true,
      googleBot: { index: true, follow: true, 'max-image-preview': 'large' },
    },
  };
}

export const viewport: Viewport = {
  width: 'device-width',
  initialScale: 1,
  themeColor: '#0f766e',
  colorScheme: 'light',
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en-IN">
      <body className="min-h-dvh bg-white antialiased">{children}</body>
    </html>
  );
}
