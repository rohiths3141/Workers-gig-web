import {
  Hammer,
  Paintbrush,
  ShieldCheck,
  Sparkles,
  Droplet,
  WashingMachine,
  Wind,
  Wrench,
  Zap,
  type LucideIcon,
} from 'lucide-react';

import { cn } from '@/lib/utils/cn';

/**
 * Resolve a service's `icon_key` to an icon.
 *
 * The catalogue stores a key, not a component or a URL, so the database stays
 * free of presentation detail and an unknown key degrades to a sensible default
 * rather than rendering nothing.
 */
const ICONS: Record<string, LucideIcon> = {
  zap: Zap,
  droplet: Droplet,
  wind: Wind,
  'washing-machine': WashingMachine,
  hammer: Hammer,
  paintbrush: Paintbrush,
  sparkles: Sparkles,
  wrench: Wrench,
  shield: ShieldCheck,
};

export function ServiceIcon({
  iconKey,
  className,
}: {
  iconKey: string | null | undefined;
  className?: string;
}) {
  const Icon = (iconKey && ICONS[iconKey]) || Wrench;
  return <Icon aria-hidden className={cn('size-5', className)} />;
}
