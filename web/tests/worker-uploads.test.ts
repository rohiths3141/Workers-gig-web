import { describe, expect, it } from 'vitest';

import {
  buildStoragePath,
  isWorkerPurpose,
  safeFileName,
} from '@/features/media/server/worker-uploads';

/**
 * The Worker app's upload path is the one place where getting it wrong means a
 * worker's identity document lands in — or is read from — somebody else's
 * folder. Firebase Storage rules cannot express the ownership rule, so this
 * function and the database trigger are the only two things enforcing it.
 */
describe('buildStoragePath', () => {
  const base = {
    pathRoot: 'workers',
    ownerId: '11111111-1111-1111-1111-111111111111',
    pathFolder: 'kyc',
    mediaAssetId: '22222222-2222-2222-2222-222222222222',
    mimeType: 'image/jpeg',
  };

  it('places the file under the owner it was authorized for', () => {
    expect(buildStoragePath(base)).toBe(
      'workers/11111111-1111-1111-1111-111111111111/kyc/22222222-2222-2222-2222-222222222222.jpg',
    );
  });

  it('matches the prefix the database trigger rebuilds', () => {
    // enforce_media_asset_integrity() composes path_root/owner_id/path_folder
    // and refuses anything outside it. If these two ever disagree, every upload
    // fails — so the shape is pinned here.
    const path = buildStoragePath(base);
    expect(path.startsWith('workers/11111111-1111-1111-1111-111111111111/kyc/')).toBe(true);
  });

  it('names the file from the server-generated id, never the client', () => {
    const path = buildStoragePath(base);
    expect(path).toContain(base.mediaAssetId);
  });

  it('maps each accepted type to its extension', () => {
    expect(buildStoragePath({ ...base, mimeType: 'image/png' })).toMatch(/\.png$/);
    expect(buildStoragePath({ ...base, mimeType: 'image/webp' })).toMatch(/\.webp$/);
    expect(buildStoragePath({ ...base, mimeType: 'video/mp4' })).toMatch(/\.mp4$/);
    expect(buildStoragePath({ ...base, mimeType: 'application/pdf' })).toMatch(/\.pdf$/);
  });

  it('omits the extension for an unknown type rather than inventing one', () => {
    const path = buildStoragePath({ ...base, mimeType: 'application/x-unknown' });
    expect(path.endsWith(base.mediaAssetId)).toBe(true);
  });

  it('refuses a path that could traverse out of its folder', () => {
    expect(() => buildStoragePath({ ...base, ownerId: '../other-worker' })).toThrow();
    expect(() => buildStoragePath({ ...base, pathFolder: '../kyc' })).toThrow();
    expect(() => buildStoragePath({ ...base, pathRoot: '..' })).toThrow();
  });

  it('refuses an absolute path', () => {
    expect(() => buildStoragePath({ ...base, pathRoot: '/workers' })).toThrow();
  });

  it('refuses whitespace, which would break the signature', () => {
    expect(() => buildStoragePath({ ...base, ownerId: 'some id' })).toThrow();
  });
});

describe('isWorkerPurpose', () => {
  it('accepts the purposes a worker legitimately uploads', () => {
    for (const purpose of [
      'WORKER_KYC_DOCUMENT',
      'WORKER_QUALIFICATION',
      'BOOKING_AFTER_WORK',
      'BOOKING_RECEIPT',
      'CLAIM_EVIDENCE',
      'SUPPORT_ATTACHMENT',
    ]) {
      expect(isWorkerPurpose(purpose)).toBe(true);
    }
  });

  it('refuses purposes that are not a worker\'s to create', () => {
    // A worker does not upload their own background check result, another
    // person's profile photo, or the service catalogue artwork.
    expect(isWorkerPurpose('WORKER_BACKGROUND_CHECK')).toBe(false);
    expect(isWorkerPurpose('CUSTOMER_PROFILE_PHOTO')).toBe(false);
    expect(isWorkerPurpose('SERVICE_CATALOGUE_IMAGE')).toBe(false);
  });

  it('refuses anything unrecognised', () => {
    expect(isWorkerPurpose('')).toBe(false);
    expect(isWorkerPurpose('ARBITRARY')).toBe(false);
    expect(isWorkerPurpose('worker_kyc_document')).toBe(false);
  });
});

describe('safeFileName', () => {
  it('keeps an ordinary name', () => {
    expect(safeFileName('aadhaar-front.jpg')).toBe('aadhaar-front.jpg');
  });

  it('flattens separators so the display name cannot look like a path', () => {
    expect(safeFileName('../../etc/passwd')).not.toContain('/');
    expect(safeFileName('a\\b\\c.jpg')).not.toContain('\\');
  });

  it('falls back rather than storing an empty name', () => {
    expect(safeFileName('   ')).toBe('upload');
    expect(safeFileName('')).toBe('upload');
  });

  it('truncates an absurdly long name', () => {
    expect(safeFileName('a'.repeat(500)).length).toBe(255);
  });
});
