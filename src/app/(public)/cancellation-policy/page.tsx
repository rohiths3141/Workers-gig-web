import type { Metadata } from 'next';

import { LegalDocument } from '@/components/public/legal-document';
import { absolutePublicUrl, publicRoutes } from '@/lib/config/routes';

export const metadata: Metadata = {
  title: 'Cancellation policy',
  description: 'How and when customers and workers can cancel a booking, and what charges may apply.',
  alternates: { canonical: absolutePublicUrl(publicRoutes.cancellationPolicy) },
};

export default function CancellationPolicyPage() {
  return (
    <LegalDocument
      title="Cancellation policy"
      summary="Cancelling a booking as a customer or a worker, and what happens next."
      lastUpdated="Draft"
      sections={[
        { heading: 'Cancelling as a customer', body: <p>You can cancel a booking from the app until work has started. A reason is recorded with every cancellation.</p> },
        { heading: 'Cancellation charges', body: <p>Cancelling before a worker accepts is free. A charge may apply if the worker has already started travelling or has arrived. The amounts will be specified in the reviewed version of this policy and shown in the app before you confirm.</p> },
        { heading: 'Cancelling as a worker', body: <p>Workers can cancel an accepted booking before arrival with a reason. Repeated cancellations are recorded on the worker’s profile and affect future matching.</p> },
        { heading: 'Cancellation by the platform', body: <p>Operations may cancel a booking where it cannot safely proceed. Every administrative cancellation requires a recorded reason and is logged.</p> },
        { heading: 'Once work has started', body: <p>After work starts, a booking cannot be cancelled from the app. Use the dispute or support options instead.</p> },
      ]}
    />
  );
}
