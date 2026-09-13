import type { Metadata } from 'next';

import { LegalDocument } from '@/components/public/legal-document';
import { absolutePublicUrl, publicRoutes } from '@/lib/config/routes';

export const metadata: Metadata = {
  title: 'Refund policy',
  description: 'When refunds are issued, how to request one, and how they are paid.',
  alternates: { canonical: absolutePublicUrl(publicRoutes.refundPolicy) },
};

export default function RefundPolicyPage() {
  return (
    <LegalDocument
      title="Refund policy"
      summary="When a payment can be refunded, how to ask for a refund, and how it reaches you."
      lastUpdated="Draft"
      sections={[
        { heading: 'When refunds apply', body: <ul><li>A payment was taken for a booking that was cancelled before work began.</li><li>A duplicate payment was captured for the same booking.</li><li>A dispute or damage claim was resolved with a refund as the outcome.</li></ul> },
        { heading: 'How to request a refund', body: <p>Raise a support ticket from the booking in the customer app, or contact support with the booking reference.</p> },
        { heading: 'Review', body: <p>Refund requests are reviewed by the finance team. Partial refunds may be issued where part of the work or materials was delivered.</p> },
        { heading: 'How refunds are paid', body: <p>Refunds are returned to the original payment method through the payment gateway. The time for funds to appear depends on your bank or payment provider.</p> },
        { heading: 'Materials', body: <p>Materials already purchased and fitted with your approval are generally not refundable unless they were defective or the claim outcome says otherwise.</p> },
      ]}
    />
  );
}
