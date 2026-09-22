import { cache } from 'react';

import { anonClient } from '@/lib/supabase/server';
import { logger } from '@/lib/logging/logger';
import type { FaqRow, ServiceProblemRow, ServiceRow } from '@/types/database.types';

/**
 * Public website data access.
 *
 * Reads the catalogue through the anonymous client, so Row Level Security is
 * what decides what the public can see — active services, their problems,
 * active FAQs. There is no separate "public" copy of the data to keep in step.
 *
 * Failure policy: the public site must not show a stack trace or a broken page
 * because the database is briefly unavailable. These functions log the failure
 * and return an empty result, and the pages render an honest empty state. They
 * never substitute invented content.
 */

export const getActiveServices = cache(async (): Promise<ServiceRow[]> => {
  const { data, error } = await anonClient()
    .from('services')
    .select('*')
    .eq('is_active', true)
    .order('display_order', { ascending: true })
    .order('name', { ascending: true });

  if (error) {
    logger.error('Failed to load service catalogue', { error: error.message });
    return [];
  }

  return data ?? [];
});

export const getServiceBySlug = cache(
  async (slug: string): Promise<ServiceRow | null> => {
    const { data, error } = await anonClient()
      .from('services')
      .select('*')
      .eq('slug', slug)
      .eq('is_active', true)
      .maybeSingle();

    if (error) {
      logger.error('Failed to load service', { slug, error: error.message });
      return null;
    }

    return data ?? null;
  },
);

export const getServiceProblems = cache(
  async (serviceId: string): Promise<ServiceProblemRow[]> => {
    const { data, error } = await anonClient()
      .from('service_problems')
      .select('*')
      .eq('service_id', serviceId)
      .order('display_order', { ascending: true });

    if (error) {
      logger.error('Failed to load service problems', { serviceId, error: error.message });
      return [];
    }

    return data ?? [];
  },
);

export const getFaqsForService = cache(async (serviceId: string): Promise<FaqRow[]> => {
  const { data, error } = await anonClient()
    .from('faqs')
    .select('*')
    .eq('service_id', serviceId)
    .eq('is_active', true)
    .order('display_order', { ascending: true });

  if (error) {
    logger.error('Failed to load service FAQs', { serviceId, error: error.message });
    return [];
  }

  return data ?? [];
});

export interface FaqGroup {
  category: string;
  items: FaqRow[];
}

/** General FAQs (not tied to a service), grouped by category for /faq. */
export const getGeneralFaqs = cache(async (): Promise<FaqGroup[]> => {
  const { data, error } = await anonClient()
    .from('faqs')
    .select('*')
    .is('service_id', null)
    .eq('is_active', true)
    .order('display_order', { ascending: true });

  if (error) {
    logger.error('Failed to load FAQs', { error: error.message });
    return [];
  }

  // Preserve first-seen category order rather than sorting alphabetically:
  // display_order already encodes the intended reading sequence.
  const groups = new Map<string, FaqRow[]>();

  for (const faq of data ?? []) {
    const existing = groups.get(faq.category);
    if (existing) {
      existing.push(faq);
    } else {
      groups.set(faq.category, [faq]);
    }
  }

  return Array.from(groups, ([category, items]) => ({ category, items }));
});

/**
 * Platform settings marked public.
 *
 * Only rows with is_public are readable by the anonymous role, so a
 * misconfiguration cannot leak an operational threshold onto a marketing page.
 */
export const getPublicSettings = cache(async (): Promise<Record<string, unknown>> => {
  const { data, error } = await anonClient()
    .from('platform_settings')
    .select('key, value')
    .eq('is_public', true);

  if (error) {
    logger.error('Failed to load public settings', { error: error.message });
    return {};
  }

  return Object.fromEntries((data ?? []).map((row) => [row.key, row.value]));
});
