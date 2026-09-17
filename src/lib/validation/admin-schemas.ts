import { z } from 'zod';

import {
  BookingStatus,
  ClaimStatus,
  CustomerStatus,
  SupportStatus,
  WorkerStatus,
} from '@/types/domain';

/**
 * Request schemas for the admin API.
 *
 * Validation happens on the server, against these schemas, before anything
 * reaches the database. The same rules are then enforced again by the database
 * functions — a reason of adequate length, an amount within bounds, a status
 * that exists. Duplicating them here is not redundancy for its own sake: it
 * turns a transaction failure into a field-level form error the operator can
 * act on.
 */

/** A reason attached to a consequential action, stored on the audit record. */
const reason = z
  .string()
  .trim()
  .min(10, 'Give at least 10 characters explaining why.')
  .max(1000, 'Keep the reason under 1000 characters.');

const shortReason = z
  .string()
  .trim()
  .min(5, 'Give at least 5 characters explaining why.')
  .max(1000);

const uuid = z.string().uuid('That is not a valid reference.');

/** Amounts are integer minor units. Never a float, never a formatted string. */
const amountMinor = z
  .number()
  .int('Amounts must be whole numbers of paise.')
  .positive('The amount must be greater than zero.')
  .max(100_000_000_00, 'That amount is implausibly large.');

// ---------------------------------------------------------------------------
// People
// ---------------------------------------------------------------------------
export const workerStatusSchema = z.object({
  status: z.nativeEnum(WorkerStatus),
  reason,
});

export const customerStatusSchema = z.object({
  status: z.nativeEnum(CustomerStatus),
  reason,
});

// ---------------------------------------------------------------------------
// Bookings
// ---------------------------------------------------------------------------
export const bookingTransitionSchema = z.object({
  status: z.nativeEnum(BookingStatus),
  reason: shortReason,
});

// ---------------------------------------------------------------------------
// Gig review
// ---------------------------------------------------------------------------
export const gigDecisionSchema = z
  .object({
    decision: z.enum(['APPROVE', 'REJECT']),
    reason: z.string().trim().max(1000).optional(),
  })
  .refine((value) => value.decision !== 'REJECT' || (value.reason?.length ?? 0) >= 5, {
    message: 'A rejection needs a reason of at least 5 characters.',
    path: ['reason'],
  });

// ---------------------------------------------------------------------------
// Verification
// ---------------------------------------------------------------------------
export const verificationDecisionSchema = z
  .object({
    decision: z.enum(['APPROVE', 'REJECT', 'REQUEST_INFO', 'TAKE_REVIEW']),
    note: z.string().trim().max(1000).optional(),
    rejectionReason: z.string().trim().max(1000).optional(),
    infoRequested: z.string().trim().max(1000).optional(),
    /** ISO date. Required for checks that go stale, such as a background check. */
    expiresAt: z.string().datetime({ offset: true }).optional(),
  })
  // Each decision carries its own obligation. Catching it here means the
  // operator sees which field is missing, not a database exception.
  .refine(
    (value) =>
      value.decision !== 'REJECT' ||
      (value.rejectionReason !== undefined && value.rejectionReason.length >= 5),
    { message: 'A rejection needs a reason of at least 5 characters.', path: ['rejectionReason'] },
  )
  .refine(
    (value) =>
      value.decision !== 'REQUEST_INFO' ||
      (value.infoRequested !== undefined && value.infoRequested.length >= 5),
    { message: 'State what additional information is required.', path: ['infoRequested'] },
  );

// ---------------------------------------------------------------------------
// Finance
// ---------------------------------------------------------------------------
export const payoutDecisionSchema = z
  .object({
    decision: z.enum(['APPROVE', 'REJECT']),
    reason: z.string().trim().max(1000).optional(),
  })
  .refine(
    (value) => value.decision !== 'REJECT' || (value.reason !== undefined && value.reason.length >= 5),
    { message: 'A rejection needs a reason of at least 5 characters.', path: ['reason'] },
  );

export const walletAdjustmentSchema = z.object({
  amountMinor,
  direction: z.enum(['CREDIT', 'DEBIT']),
  reason,
  /**
   * Supplied by the client so a retried or double-submitted request posts one
   * ledger entry. The database enforces uniqueness on it.
   */
  idempotencyKey: z.string().uuid(),
});

export const refundSchema = z.object({
  amountMinor,
  reason,
  idempotencyKey: z.string().uuid(),
});

// ---------------------------------------------------------------------------
// Claims
// ---------------------------------------------------------------------------
export const claimDecisionSchema = z
  .object({
    decision: z.enum([
      'TAKE_REVIEW',
      'REQUEST_INFO',
      'APPROVE',
      'PARTIALLY_APPROVE',
      'REJECT',
      'CLOSE',
    ]),
    amountMinor: z.number().int().nonnegative().optional(),
    note: z.string().trim().max(2000).optional(),
    reason: z.string().trim().max(2000).optional(),
  })
  .refine(
    (value) =>
      !['APPROVE', 'PARTIALLY_APPROVE'].includes(value.decision) ||
      (value.amountMinor !== undefined && value.amountMinor > 0),
    { message: 'State the amount being approved.', path: ['amountMinor'] },
  )
  .refine(
    (value) =>
      value.decision !== 'REJECT' || (value.reason !== undefined && value.reason.length >= 10),
    {
      message: 'Rejecting a claim needs a reason of at least 10 characters.',
      path: ['reason'],
    },
  );

// ---------------------------------------------------------------------------
// Support
// ---------------------------------------------------------------------------
export const supportMessageSchema = z.object({
  body: z.string().trim().min(1, 'Write a message.').max(5000),
  /** Internal notes are staff-only and filtered out by RLS for the requester. */
  isInternal: z.boolean().default(false),
});

export const supportStatusSchema = z.object({
  status: z.nativeEnum(SupportStatus),
  note: z.string().trim().max(2000).optional(),
});

export const supportAssignSchema = z.object({
  adminId: uuid,
});

// ---------------------------------------------------------------------------
// Matching
// ---------------------------------------------------------------------------
export const rerunMatchingSchema = z.object({
  reason: z.string().trim().max(500).optional(),
});

// ---------------------------------------------------------------------------
// Re-exported for the claim decision UI
// ---------------------------------------------------------------------------
export const CLAIM_TERMINAL_STATUSES = [
  ClaimStatus.APPROVED,
  ClaimStatus.PARTIALLY_APPROVED,
  ClaimStatus.REJECTED,
  ClaimStatus.CLOSED,
] as const;
