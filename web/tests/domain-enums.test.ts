import { describe, expect, it } from 'vitest';

import * as Domain from '@/types/domain';

import { readMigration, stripSqlComments } from './helpers/sql';

/**
 * The TypeScript status unions must match the Postgres enums exactly. A value
 * present in one but not the other becomes a runtime failure the type checker
 * cannot see.
 */

const SQL_TO_TS: Record<string, Record<string, string>> = {
  profile_role: Domain.ProfileRole,
  profile_status: Domain.ProfileStatus,
  admin_role: Domain.AdminRole,
  actor_type: Domain.ActorType,
  worker_status: Domain.WorkerStatus,
  customer_status: Domain.CustomerStatus,
  worker_availability: Domain.WorkerAvailability,
  verification_type: Domain.VerificationType,
  verification_status: Domain.VerificationStatus,
  booking_status: Domain.BookingStatus,
  booking_event_type: Domain.BookingEventType,
  material_status: Domain.MaterialStatus,
  payment_status: Domain.PaymentStatus,
  payout_status: Domain.PayoutStatus,
  wallet_transaction_type: Domain.WalletTransactionType,
  claim_type: Domain.ClaimType,
  claim_status: Domain.ClaimStatus,
  insurance_status: Domain.InsuranceStatus,
  support_status: Domain.SupportStatus,
  support_priority: Domain.SupportPriority,
  support_category: Domain.SupportCategory,
  notification_channel: Domain.NotificationChannel,
  notification_status: Domain.NotificationStatus,
  contact_message_status: Domain.ContactMessageStatus,
  media_type: Domain.MediaType,
  media_purpose: Domain.MediaPurpose,
  media_sensitivity: Domain.MediaSensitivity,
  media_upload_status: Domain.MediaUploadStatus,
};

function sqlEnums(): Map<string, string[]> {
  const sql = stripSqlComments(readMigration('0001'));
  const enums = new Map<string, string[]>();
  for (const match of sql.matchAll(/create type public\.(\w+) as enum \(([\s\S]*?)\);/g)) {
    enums.set(match[1]!, [...match[2]!.matchAll(/'([A-Z_]+)'/g)].map((m) => m[1]!));
  }
  return enums;
}

describe('domain enums match the database', () => {
  const enums = sqlEnums();

  it('covers every enum declared in the migration', () => {
    expect([...enums.keys()].sort()).toEqual(Object.keys(SQL_TO_TS).sort());
  });

  for (const [sqlName, tsObject] of Object.entries(SQL_TO_TS)) {
    it(`${sqlName} has identical members`, () => {
      expect(Object.values(tsObject)).toEqual(enums.get(sqlName));
    });
  }
});
