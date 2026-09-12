'use client';

import { useState, type ReactNode } from 'react';
import { useRouter } from 'next/navigation';

import { Button, type ButtonProps } from '@/components/ui/button';
import { ConfirmDialog } from '@/components/ui/confirm-dialog';
import { useToast } from '@/components/ui/toast';

/**
 * The single way the admin panel performs a mutation.
 *
 * It exists so that no page reimplements the sequence and quietly drops a step:
 *
 *   confirm  -> collect a reason where the action demands one
 *   request  -> POST to the API route (which authenticates, authorizes,
 *               validates, and calls a database function that re-checks
 *               permission and writes the audit log)
 *   respond  -> report the real outcome as a toast, success or failure
 *   refresh  -> re-render from the server so the screen shows what the database
 *               now says, rather than an optimistic guess
 *
 * Note what does not happen: nothing here updates local state to pretend the
 * change succeeded. If the server refused, the screen still shows the truth and
 * the operator is told why.
 */

export interface ActionButtonProps {
  /** API route to call. Always a server endpoint, never a direct table write. */
  endpoint: string;
  method?: 'POST' | 'PATCH' | 'DELETE';
  /** Body sent with the request. The reason is merged in when required. */
  payload?: Record<string, unknown>;

  label: ReactNode;
  variant?: ButtonProps['variant'];
  size?: ButtonProps['size'];
  disabled?: boolean;
  fullWidth?: boolean;

  confirmTitle: string;
  confirmDescription?: ReactNode;
  confirmLabel?: string;
  tone?: 'danger' | 'primary' | 'success';

  /** Demands a typed reason, which is stored on the audit record. */
  requireReason?: boolean;
  reasonLabel?: string;
  reasonHint?: string;
  minReasonLength?: number;

  successMessage: string;
  /** Called after a successful request, before the refresh. */
  onSuccess?: () => void;
}

export function ActionButton({
  endpoint,
  method = 'POST',
  payload = {},
  label,
  variant = 'primary',
  size = 'sm',
  disabled,
  fullWidth,
  confirmTitle,
  confirmDescription,
  confirmLabel,
  tone = 'primary',
  requireReason = false,
  reasonLabel,
  reasonHint,
  minReasonLength = 10,
  successMessage,
  onSuccess,
}: ActionButtonProps) {
  const router = useRouter();
  const toast = useToast();
  const [open, setOpen] = useState(false);
  const [pending, setPending] = useState(false);

  const run = async (reason: string) => {
    setPending(true);

    try {
      const response = await fetch(endpoint, {
        method,
        headers: { 'Content-Type': 'application/json' },
        credentials: 'same-origin',
        body: JSON.stringify(requireReason ? { ...payload, reason } : payload),
      });

      const body: unknown = await response.json().catch(() => null);

      if (!response.ok) {
        const error =
          body && typeof body === 'object' && 'error' in body
            ? (body as { error: { message?: string; fieldErrors?: Record<string, string[]> } })
                .error
            : null;

        // Field errors are flattened into the toast: this control has no form to
        // attach them to, and an operator still needs to see what was wrong.
        const detail =
          error?.fieldErrors && Object.keys(error.fieldErrors).length > 0
            ? Object.values(error.fieldErrors).flat().join(' ')
            : (error?.message ?? 'The server refused the request.');

        toast.error('Action not completed', detail);
        return;
      }

      toast.success(successMessage);
      setOpen(false);
      onSuccess?.();

      // Re-fetch from the server so the page reflects committed state.
      router.refresh();
    } catch {
      toast.error(
        'Action not completed',
        'The request could not be sent. Check your connection and try again.',
      );
    } finally {
      setPending(false);
    }
  };

  return (
    <>
      <Button
        variant={variant}
        size={size}
        disabled={disabled}
        fullWidth={fullWidth}
        onClick={() => setOpen(true)}
      >
        {label}
      </Button>

      <ConfirmDialog
        open={open}
        onClose={() => !pending && setOpen(false)}
        onConfirm={run}
        title={confirmTitle}
        description={confirmDescription}
        confirmLabel={confirmLabel}
        tone={tone}
        requireReason={requireReason}
        reasonLabel={reasonLabel}
        reasonHint={reasonHint}
        minReasonLength={minReasonLength}
        loading={pending}
      />
    </>
  );
}
