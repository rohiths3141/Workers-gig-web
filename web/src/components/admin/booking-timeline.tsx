import { ShieldAlert } from 'lucide-react';

import { StatusBadge } from '@/components/shared/status-badge';
import { EmptyState } from '@/components/ui/feedback';
import { cn } from '@/lib/utils/cn';
import { formatDateTime, humaniseEnum } from '@/lib/utils/format';
import { bookingEventLabel } from '@/lib/utils/labels';
import type { BookingEventRow } from '@/types/database.types';

/**
 * Booking timeline.
 *
 * Renders exactly the rows in booking_events — nothing more. A step that did
 * not happen does not appear, so the timeline can be read as evidence rather
 * than as a picture of the ideal flow.
 */
export function BookingTimeline({ events }: { events: ReadonlyArray<Pick<BookingEventRow, 'id' | 'event_type' | 'from_status' | 'to_status' | 'actor_type' | 'note' | 'created_at'>> }) {
  if (events.length === 0) {
    return <EmptyState title="No events recorded" description="Timeline events are written by the server as the booking progresses." />;
  }

  return (
    <ol className="relative px-5 py-4">
      {events.map((event, index) => {
        const isOverride = event.event_type === 'ADMIN_OVERRIDE';
        const isLast = index === events.length - 1;

        return (
          <li key={event.id} className="relative flex gap-4 pb-5 last:pb-0">
            {!isLast && <span aria-hidden className="absolute left-[0.4375rem] top-5 h-[calc(100%-0.75rem)] w-px bg-ink-200" />}
            <span
              aria-hidden
              className={cn(
                'relative z-10 mt-1.5 size-3.5 shrink-0 rounded-full border-2 bg-white',
                isOverride ? 'border-danger-500' : 'border-brand-600',
              )}
            />
            <div className="min-w-0 flex-1">
              <div className="flex flex-wrap items-center gap-2">
                <p className="text-sm font-medium text-ink-900">{bookingEventLabel(event.event_type)}</p>
                {isOverride && (
                  <span className="inline-flex items-center gap-1 text-xs font-medium text-danger-700">
                    <ShieldAlert aria-hidden className="size-3" />
                    Override
                  </span>
                )}
                {event.to_status && <StatusBadge kind="booking" status={event.to_status} />}
              </div>
              <p className="mt-0.5 text-xs text-ink-500">
                <time dateTime={event.created_at}>{formatDateTime(event.created_at)}</time> · by {humaniseEnum(event.actor_type).toLowerCase()}
                {event.from_status && event.to_status && ` · ${humaniseEnum(event.from_status)} → ${humaniseEnum(event.to_status)}`}
              </p>
              {event.note && <p className="mt-1.5 rounded-md bg-ink-50 px-3 py-2 text-sm text-ink-700">{event.note}</p>}
            </div>
          </li>
        );
      })}
    </ol>
  );
}
