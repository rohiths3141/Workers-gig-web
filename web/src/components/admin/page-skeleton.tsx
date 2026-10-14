import { Card } from '@/components/ui/card';
import { Skeleton, SkeletonTable, SkeletonText } from '@/components/ui/feedback';

/**
 * What an admin page shows while the server renders it.
 *
 * Every admin page is rendered per request (authorization cannot be cached),
 * so there is always a wait between a click and the page. Without these the
 * previous page sat there unchanged and the click looked ignored. Each
 * route's loading.tsx picks the shape closest to the page it stands in for.
 */

function HeaderSkeleton() {
  return (
    <div className="mb-5 flex flex-wrap items-end justify-between gap-3">
      <div className="space-y-2">
        <Skeleton className="h-7 w-56" />
        <Skeleton className="h-4 w-80 max-w-full" />
      </div>
      <Skeleton className="h-9 w-32" />
    </div>
  );
}

/** A list page: title, filters, table. */
export function ListPageSkeleton() {
  return (
    <div role="status" aria-label="Loading page">
      <HeaderSkeleton />
      <div className="mb-4 flex flex-wrap gap-2">
        <Skeleton className="h-9 w-64 max-w-full" />
        <Skeleton className="h-9 w-36" />
        <Skeleton className="h-9 w-36" />
      </div>
      <Card>
        <SkeletonTable rows={10} columns={5} />
      </Card>
    </div>
  );
}

/** A detail page or dashboard: title, stat tiles, cards. */
export function DetailPageSkeleton() {
  return (
    <div role="status" aria-label="Loading page">
      <HeaderSkeleton />
      <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-4">
        {Array.from({ length: 4 }).map((_, index) => (
          <Card key={index} className="p-4">
            <Skeleton className="h-3.5 w-24" />
            <Skeleton className="mt-3 h-7 w-20" />
          </Card>
        ))}
      </div>
      <div className="mt-5 grid gap-5 xl:grid-cols-3">
        <div className="space-y-5 xl:col-span-2">
          <Card className="p-5">
            <Skeleton className="mb-4 h-5 w-32" />
            <SkeletonText lines={5} />
          </Card>
          <Card className="p-5">
            <Skeleton className="mb-4 h-5 w-40" />
            <SkeletonText lines={4} />
          </Card>
        </div>
        <div className="space-y-5">
          <Card className="p-5">
            <Skeleton className="mb-4 h-5 w-28" />
            <SkeletonText lines={3} />
          </Card>
          <Card className="p-5">
            <Skeleton className="mb-4 h-5 w-36" />
            <SkeletonText lines={4} />
          </Card>
        </div>
      </div>
    </div>
  );
}
