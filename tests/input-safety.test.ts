import { describe, expect, it } from 'vitest';

import { asEnumValue, MAX_PAGE_SIZE, parseListParams, rangeFor, sanitiseSearchTerm } from '@/lib/api/list-params';
import { safeRedirect } from '@/lib/auth/safe-redirect';
import { AppError, translateDatabaseError } from '@/lib/errors/app-error';
import { formatMoney, maskPhone } from '@/lib/utils/format';
import { BookingStatus } from '@/types/domain';

describe('list parameters', () => {
  it('caps page size so a crafted request cannot pull a whole table', () => {
    expect(parseListParams({ pageSize: '100000' }).pageSize).toBeLessThanOrEqual(MAX_PAGE_SIZE);
    expect(parseListParams({ page: '-4' }).page).toBe(1);
  });

  it('computes an inclusive range', () => {
    expect(rangeFor(3, 25)).toEqual([50, 74]);
  });

  it('strips PostgREST filter syntax from search terms', () => {
    const term = sanitiseSearchTerm('x),status.eq.PAID,(y');
    expect(term).not.toMatch(/[(),.]/);
    expect(sanitiseSearchTerm('   ')).toBeNull();
  });

  it('drops filter values that are not enum members', () => {
    expect(asEnumValue('PAID', BookingStatus)).toBe('PAID');
    expect(asEnumValue("PAID'; drop table bookings;--", BookingStatus)).toBeUndefined();
  });
});

describe('post-login redirect', () => {
  it('accepts paths inside the admin surface', () => {
    expect(safeRedirect('/admin/workers', '/admin')).toBe('/admin/workers');
    expect(safeRedirect('/admin', '/admin')).toBe('/admin');
  });

  it('refuses open redirects', () => {
    for (const next of ['https://evil.example', '//evil.example', '/\\evil.example', 'javascript:alert(1)', '/public-page', '/administrator']) {
      expect(safeRedirect(next, '/admin'), next).toBeUndefined();
    }
  });

  it('works in subdomain mode with an empty prefix', () => {
    expect(safeRedirect('/workers', '')).toBe('/workers');
    expect(safeRedirect('//evil.example', '')).toBeUndefined();
  });
});

describe('database error translation', () => {
  it('maps tagged database exceptions to typed errors', () => {
    expect(translateDatabaseError({ message: 'FORBIDDEN: missing permission payouts.approve' }).code).toBe('FORBIDDEN');
    expect(translateDatabaseError({ message: 'INVALID_TRANSITION: BK-1 cannot move from REQUESTED to PAID' }).status).toBe(422);
    expect(translateDatabaseError({ message: 'CONFLICT: payout PO-1 is already PROCESSING' }).status).toBe(409);
  });

  it('never leaks a raw database message', () => {
    const error = translateDatabaseError({ message: 'relation "public.secret_table" does not exist', code: '42P01' });
    expect(error).toBeInstanceOf(AppError);
    expect(error.message).not.toContain('secret_table');
    expect(error.status).toBe(500);
  });
});

describe('formatting', () => {
  it('formats integer minor units without float drift', () => {
    expect(formatMoney(1999, 'INR')).toContain('19.99');
    expect(formatMoney(null)).toBe('—');
  });

  it('masks phone numbers', () => {
    expect(maskPhone('9876543210')).toBe('••••••3210');
  });
});
