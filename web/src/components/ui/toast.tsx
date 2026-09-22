'use client';

import {
  createContext,
  useCallback,
  useContext,
  useMemo,
  useState,
  type ReactNode,
} from 'react';
import { AlertTriangle, CheckCircle2, Info, X, XCircle } from 'lucide-react';

import { cn } from '@/lib/utils/cn';

/**
 * Toasts.
 *
 * The replacement for `alert()` and a silent `console.error`. An operator who
 * approves a payout must see that it worked, and an operator whose action was
 * refused must see why.
 *
 * The live region is polite for confirmations and assertive for errors, so a
 * screen reader announces a failure immediately rather than queueing it behind
 * whatever else is being read.
 */

type ToastTone = 'success' | 'error' | 'info' | 'warning';

interface Toast {
  id: string;
  tone: ToastTone;
  title: string;
  description?: string;
}

interface ToastContextValue {
  show: (toast: Omit<Toast, 'id'>) => void;
  success: (title: string, description?: string) => void;
  error: (title: string, description?: string) => void;
  info: (title: string, description?: string) => void;
}

const ToastContext = createContext<ToastContextValue | null>(null);

const TONE_STYLES: Record<ToastTone, { classes: string; icon: typeof Info }> = {
  success: { classes: 'border-success-100 bg-success-50 text-success-700', icon: CheckCircle2 },
  error: { classes: 'border-danger-100 bg-danger-50 text-danger-700', icon: XCircle },
  warning: { classes: 'border-warning-100 bg-warning-50 text-warning-700', icon: AlertTriangle },
  info: { classes: 'border-info-100 bg-info-50 text-info-700', icon: Info },
};

export function ToastProvider({ children }: { children: ReactNode }) {
  const [toasts, setToasts] = useState<Toast[]>([]);

  const dismiss = useCallback((id: string) => {
    setToasts((current) => current.filter((toast) => toast.id !== id));
  }, []);

  const show = useCallback(
    (toast: Omit<Toast, 'id'>) => {
      const id = crypto.randomUUID();
      setToasts((current) => [...current, { ...toast, id }]);

      // Errors stay longer: they usually carry an explanation worth reading.
      const timeout = toast.tone === 'error' ? 9000 : 5000;
      setTimeout(() => dismiss(id), timeout);
    },
    [dismiss],
  );

  const value = useMemo<ToastContextValue>(
    () => ({
      show,
      success: (title, description) => show({ tone: 'success', title, description }),
      error: (title, description) => show({ tone: 'error', title, description }),
      info: (title, description) => show({ tone: 'info', title, description }),
    }),
    [show],
  );

  return (
    <ToastContext.Provider value={value}>
      {children}

      <div
        aria-live="polite"
        aria-atomic="false"
        className="pointer-events-none fixed bottom-4 right-4 z-50 flex w-[min(24rem,calc(100vw-2rem))] flex-col gap-2"
      >
        {toasts.map((toast) => {
          const { classes, icon: Icon } = TONE_STYLES[toast.tone];

          return (
            <div
              key={toast.id}
              role={toast.tone === 'error' ? 'alert' : 'status'}
              className={cn(
                'pointer-events-auto flex items-start gap-3 rounded-lg border p-3.5 shadow-raised',
                classes,
              )}
            >
              <Icon aria-hidden className="mt-0.5 size-4.5 shrink-0" />

              <div className="min-w-0 flex-1">
                <p className="text-sm font-semibold">{toast.title}</p>
                {toast.description && (
                  <p className="mt-0.5 text-[0.8125rem] leading-relaxed opacity-90">
                    {toast.description}
                  </p>
                )}
              </div>

              <button
                type="button"
                onClick={() => dismiss(toast.id)}
                className="-m-1 rounded p-1 opacity-60 transition-opacity hover:opacity-100"
              >
                <X aria-hidden className="size-4" />
                <span className="sr-only">Dismiss notification</span>
              </button>
            </div>
          );
        })}
      </div>
    </ToastContext.Provider>
  );
}

export function useToast(): ToastContextValue {
  const context = useContext(ToastContext);

  if (!context) {
    throw new Error('useToast must be used inside a ToastProvider.');
  }

  return context;
}
