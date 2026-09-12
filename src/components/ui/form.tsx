'use client';

import {
  forwardRef,
  useId,
  type InputHTMLAttributes,
  type ReactNode,
  type SelectHTMLAttributes,
  type TextareaHTMLAttributes,
} from 'react';

import { cn } from '@/lib/utils/cn';

/**
 * Form controls.
 *
 * Every control is wired for accessibility by construction rather than by
 * remembering: the label is associated through a generated id, the error is
 * linked with aria-describedby, and an invalid field carries aria-invalid. A
 * field cannot be rendered without a label.
 */

const CONTROL_BASE =
  'w-full rounded-lg border bg-white px-3 text-sm text-ink-900 placeholder:text-ink-400 ' +
  'transition-colors disabled:cursor-not-allowed disabled:bg-ink-50 disabled:text-ink-500 ' +
  'focus:outline-none focus:ring-2 focus:ring-brand-600/20';

const CONTROL_VALID = 'border-ink-300 focus:border-brand-600';
const CONTROL_INVALID = 'border-danger-500 focus:border-danger-600 focus:ring-danger-500/20';

interface FieldShellProps {
  id: string;
  label: string;
  hint?: string;
  error?: string;
  required?: boolean;
  children: ReactNode;
  className?: string;
}

function FieldShell({ id, label, hint, error, required, children, className }: FieldShellProps) {
  return (
    <div className={cn('space-y-1.5', className)}>
      <label htmlFor={id} className="block text-sm font-medium text-ink-800">
        {label}
        {required && (
          <>
            <span aria-hidden className="ml-0.5 text-danger-600">
              *
            </span>
            <span className="sr-only"> (required)</span>
          </>
        )}
      </label>

      {children}

      {hint && !error && (
        <p id={`${id}-hint`} className="text-xs text-ink-500">
          {hint}
        </p>
      )}

      {error && (
        <p id={`${id}-error`} className="text-xs font-medium text-danger-600">
          {error}
        </p>
      )}
    </div>
  );
}

function describedBy(id: string, hint?: string, error?: string): string | undefined {
  if (error) return `${id}-error`;
  if (hint) return `${id}-hint`;
  return undefined;
}

/* ==========================================================================
   Input
   ========================================================================== */

export interface InputProps extends Omit<InputHTMLAttributes<HTMLInputElement>, 'id'> {
  label: string;
  hint?: string;
  error?: string;
  containerClassName?: string;
}

export const Input = forwardRef<HTMLInputElement, InputProps>(function Input(
  { label, hint, error, className, containerClassName, required, ...props },
  ref,
) {
  const id = useId();

  return (
    <FieldShell
      id={id}
      label={label}
      hint={hint}
      error={error}
      required={required}
      className={containerClassName}
    >
      <input
        ref={ref}
        id={id}
        required={required}
        aria-invalid={error ? true : undefined}
        aria-describedby={describedBy(id, hint, error)}
        className={cn(CONTROL_BASE, 'h-10', error ? CONTROL_INVALID : CONTROL_VALID, className)}
        {...props}
      />
    </FieldShell>
  );
});

/* ==========================================================================
   Textarea
   ========================================================================== */

export interface TextareaProps extends Omit<TextareaHTMLAttributes<HTMLTextAreaElement>, 'id'> {
  label: string;
  hint?: string;
  error?: string;
  containerClassName?: string;
}

export const Textarea = forwardRef<HTMLTextAreaElement, TextareaProps>(function Textarea(
  { label, hint, error, className, containerClassName, required, rows = 4, ...props },
  ref,
) {
  const id = useId();

  return (
    <FieldShell
      id={id}
      label={label}
      hint={hint}
      error={error}
      required={required}
      className={containerClassName}
    >
      <textarea
        ref={ref}
        id={id}
        rows={rows}
        required={required}
        aria-invalid={error ? true : undefined}
        aria-describedby={describedBy(id, hint, error)}
        className={cn(CONTROL_BASE, 'py-2', error ? CONTROL_INVALID : CONTROL_VALID, className)}
        {...props}
      />
    </FieldShell>
  );
});

/* ==========================================================================
   Select
   ========================================================================== */

export interface SelectOption {
  value: string;
  label: string;
}

export interface SelectProps extends Omit<SelectHTMLAttributes<HTMLSelectElement>, 'id'> {
  label: string;
  options: readonly SelectOption[];
  hint?: string;
  error?: string;
  placeholder?: string;
  containerClassName?: string;
}

export const Select = forwardRef<HTMLSelectElement, SelectProps>(function Select(
  { label, options, hint, error, placeholder, className, containerClassName, required, ...props },
  ref,
) {
  const id = useId();

  return (
    <FieldShell
      id={id}
      label={label}
      hint={hint}
      error={error}
      required={required}
      className={containerClassName}
    >
      <select
        ref={ref}
        id={id}
        required={required}
        aria-invalid={error ? true : undefined}
        aria-describedby={describedBy(id, hint, error)}
        className={cn(CONTROL_BASE, 'h-10', error ? CONTROL_INVALID : CONTROL_VALID, className)}
        {...props}
      >
        {placeholder && <option value="">{placeholder}</option>}
        {options.map((option) => (
          <option key={option.value} value={option.value}>
            {option.label}
          </option>
        ))}
      </select>
    </FieldShell>
  );
});

/* ==========================================================================
   Checkbox
   ========================================================================== */

export interface CheckboxProps extends Omit<InputHTMLAttributes<HTMLInputElement>, 'id' | 'type'> {
  label: string;
  hint?: string;
}

export const Checkbox = forwardRef<HTMLInputElement, CheckboxProps>(function Checkbox(
  { label, hint, className, ...props },
  ref,
) {
  const id = useId();

  return (
    <div className="flex gap-2.5">
      <input
        ref={ref}
        id={id}
        type="checkbox"
        aria-describedby={hint ? `${id}-hint` : undefined}
        className={cn(
          'mt-0.5 size-4 shrink-0 rounded border-ink-300 text-brand-700 focus:ring-2 focus:ring-brand-600/30',
          className,
        )}
        {...props}
      />
      <div className="min-w-0">
        <label htmlFor={id} className="text-sm text-ink-800">
          {label}
        </label>
        {hint && (
          <p id={`${id}-hint`} className="text-xs text-ink-500">
            {hint}
          </p>
        )}
      </div>
    </div>
  );
});
