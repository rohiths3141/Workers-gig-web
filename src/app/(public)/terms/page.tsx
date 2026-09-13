import type { Metadata } from 'next';

import { LegalDocument } from '@/components/public/legal-document';
import { absolutePublicUrl, publicRoutes } from '@/lib/config/routes';

export const metadata: Metadata = {
  title: 'Terms of service',
  description: 'The terms governing use of the platform by customers and workers.',
  alternates: { canonical: absolutePublicUrl(publicRoutes.terms) },
};

export default function TermsPage() {
  return (
    <LegalDocument
      title="Terms of service"
      summary="The rules for using the platform, for customers booking services and for workers providing them."
      lastUpdated="Draft"
      sections={[
        {
          heading: 'The platform',
          body: <p>The platform connects customers with independent skilled workers. Workers provide services to customers directly; the platform facilitates matching, verification, job records, payment and dispute handling.</p>,
        },
        {
          heading: 'Accounts',
          body: <p>You sign in with a one-time code sent to your mobile number, or with a Google account. You are responsible for activity on your account and must keep access to your phone and Google account secure.</p>,
        },
        {
          heading: 'Verification',
          body: <p>Workers must complete identity and background verification, and trade qualification checks where required, before accepting jobs. Verification confirms that specific checks were completed; it is not a guarantee of the outcome of any particular job.</p>,
        },
        {
          heading: 'Bookings and pricing',
          body: <p>A booking is confirmed when the customer confirms a matched worker. Quotes are provided before work begins. Materials are purchased only after the customer approves the estimate, and are billed at the recorded actual cost.</p>,
        },
        {
          heading: 'Payments',
          body: <p>Payments are processed through a third-party payment gateway. A payment is treated as complete only when the gateway confirms it. The platform deducts its fee from the labour component before crediting the worker’s wallet.</p>,
        },
        {
          heading: 'Conduct',
          body: (
            <ul>
              <li>Customers must provide accurate job details and a safe working environment.</li>
              <li>Workers must only accept work within their verified trade and complete it with reasonable skill and care.</li>
              <li>Both parties must treat each other with respect. Harassment, fraud or taking transactions off-platform may lead to restriction or suspension.</li>
            </ul>
          ),
        },
        {
          heading: 'Disputes and damage claims',
          body: <p>Disputes and damage claims are reviewed by the trust and safety team against the job record. Decisions are made by people, recorded with reasons, and communicated to the parties.</p>,
        },
        {
          heading: 'Insurance',
          body: <p>The platform is not an insurer. Where a worker holds an insurance policy, coverage is governed by that policy and decided by the insurer.</p>,
        },
        {
          heading: 'Limitation of liability',
          body: <p>The limits of the platform’s liability will be set out in the reviewed version of these terms.</p>,
        },
        {
          heading: 'Governing law',
          body: <p>These terms will be governed by the laws of India. Jurisdiction will be specified in the reviewed version.</p>,
        },
      ]}
    />
  );
}
