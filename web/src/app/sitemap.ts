import type { MetadataRoute } from 'next';

import { absolutePublicUrl, publicRoutes } from '@/lib/config/routes';
import { getActiveServices } from '@/lib/data/public-content';

/**
 * Sitemap.
 *
 * Public pages and one entry per active service. Admin routes and the sign-in
 * page are deliberately absent.
 */
export const revalidate = 3600;

export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const now = new Date();

  const staticPages: Array<{ path: string; priority: number; changeFrequency: 'weekly' | 'monthly' | 'yearly' }> = [
    { path: publicRoutes.home, priority: 1, changeFrequency: 'weekly' },
    { path: publicRoutes.services, priority: 0.9, changeFrequency: 'weekly' },
    { path: publicRoutes.howItWorks, priority: 0.8, changeFrequency: 'monthly' },
    { path: publicRoutes.forCustomers, priority: 0.8, changeFrequency: 'monthly' },
    { path: publicRoutes.forWorkers, priority: 0.8, changeFrequency: 'monthly' },
    { path: publicRoutes.verification, priority: 0.7, changeFrequency: 'monthly' },
    { path: publicRoutes.safety, priority: 0.7, changeFrequency: 'monthly' },
    { path: publicRoutes.faq, priority: 0.6, changeFrequency: 'monthly' },
    { path: publicRoutes.about, priority: 0.5, changeFrequency: 'yearly' },
    { path: publicRoutes.contact, priority: 0.5, changeFrequency: 'yearly' },
    { path: publicRoutes.privacy, priority: 0.3, changeFrequency: 'yearly' },
    { path: publicRoutes.terms, priority: 0.3, changeFrequency: 'yearly' },
    { path: publicRoutes.refundPolicy, priority: 0.3, changeFrequency: 'yearly' },
    { path: publicRoutes.cancellationPolicy, priority: 0.3, changeFrequency: 'yearly' },
  ];

  const services = await getActiveServices();

  return [
    ...staticPages.map((page) => ({
      url: absolutePublicUrl(page.path),
      lastModified: now,
      changeFrequency: page.changeFrequency,
      priority: page.priority,
    })),
    ...services.map((service) => ({
      url: absolutePublicUrl(publicRoutes.service(service.slug)),
      lastModified: new Date(service.updated_at),
      changeFrequency: 'monthly' as const,
      priority: 0.8,
    })),
  ];
}
