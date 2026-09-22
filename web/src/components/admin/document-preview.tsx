'use client';

import { useEffect, useState } from 'react';
import { ImageOff, Loader2 } from 'lucide-react';

import { DocumentLink, type DocumentLinkProps } from '@/components/admin/document-link';
import { apiRoutes } from '@/lib/config/routes';

/**
 * Shows an uploaded image inline on a review page, with the usual open link
 * beneath it. Non-images fall back to the link alone.
 *
 * Like DocumentLink, the short-lived URL is requested from the audited media
 * endpoint in the browser, never written into the server-rendered HTML; loading
 * the review page counts as opening the document.
 */
export function DocumentPreview(props: DocumentLinkProps) {
  const isImage = props.mimeType.startsWith('image/');
  const [url, setUrl] = useState<string | null>(null);
  const [failed, setFailed] = useState(false);

  useEffect(() => {
    if (!isImage) return;
    let cancelled = false;

    fetch(apiRoutes.adminMediaUrl(props.mediaId), { credentials: 'same-origin' })
      .then(async (response) => {
        const payload = (await response.json().catch(() => null)) as { data?: { url?: string } } | null;
        if (cancelled) return;
        if (response.ok && payload?.data?.url) setUrl(payload.data.url);
        else setFailed(true);
      })
      .catch(() => !cancelled && setFailed(true));

    return () => {
      cancelled = true;
    };
  }, [isImage, props.mediaId]);

  if (!isImage) return <DocumentLink {...props} />;

  return (
    <div className="space-y-2">
      <div className="flex min-h-40 items-center justify-center overflow-hidden rounded-lg border border-ink-200 bg-ink-50">
        {url ? (
          <a href={url} target="_blank" rel="noopener noreferrer" className="block w-full">
            {/* eslint-disable-next-line @next/next/no-img-element -- short-lived signed URL, not an optimisable asset */}
            <img src={url} alt={props.fileName} className="mx-auto max-h-96 w-auto object-contain" />
          </a>
        ) : failed ? (
          <span className="flex items-center gap-2 p-6 text-sm text-ink-500">
            <ImageOff aria-hidden className="size-4" /> Preview unavailable
          </span>
        ) : (
          <Loader2 aria-label="Loading preview" className="size-5 animate-spin text-ink-400" />
        )}
      </div>
      <DocumentLink {...props} />
    </div>
  );
}
