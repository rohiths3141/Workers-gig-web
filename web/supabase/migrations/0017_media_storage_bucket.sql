-- ===========================================================================
-- 0017  Supabase Storage bucket for application media
-- ===========================================================================
-- Media (KYC documents, booking evidence, profile photos, ...) now lives in
-- Supabase Storage instead of Firebase Storage. A single private bucket holds
-- everything, folder-prefixed by public.media_purpose_rules.path_root — the
-- same layout the Firebase-backed implementation used.
--
-- The bucket is private (public = false) and carries no client-facing storage
-- policies: every read and write goes through a signed URL minted by the web
-- tier's service-role client (see web/src/lib/supabase/storage.ts), which
-- bypasses RLS entirely. A client never authenticates to Storage directly, so
-- there is nothing for an authenticated/anon storage policy to grant.
insert into storage.buckets (id, name, public, file_size_limit)
values ('media', 'media', false, 200 * 1024 * 1024)
on conflict (id) do nothing;
