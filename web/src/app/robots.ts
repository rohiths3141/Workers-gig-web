import type { MetadataRoute } from 'next';

import { adminPathPrefix, absolutePublicUrl } from '@/lib/config/routes';

/**
 * robots.txt.
 *
 * Disallowing the admin path keeps well-behaved crawlers out, but it is not a
 * security control — the path is also protected by authentication and sends
 * X-Robots-Tag: noindex. After the subdomain migration the admin host serves no
 * public pages, so the rule becomes redundant rather than wrong.
 */
export default function robots(): MetadataRoute.Robots {
  const prefix = adminPathPrefix();

  return {
    rules: [
      {
        userAgent: '*',
        allow: '/',
        disallow: ['/api/', '/login', ...(prefix ? [`${prefix}/`, prefix] : [])],
      },
    ],
    sitemap: absolutePublicUrl('/sitemap.xml'),
    host: absolutePublicUrl('/'),
  };
}
