import type { Metadata } from 'next';

import { LegalDocument } from '@/components/public/legal-document';
import { absolutePublicUrl, publicRoutes } from '@/lib/config/routes';

export const metadata: Metadata = {
  title: 'Privacy policy',
  description: 'What personal data the platform collects, why, where it is stored, and your rights.',
  alternates: { canonical: absolutePublicUrl(publicRoutes.privacy) },
};

export default function PrivacyPage() {
  return (
    <LegalDocument
      title="Privacy policy"
      summary="What we collect, why we collect it, where it is kept, who can see it, and the choices you have."
      lastUpdated="Draft"
      sections={[
        {
          heading: 'Who this policy covers',
          body: <p>Customers and workers using the mobile apps, visitors to this website, and administrators of the platform.</p>,
        },
        {
          heading: 'Information we collect',
          body: (
            <ul>
              <li><strong>Account information:</strong> your phone number or Google account email, and display name, provided when you sign in with a one-time code or Google.</li>
              <li><strong>Booking information:</strong> service address, problem description, scheduled time, and job evidence such as photographs.</li>
              <li><strong>Worker verification information:</strong> identity documents, trade certificates, skill certificates, background check results and insurance records.</li>
              <li><strong>Payment information:</strong> payment amounts and gateway references. Card and bank details are handled by the payment gateway and are not stored by us.</li>
              <li><strong>Location:</strong> the service address for a booking, and a worker’s location when they are available for jobs, to match workers to nearby jobs.</li>
              <li><strong>Communications:</strong> support tickets, messages and contact form submissions.</li>
            </ul>
          ),
        },
        {
          heading: 'How we use it',
          body: (
            <ul>
              <li>To authenticate you and operate your account.</li>
              <li>To verify workers before they can accept jobs.</li>
              <li>To match bookings with suitable workers and run the job.</li>
              <li>To process payments, worker earnings and payouts.</li>
              <li>To investigate disputes and damage claims.</li>
              <li>To keep an audit trail of administrative actions for security and accountability.</li>
            </ul>
          ),
        },
        {
          heading: 'Where your data is stored',
          body: (
            <>
              <p>Sign-in is handled by Firebase Authentication. Files — photographs, identity documents and certificates — are stored in private Supabase Storage. Account, booking and payment records are stored in a Supabase PostgreSQL database.</p>
              <p>Identity and qualification documents are never publicly accessible. Staff access them only through time-limited links issued after a permission check, and each access is recorded.</p>
            </>
          ),
        },
        {
          heading: 'Who can see your information',
          body: (
            <ul>
              <li>A customer and the assigned worker see the details of their shared booking needed to complete it.</li>
              <li>Customers see a worker’s name, trade, rating and verification checks — never their identity documents, phone number or home address.</li>
              <li>Authorised staff see information according to their role and permissions.</li>
              <li>Service providers who process data on our behalf, such as authentication, storage, payment and messaging providers.</li>
            </ul>
          ),
        },
        {
          heading: 'Retention',
          body: <p>Records of completed bookings, payments, verification decisions and the audit trail are retained for the periods required by applicable law and for resolving disputes. Specific retention periods will be set out in the reviewed version of this policy.</p>,
        },
        {
          heading: 'Your rights',
          body: <p>You may request access to, correction of, or deletion of your personal data, subject to legal retention obligations. Contact the grievance officer or support using the address below.</p>,
        },
        {
          heading: 'Changes to this policy',
          body: <p>Material changes will be notified in the apps before they take effect.</p>,
        },
      ]}
    />
  );
}
