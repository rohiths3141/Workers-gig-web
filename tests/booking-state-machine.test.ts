import { describe, expect, it } from 'vitest';

import { BookingStatus, TERMINAL_BOOKING_STATUSES } from '@/types/domain';

import { functionBody, readMigration, stripSqlComments } from './helpers/sql';

interface Transition {
  from: string;
  to: string;
  actors: string[];
  event: string;
  requiresReason: boolean;
}

const sql = readMigration('0010');

function transitions(): Transition[] {
  const code = stripSqlComments(sql);
  return [...code.matchAll(/\('([A-Z_]+)',\s*'([A-Z_]+)',\s*array\[([^\]]*)\]::public\.actor_type\[\],\s*'([A-Z_]+)',\s*(true|false)/g)].map((m) => ({
    from: m[1]!,
    to: m[2]!,
    actors: [...m[3]!.matchAll(/'([A-Z]+)'/g)].map((a) => a[1]!),
    event: m[4]!,
    requiresReason: m[5] === 'true',
  }));
}

const table = transitions();
const allowed = (from: string, to: string) => table.find((t) => t.from === from && t.to === to);

describe('booking state machine (public.booking_transitions)', () => {
  it('parses a non-trivial transition table', () => {
    expect(table.length).toBeGreaterThan(20);
  });

  it('only references real statuses', () => {
    const statuses = Object.values(BookingStatus) as string[];
    for (const t of table) {
      expect(statuses).toContain(t.from);
      expect(statuses).toContain(t.to);
    }
  });

  it('allows the full happy path from request to close', () => {
    const path = ['REQUESTED', 'ACCEPTED', 'CONFIRMED', 'TRAVELING', 'ARRIVED', 'IN_PROGRESS', 'AWAITING_APPROVAL', 'COMPLETED', 'PAYMENT_PENDING', 'PAID', 'CLOSED'];
    for (let i = 0; i < path.length - 1; i += 1) {
      expect(allowed(path[i]!, path[i + 1]!), `${path[i]} -> ${path[i + 1]}`).toBeDefined();
    }
  });

  it('rejects skipping steps', () => {
    expect(allowed('REQUESTED', 'COMPLETED')).toBeUndefined();
    expect(allowed('REQUESTED', 'PAID')).toBeUndefined();
    expect(allowed('CONFIRMED', 'IN_PROGRESS')).toBeUndefined();
    expect(allowed('IN_PROGRESS', 'PAID')).toBeUndefined();
  });

  it('has no way out of a terminal status', () => {
    for (const status of TERMINAL_BOOKING_STATUSES) {
      expect(table.filter((t) => t.from === status)).toEqual([]);
    }
  });

  it('requires a reason for every cancellation and dispute', () => {
    for (const t of table.filter((x) => x.to === 'CANCELLED' || x.to === 'DISPUTED')) {
      expect(t.requiresReason, `${t.from} -> ${t.to}`).toBe(true);
    }
  });

  it('lets only the trusted system mark a booking paid', () => {
    const toPaid = table.filter((t) => t.to === 'PAID');
    expect(toPaid.length).toBeGreaterThan(0);
    for (const t of toPaid) expect(t.actors).toEqual(['SYSTEM']);
  });

  it('never lets a customer or worker act for the other side at arrival', () => {
    expect(allowed('TRAVELING', 'ARRIVED')?.actors).toEqual(['WORKER']);
    expect(allowed('AWAITING_APPROVAL', 'COMPLETED')?.actors).not.toContain('WORKER');
  });
});

describe('trusted transition functions', () => {
  const body = functionBody(sql, 'transition_booking');
  const adminBody = functionBody(sql, 'admin_transition_booking');

  it('locks the row before reading the current status', () => {
    expect(body).toMatch(/for update/);
  });

  it('refuses transitions absent from the table', () => {
    expect(body).toMatch(/INVALID_TRANSITION/);
  });

  it('requires a reason for administrative overrides', () => {
    expect(body).toMatch(/administrative override requires a reason/);
  });

  it('checks permission before an administrative change', () => {
    expect(adminBody).toMatch(/require_permission/);
    expect(adminBody).toMatch(/bookings\.cancel/);
  });

  it('writes the timeline event and the audit log in the same function', () => {
    expect(body).toMatch(/insert into public\.booking_events/);
    expect(body).toMatch(/write_audit_log/);
  });
});
