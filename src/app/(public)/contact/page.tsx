import type { Metadata } from 'next';
import { Mail, MapPin, Phone } from 'lucide-react';

import { ContactForm } from '@/app/(public)/contact/contact-form';
import { AppCta } from '@/components/public/app-cta';
import { SectionHeading, TextLink } from '@/components/public/marketing';
import { publicEnv } from '@/lib/config/env';
import { absolutePublicUrl, publicRoutes } from '@/lib/config/routes';

export const metadata: Metadata = {
  title: 'Contact',
  description: 'Contact the support team about a booking, a payment, verification or your account.',
  alternates: { canonical: absolutePublicUrl(publicRoutes.contact) },
};

/** Contact details come from configuration; anything not configured is omitted. */
export default function ContactPage() {
  const { brand } = publicEnv();

  return (
    <>
      <section className="border-b border-ink-200 bg-ink-50">
        <div className="container-page py-14 md:py-20">
          <SectionHeading
            as="h1"
            eyebrow="Contact"
            title="Get in touch"
            description="For a problem with a specific booking, raising a ticket from the app is fastest — it is linked to the job automatically."
          />
        </div>
      </section>

      <section className="section">
        <div className="container-page grid gap-12 lg:grid-cols-12">
          <div className="lg:col-span-7">
            <ContactForm />
          </div>

          <aside className="space-y-4 lg:col-span-5">
            <div className="rounded-2xl border border-ink-200 bg-white p-6">
              <h2 className="text-base font-semibold text-ink-900">Support</h2>
              <ul className="mt-4 space-y-3 text-sm">
                <li className="flex gap-3">
                  <Mail aria-hidden className="mt-0.5 size-4 text-brand-700" />
                  <a href={`mailto:${brand.supportEmail}`} className="text-ink-700 hover:text-brand-700">
                    {brand.supportEmail}
                  </a>
                </li>
                {brand.supportPhone && (
                  <li className="flex gap-3">
                    <Phone aria-hidden className="mt-0.5 size-4 text-brand-700" />
                    <a href={`tel:${brand.supportPhone.replace(/\s/g, '')}`} className="text-ink-700 hover:text-brand-700">
                      {brand.supportPhone}
                    </a>
                  </li>
                )}
                {brand.businessAddress && (
                  <li className="flex gap-3">
                    <MapPin aria-hidden className="mt-0.5 size-4 text-brand-700" />
                    <span className="text-ink-700">{brand.businessAddress}</span>
                  </li>
                )}
              </ul>
              {brand.grievanceEmail && (
                <p className="mt-4 border-t border-ink-200 pt-4 text-xs text-ink-500">
                  Grievance officer:{' '}
                  <a href={`mailto:${brand.grievanceEmail}`} className="underline hover:text-brand-700">
                    {brand.grievanceEmail}
                  </a>
                </p>
              )}
            </div>

            <div className="rounded-2xl border border-ink-200 bg-white p-6">
              <h2 className="text-base font-semibold text-ink-900">Quick answers</h2>
              <p className="mt-2 text-sm text-ink-600">
                Many questions about bookings, payments, verification and claims are answered in the FAQ.
              </p>
              <div className="mt-3">
                <TextLink href={publicRoutes.faq}>Read the FAQ</TextLink>
              </div>
            </div>
          </aside>
        </div>
      </section>

      <section className="pb-16 md:pb-24">
        <div className="container-page">
          <AppCta audience="customer" title="Need help with a booking?" description="Open the booking in the customer app and raise a support ticket — it reaches the team with the job details attached." />
        </div>
      </section>
    </>
  );
}
