'use client';

import { useEffect, useRef, useState, type ReactNode } from 'react';
import { AlertTriangle } from 'lucide-react';

import { Button } from '@/components/ui/button';
import { Textarea } from '@/components/ui/form';
import { cn } from '@/lib/utils/cn';

/**
 * Confirmation dialog for a consequential action.
 *
 * Built on the native `<dialog>` element, which brings focus trapping, Escape
 * handling, inertness of the page behind it and correct modal semantics without
 * reimplementing any of it.
 *
 * When `requireReason` is set, the confirm button stays disabled until a reason
 * of adequate length is typed. That reason is not decoration: it is passed to
 * the server operation and stored on the audit record, and the database refuses
 * the change without it. Asking here means the operator finds out before the
 * request, not after.
 */

export interface ConfirmDialogProps {
  open: boolean;
  onClose: () => void;
  onConfirm: (reason: string) => void | Promise<void>;
  title: string;
  description?: ReactNode;
  confirmLabel?: string;
  cancelLabel?: string;
  tone?: 'danger' | 'primary' | 'success';
  requireReason?: boolean;
  reasonLabel?: string;
  reasonHint?: string;
  minReasonLength?: number;
  loading?: boolean;
}

export function ConfirmDialog({
  open,
  onClose,
  onConfirm,
  title,
  description,
  confirmLabel = 'Confirm',
  cancelLabel = 'Cancel',
  tone = 'primary',
  requireReason = false,
  reasonLabel = 'Reason',
  reasonHint,
  minReasonLength = 10,
  loading = false,
}: ConfirmDialogProps) {
  const dialogRef = useRef<HTMLDialogElement>(null);
  const [reason, setReason] = useState('');
  const [submitting, setSubmitting] = useState(false);

  useEffect(() => {
    const dialog = dialogRef.current;
    if (!dialog) return;

    if (open && !dialog.open) {
      dialog.showModal();
      setReason('');
    } else if (!open && dialog.open) {
      dialog.close();
    }
  }, [open]);

  // Escape and the backdrop close the dialog through the element's own events,
  // so the parent's state stays in step however it was dismissed.
  useEffect(() => {
    const dialog = dialogRef.current;
    if (!dialog) return;

    const handleClose = () => onClose();
    dialog.addEventListener('close', handleClose);
    return () => dialog.removeEventListener('close', handleClose);
  }, [onClose]);

  const reasonValid = !requireReason || reason.trim().length >= minReasonLength;
  const busy = loading || submitting;

  const handleConfirm = async () => {
    if (!reasonValid || busy) return;

    setSubmitting(true);
    try {
      await onConfirm(reason.trim());
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <dialog
      ref={dialogRef}
      className={cn(
        'w-[min(32rem,calc(100vw-2rem))] rounded-xl border border-ink-200 p-0 shadow-overlay',
        'backdrop:bg-ink-950/40 backdrop:backdrop-blur-[1px]',
      )}
      onClick={(event) => {
        // Clicking the backdrop (the dialog element itself) dismisses it.
        if (event.target === dialogRef.current && !busy) onClose();
      }}
    >
      <div className="p-5">
        <div className="flex gap-3.5">
          {tone === 'danger' && (
            <div className="flex size-9 shrink-0 items-center justify-center rounded-full bg-danger-50 text-danger-600">
              <AlertTriangle aria-hidden className="size-4.5" />
            </div>
          )}

          <div className="min-w-0 flex-1">
            <h2 className="text-base font-semibold text-ink-900">{title}</h2>
            {description && (
              <div className="mt-1.5 text-sm leading-relaxed text-ink-600">{description}</div>
            )}
          </div>
        </div>

        {requireReason && (
          <div className="mt-4">
            <Textarea
              label={reasonLabel}
              hint={
                reasonHint ??
                `Recorded in the audit trail. At least ${minReasonLength} characters.`
              }
              value={reason}
              onChange={(event) => setReason(event.target.value)}
              rows={3}
              required
              error={
                reason.length > 0 && !reasonValid
                  ? `Enter at least ${minReasonLength} characters.`
                  : undefined
              }
            />
          </div>
        )}
      </div>

      <div className="flex justify-end gap-2 border-t border-ink-200 bg-ink-50/60 px-5 py-3.5">
        <Button variant="outline" onClick={onClose} disabled={busy}>
          {cancelLabel}
        </Button>
        <Button
          variant={tone === 'danger' ? 'danger' : tone === 'success' ? 'success' : 'primary'}
          onClick={handleConfirm}
          disabled={!reasonValid}
          loading={busy}
        >
          {confirmLabel}
        </Button>
      </div>
    </dialog>
  );
}
