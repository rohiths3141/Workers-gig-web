import { createHash } from 'node:crypto';

import type { NextRequest } from 'next/server';
import { z } from 'zod';

import { fail, ok } from '@/lib/api/response';
import { serverEnv } from '@/lib/config/env';
import { AppError } from '@/lib/errors/app-error';
import { logger } from '@/lib/logging/logger';
import { serviceClient } from '@/lib/supabase/server';

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

/**
 * Public contact form.
 *
 * The one public write endpoint, so it carries its own defences:
 *
 *   - Validated with the same rules as the database check constraints.
 *   - A honeypot field that real visitors never see or fill.
 *   - Rate limited per source using a salted hash of the IP, counted in the
 *     database so the limit holds across serverless instances. The raw IP is
 *     never stored.
 *   - Written with the service role because anonymous visitors have no INSERT
 *     grant on contact_messages — RLS keeps the table unreadable to the public.
 */

// Not exported: a Next.js route file may only export HTTP handlers and route
// segment config, and the build rejects anything else.
const contactSchema = z.object({
  name: z.string().trim().min(2, 'Enter your name.').max(120),
  email: z.string().trim().email('Enter a valid email address.').max(254),
  phone: z
    .string()
    .trim()
    .max(20)
    .regex(/^\+?[0-9\s-]{7,20}$/, 'Enter a valid phone number.')
    .optional()
    .or(z.literal('')),
  subject: z.string().trim().min(3, 'Enter a subject.').max(200),
  message: z
    .string()
    .trim()
    .min(10, 'Tell us a little more — at least 10 characters.')
    .max(5000),
  /** Honeypot. Hidden from people, filled by naive bots. */
  website: z.string().max(0).optional().or(z.literal('')),
});

const WINDOW_MINUTES = 60;
const MAX_PER_WINDOW = 5;

export async function POST(request: NextRequest) {
  if (!serverEnv().features.contactFormEnabled) {
    return fail(new AppError('UPSTREAM_FAILURE', 'The contact form is temporarily unavailable. Please email us instead.'));
  }

  let body: z.infer<typeof contactSchema>;

  try {
    body = contactSchema.parse(await request.json());
  } catch (error) {
    if (error instanceof z.ZodError) {
      const fieldErrors: Record<string, string[]> = {};
      for (const issue of error.issues) {
        const key = issue.path.join('.') || '_';
        (fieldErrors[key] ??= []).push(issue.message);
      }
      // A filled honeypot is answered like success so a bot learns nothing.
      if (fieldErrors.website) return ok({ received: true });
      return fail(AppError.validation('Please correct the highlighted fields.', fieldErrors));
    }
    return fail(AppError.validation('The request body must be valid JSON.'));
  }

  const ip = request.headers.get('x-forwarded-for')?.split(',')[0]?.trim() ?? 'unknown';
  // Salted with the service key so the hash cannot be reversed by brute-forcing
  // the IPv4 space against a leaked table.
  const ipHash = createHash('sha256')
    .update(`${serverEnv().supabase.serviceRoleKey}:${ip}`)
    .digest('hex');

  const db = serviceClient();
  const since = new Date(Date.now() - WINDOW_MINUTES * 60_000).toISOString();

  const { count, error: countError } = await db
    .from('contact_messages')
    .select('id', { count: 'exact', head: true })
    .eq('ip_hash', ipHash)
    .gte('created_at', since);

  if (countError) {
    logger.error('Contact rate-limit check failed', { error: countError.message });
    return fail(AppError.internal('Your message could not be sent. Please try again or email us.'));
  }

  if ((count ?? 0) >= MAX_PER_WINDOW) {
    return fail(
      new AppError('RATE_LIMITED', 'You have sent several messages recently. Please wait a while before sending another.'),
    );
  }

  const { error } = await db.from('contact_messages').insert({
    name: body.name,
    email: body.email,
    phone: body.phone || null,
    subject: body.subject,
    message: body.message,
    ip_hash: ipHash,
    user_agent: request.headers.get('user-agent')?.slice(0, 512) ?? null,
  });

  if (error) {
    logger.error('Contact message insert failed', { error: error.message });
    return fail(AppError.internal('Your message could not be sent. Please try again or email us.'));
  }

  return ok({ received: true }, undefined, 201);
}
