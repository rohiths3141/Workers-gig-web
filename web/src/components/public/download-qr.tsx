'use client';

import { useEffect, useState } from 'react';
import QRCode from 'qrcode';

/**
 * A QR code for this page, so a visitor on a computer can carry the download
 * over to their phone.
 *
 * The address is taken from the browser rather than from NEXT_PUBLIC_SITE_URL:
 * a QR code that encodes a misconfigured base URL is a dead end the visitor
 * cannot see until they have scanned it. Whatever address they are looking at
 * is, by definition, one that works.
 *
 * Drawn as a single SVG path from the module matrix — no markup injection, no
 * canvas, and nothing for the Content-Security-Policy to allow.
 */
export function DownloadQr({ path, className }: { path: string; className?: string }) {
  const [code, setCode] = useState<{ url: string; size: number; d: string } | null>(null);

  useEffect(() => {
    const url = new URL(path, window.location.origin).toString();
    const { modules } = QRCode.create(url, { errorCorrectionLevel: 'M' });

    let d = '';
    for (let row = 0; row < modules.size; row += 1) {
      for (let col = 0; col < modules.size; col += 1) {
        if (modules.get(row, col)) d += `M${col} ${row}h1v1h-1z`;
      }
    }
    setCode({ url, size: modules.size, d });
  }, [path]);

  // The quiet zone is part of the code: scanners need four modules of margin.
  const margin = 4;

  return (
    <div className={className}>
      {code ? (
        <svg
          role="img"
          aria-label={`QR code for ${code.url}`}
          viewBox={`${-margin} ${-margin} ${code.size + margin * 2} ${code.size + margin * 2}`}
          className="size-full"
          shapeRendering="crispEdges"
        >
          <rect x={-margin} y={-margin} width={code.size + margin * 2} height={code.size + margin * 2} fill="#ffffff" />
          <path d={code.d} fill="#0f172a" />
        </svg>
      ) : (
        <div aria-hidden className="size-full rounded bg-ink-100" />
      )}
    </div>
  );
}
