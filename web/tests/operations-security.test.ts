import { describe, expect, it } from 'vitest';

import { allMigrations, functionBody, readMigration, sourceFiles, stripSqlComments } from './helpers/sql';

/**
 * Static security assertions over the database layer and the application
 * source. These catch regressions that would otherwise only show up as an
 * incident: a decision function that forgets its permission check, a ledger
 * that becomes editable, a client component that imports a server secret.
 */

const ops = readMigration('0011');
const verification = readMigration('0010');
const finance = stripSqlComments(readMigration('0005'));
const platform = stripSqlComments(readMigration('0007'));
const media = readMigration('0008');
const rls = stripSqlComments(readMigration('0009'));
const everything = stripSqlComments(allMigrations());

describe('privileged operations check permission and audit', () => {
  const cases: Array<[string, string, string[]]> = [
    ['decide_verification', verification, ['verification.approve', 'verification.reject']],
    ['decide_payout', ops, ['payouts.approve', 'payouts.reject']],
    ['decide_claim', ops, ['claims.approve', 'claims.reject']],
    ['admin_adjust_wallet', ops, ['wallets.adjust']],
    ['admin_set_worker_status', ops, ['workers.restrict']],
    ['admin_set_customer_status', ops, ['customers.restrict']],
    ['admin_rerun_matching', ops, ['matching.rerun']],
  ];

  for (const [name, source, permissions] of cases) {
    it(`${name} requires ${permissions.join(' / ')} and writes an audit entry`, () => {
      const body = functionBody(source, name);
      expect(body).toMatch(/require_permission/);
      for (const permission of permissions) expect(body).toContain(permission);
      expect(body).toMatch(/write_audit_log/);
    });
  }
});

describe('verification', () => {
  const body = functionBody(verification, 'decide_verification');

  it('refuses self-approval', () => {
    expect(body).toMatch(/firebase_uid = public\.firebase_uid\(\)/);
    expect(body).toMatch(/may not decide their own verification/);
  });

  it('requires a reason to reject', () => {
    expect(body).toMatch(/rejection requires a reason/);
  });
});

describe('claims are never auto-approved', () => {
  it('has no trigger on claims beyond bookkeeping', () => {
    const triggers = [...everything.matchAll(/create trigger (\w+)\s+(?:before|after)[^;]*?on public\.claims\b/g)].map((m) => m[1]);
    expect(triggers.sort()).toEqual(['claims_assign_code', 'claims_touch_updated_at']);
  });

  it('sets an approved claim status only inside decide_claim', () => {
    const withoutDecideClaim = everything.replace(functionBody(everything, 'decide_claim'), '');
    expect(withoutDecideClaim).not.toMatch(/'PARTIALLY_APPROVED'::public\.claim_status|when 'APPROVE'\s+then 'APPROVED'[\s\S]{0,80}claim_status/);
    expect(functionBody(ops, 'decide_claim')).toMatch(/'PARTIALLY_APPROVE' then 'PARTIALLY_APPROVED'/);
  });
});

describe('payments', () => {
  it('refuses SUCCESS without a verified gateway signature', () => {
    expect(finance).toMatch(/payments_success_requires_verification/);
    expect(finance).toMatch(/gateway_signature_verified and gateway_payment_id is not null/);
  });

  it('confirm_payment rejects an unverified signature and is idempotent', () => {
    const body = functionBody(ops, 'confirm_payment');
    expect(body).toMatch(/if not p_signature_verified then/);
    expect(body).toMatch(/v_payment\.status = 'SUCCESS'/);
  });

  it('confirm_payment is not executable by client roles', () => {
    expect(rls).toMatch(/revoke all on all functions in schema public from anon, authenticated/);
    expect(everything).not.toMatch(/grant execute on function[^;]*confirm_payment[^;]*to[^;]*authenticated/);
  });
});

