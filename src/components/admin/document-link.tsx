'use client';

import { useState } from 'react';
import { ExternalLink, FileText, Image as ImageIcon, Loader2, ShieldAlert } from 'lucide-react';

import { useToast } from '@/components/ui/toast';
import { apiRoutes } from '@/lib/config/routes';
import { cn } from '@/lib/utils/cn';

/**
 * Opens one stored document.
 *
 * The URL is fetched only when the operator asks for it, never rendered into the
 * page. That matters for three reasons:
 *
 *   - A page listing ten identity documents does not mint ten live URLs, most of
 *     which are never used but all of which would be valid.
 *   - Access to a sensitive file is recorded at the moment it is actually
 *     opened, which is what makes the audit trail meaningful.
 *   - The signed URL never reaches the HTML, so it cannot leak through a page
 *     cache, a screenshot of the DOM, or a copied "view source".
 *
 * The resulting URL is short-lived and is opened in a new tab.
 */

export interface DocumentLinkProps {
  mediaId: string;
  fileName: string;
  mimeType: string;
  /** Marks the control so the operator knows the access will be recorded. */
  sensitive?: boolean;
  className?: string;
}

export function DocumentLink({
  mediaId,
  fileName,
  mimeType,
  sensitive = false,
  className,
}: DocumentLinkProps) {
  const toast = useToast();
  const [loading, setLoading] = useState(false);

  const open = async () => {
    setLoading(true);

    try {
      const response = await fetch(apiRoutes.adminMediaUrl(mediaId), {
        credentials: 'same-origin',
      });

      const payload: unknown = await response.json().catch(() => null);

      if (!response.ok) {
        const message =
          payload && typeof payload === 'object' && 'error' in payload
            ? ((payload as { error: { message?: string } }).error?.message ??
              'The file could not be opened.')
            : 'The file could not be opened.';

        toast.error('Could not open the document', message);
        return;
      }

      const url = (payload as { data?: { url?: string } })?.data?.url;

      if (!url) {
        toast.error('Could not open the document', 'The server did not return a link.');
        return;
      }

      // noopener severs the new tab's reference back to this window, which
      // matters because the destination is a Google Storage origin.
      window.open(url, '_blank', 'noopener,noreferrer');
    } catch {
      toast.error('Could not open the document', 'Check your connection and try again.');
    } finally {
      setLoading(false);
    }
  };

  const Icon = mimeType.startsWith('image/') ? ImageIcon : FileText;

  return (
    <button
      type="button"
      onClick={open}
      disabled={loading}
      className={cn(
        'group flex w-full items-center gap-3 rounded-lg border border-ink-200 bg-white p-3 text-left transition-colors hover:border-brand-300 hover:bg-brand-50/40 disabled:opacity-60',
        className,
      )}
    >
      <span className="flex size-9 shrink-0 items-center justify-center rounded-lg bg-ink-100 text-ink-500 group-hover:bg-brand-100 group-hover:text-brand-700">
        {loading ? (
          <Loader2 aria-hidden className="size-4 animate-spin" />
        ) : (
          <Icon aria-hidden className="size-4" />
        )}
      </span>

      <span className="min-w-0 flex-1">
        <span className="block truncate text-sm font-medium text-ink-900">{fileName}</span>
        <span className="mt-0.5 flex items-center gap-1.5 text-xs text-ink-500">
          {sensitive && (
            <>
              <ShieldAlert aria-hidden className="size-3" />
              Access is recorded
            </>
          )}
          {!sensitive && mimeType}
        </span>
      </span>

      <ExternalLink
        aria-hidden
        className="size-4 shrink-0 text-ink-400 group-hover:text-brand-700"
      />

      <span className="sr-only">Open {fileName} in a new tab</span>
    </button>
  );
}
