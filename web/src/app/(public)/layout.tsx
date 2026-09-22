import { SiteFooter } from '@/components/public/site-footer';
import { SiteHeader } from '@/components/public/site-header';
import { publicEnv } from '@/lib/config/env';

/**
 * Public website layout.
 *
 * Entirely separate from the admin layout: different chrome, different
 * navigation, different density. Neither imports from the other, which is what
 * lets the admin panel move to its own origin later without disturbing this.
 */
export default function PublicLayout({ children }: { children: React.ReactNode }) {
  const { brand } = publicEnv();

  return (
    <div className="flex min-h-dvh flex-col">
      {/* First tab stop on every page. */}
      <a href="#main" className="skip-link">
        Skip to main content
      </a>

      <SiteHeader brandName={brand.name} />

      <main id="main" className="flex-1">
        {children}
      </main>

      <SiteFooter />
    </div>
  );
}
