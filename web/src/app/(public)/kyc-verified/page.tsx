'use client';

import { useEffect, useState } from 'react';

/**
 * KYC Verified — static landing page shown after DigiLocker consent completes.
 *
 * The Supabase Edge Function `kyc-digilocker/return` redirects here once the
 * DigiLocker journey finishes. This page is purely informational — it tells the
 * worker to go back to the app.
 */
export default function KycVerifiedPage() {
  const [mounted, setMounted] = useState(false);
  useEffect(() => setMounted(true), []);

  return (
    <div className="flex min-h-[80vh] items-center justify-center px-6 py-16">
      <div
        className={`relative mx-auto max-w-md w-full rounded-3xl border border-brand-200/30 bg-gradient-to-br from-brand-950 via-ink-900 to-brand-900 p-10 text-center shadow-2xl transition-all duration-700 ${
          mounted ? 'opacity-100 translate-y-0 scale-100' : 'opacity-0 translate-y-8 scale-95'
        }`}
      >
        {/* Animated check icon */}
        <div
          className={`mx-auto mb-7 flex h-[88px] w-[88px] items-center justify-center transition-all duration-500 delay-300 ${
            mounted ? 'opacity-100 scale-100' : 'opacity-0 scale-50'
          }`}
        >
          <div className="relative">
            <svg viewBox="0 0 88 88" width="88" height="88">
              <circle
                cx="44" cy="44" r="40"
                fill="none"
                stroke="#14b8a6"
                strokeWidth="3"
                strokeDasharray="260"
                strokeDashoffset={mounted ? '0' : '260'}
                className="transition-[stroke-dashoffset] duration-600 delay-500 ease-out"
              />
              <polyline
                points="28 46 38 56 60 34"
                fill="none"
                stroke="#14b8a6"
                strokeWidth="4"
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeDasharray="50"
                strokeDashoffset={mounted ? '0' : '50'}
                className="transition-[stroke-dashoffset] duration-400 delay-1000 ease-out"
              />
            </svg>
            {/* Glow */}
            <div className="absolute -inset-3 rounded-full bg-brand-500/20 blur-xl animate-pulse" />
          </div>
        </div>

        {/* Heading */}
        <h1
          className={`mb-3 text-3xl font-bold tracking-tight bg-gradient-to-br from-brand-50 to-brand-300 bg-clip-text text-transparent transition-all duration-500 delay-400 ${
            mounted ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-3'
          }`}
        >
          You&rsquo;re All Set!
        </h1>

        {/* Subtitle */}
        <p
          className={`mb-8 text-base leading-relaxed text-brand-200/70 transition-all duration-500 delay-500 ${
            mounted ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-3'
          }`}
        >
          Your identity has been verified successfully.
          <br />
          You can now close this window.
        </p>

        {/* Divider */}
        <div
          className={`mx-auto mb-6 h-px w-full bg-gradient-to-r from-transparent via-brand-400/20 to-transparent transition-all duration-500 delay-600 ${
            mounted ? 'opacity-100' : 'opacity-0'
          }`}
        />

        {/* Hint */}
        <p
          className={`flex items-center justify-center gap-2 text-sm text-brand-300/50 transition-all duration-500 delay-700 ${
            mounted ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-3'
          }`}
        >
          <svg
            viewBox="0 0 24 24"
            width="16"
            height="16"
            fill="none"
            stroke="currentColor"
            strokeWidth="2"
            strokeLinecap="round"
            strokeLinejoin="round"
          >
            <path d="M15 18l-6-6 6-6" />
          </svg>
          Return to the <strong className="text-brand-200/70">&nbsp;Wervexa&nbsp;</strong> app to continue
        </p>

        {/* Brand */}
        <p
          className={`mt-10 text-xs uppercase tracking-widest text-brand-400/30 transition-all duration-500 delay-[800ms] ${
            mounted ? 'opacity-100' : 'opacity-0'
          }`}
        >
          Powered by Wervexa
        </p>
      </div>
    </div>
  );
}