describe('wallet ledger', () => {
  it('is immutable', () => {
    expect(finance).toMatch(/before update or delete on public\.wallet_transactions/);
  });

  it('derives the balance by trigger rather than assignment', () => {
    expect(finance).toMatch(/wallet_transactions_sync_balance/);
  });

  it('enforces idempotency keys', () => {
    expect(finance).toMatch(/idempotency_key text not null unique/);
    expect(functionBody(ops, 'decide_payout')).toMatch(/'payout:' \|\| v_payout\.id::text/);
  });

  it('allows only one payout in flight per worker', () => {
    expect(finance).toMatch(/payouts_one_in_flight_per_worker/);
  });
});

describe('audit trail', () => {
  it('is append-only', () => {
    expect(platform).toMatch(/before update or delete on public\.audit_logs/);
  });
});

describe('row level security', () => {
  it('enables and forces RLS on every public table', () => {
    expect(rls).toMatch(/enable row level security/);
    expect(rls).toMatch(/force row level security/);
  });

  it('never grants blanket access to authenticated users', () => {
    expect(rls).not.toMatch(/using \(true\)[\s\S]{0,40}on public\.(bookings|payments|workers|customers|claims)/);
    expect(rls).not.toMatch(/grant (all|insert|update|delete)[^;]*on public\.(bookings|payments|wallets|wallet_transactions|payouts|worker_verifications|audit_logs)[^;]*to authenticated/);
  });

  it('keeps sensitive worker columns out of the self-update grant', () => {
    const grant = /grant update \(([^)]*)\)\s+on public\.workers to authenticated/.exec(rls)?.[1] ?? '';
    for (const column of ['status', 'is_kyc_verified', 'is_background_verified', 'rating_avg', 'restriction_reason']) {
      expect(grant).not.toContain(column);
    }
  });
});

describe('media (Firebase Storage references)', () => {
  it('derives sensitivity from purpose and enforces the storage path prefix', () => {
    const body = functionBody(media, 'enforce_media_asset_integrity');
    expect(body).toMatch(/new\.sensitivity := v_rule\.sensitivity/);
    expect(body).toMatch(/does not belong under/);
  });

  it('forbids path traversal', () => {
    expect(media).toMatch(/media_assets_path_not_traversable/);
  });
});

describe('identity and storage providers', () => {
  it('uses no Supabase Auth or Supabase Storage in the database', () => {
    expect(everything).not.toMatch(/auth\.users/);
    expect(everything).not.toMatch(/auth\.uid\(\)/);
    expect(everything).not.toMatch(/storage\.(buckets|objects)/);
  });

  const files = sourceFiles();

  it('uses no Supabase Auth or Supabase Storage in the application', () => {
    for (const file of files) {
      expect(file.content, file.path).not.toMatch(/supabase\.auth\.|\.auth\.(signIn|signUp|getSession)/);
      expect(file.content, file.path).not.toMatch(/\.storage\.from\(/);
    }
  });

  it('never imports server secrets into client components', () => {
    for (const file of files.filter((f) => /^['"]use client['"]/.test(f.content.trimStart()))) {
      expect(file.content, file.path).not.toMatch(/@\/lib\/supabase\/server|@\/lib\/firebase\/admin|serverEnv\(|SERVICE_ROLE/);
    }
  });

  it('does not use alert() or stray console.error for user feedback', () => {
    // Match executable code only. Comments legitimately name alert() and
    // console.error when explaining what a component replaces.
    const codeOnly = (source: string) =>
      source.replace(/\/\*[\s\S]*?\*\//g, '').replace(/^\s*\/\/.*$/gm, '').replace(/\s\/\/\s.*$/gm, '');

    for (const file of files) {
      const code = codeOnly(file.content);
      expect(code, file.path).not.toMatch(/\balert\(/);
      if (!file.path.includes('logger')) expect(code, file.path).not.toMatch(/console\.error/);
    }
  });
});
