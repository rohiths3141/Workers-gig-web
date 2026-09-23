#!/usr/bin/env node
// ===========================================================================
// publish-apks — put the latest release APKs on the /download page
// ===========================================================================
// Copies each app's release APK and launcher icon into `public/`, and records
// what the page shows about the file — version, size, minimum Android version
// and SHA-256 — in `src/lib/data/app-releases.json`. The page reads only that
// JSON, so what it says about a file is always what was measured from it.
//
//   cd customer-app && flutter build apk --release --dart-define-from-file=dart-defines.env
//   cd worker-app   && flutter build apk --release --dart-define-from-file=define.json
//   cd web          && node scripts/publish-apks.mjs
//
// Build first. Without the define file the APK starts and shows "This build is
// missing its configuration" — this script cannot tell, so it is on the build.
//
// The minimum Android version is read with `aapt2` from the Android SDK. When
// the SDK cannot be found the value already in the JSON is kept, and the
// script says so.
// ===========================================================================

import { createHash } from 'node:crypto';
import { execFileSync } from 'node:child_process';
import { copyFileSync, existsSync, mkdirSync, readFileSync, readdirSync, statSync, writeFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import path from 'node:path';

const HERE = path.dirname(fileURLToPath(import.meta.url));
const WEB = path.join(HERE, '..');
const REPO = path.join(WEB, '..');
const MANIFEST = path.join(WEB, 'src', 'lib', 'data', 'app-releases.json');

const APPS = [
  {
    key: 'customer',
    appDir: 'customer-app',
    apkName: 'wervexa-customer.apk',
    iconName: 'wervexa-customer.png',
  },
  {
    key: 'worker',
    appDir: 'worker-app',
    apkName: 'wervexa-captain.apk',
    iconName: 'wervexa-captain.png',
  },
];

/** Android API level to the marketing version people see in Settings. */
const ANDROID_VERSIONS = {
  21: '5.0', 22: '5.1', 23: '6.0', 24: '7.0', 25: '7.1', 26: '8.0', 27: '8.1',
  28: '9', 29: '10', 30: '11', 31: '12', 32: '12L', 33: '13', 34: '14', 35: '15', 36: '16',
};

function sha256(file) {
  return createHash('sha256').update(readFileSync(file)).digest('hex');
}

/** The newest `aapt2` in the Android SDK, or null. */
function findAapt2() {
  const sdk =
    process.env.ANDROID_HOME ||
    process.env.ANDROID_SDK_ROOT ||
    (process.env.LOCALAPPDATA && path.join(process.env.LOCALAPPDATA, 'Android', 'Sdk'));
  if (!sdk) return null;

  const tools = path.join(sdk, 'build-tools');
  if (!existsSync(tools)) return null;

  const versions = readdirSync(tools).sort((a, b) =>
    b.localeCompare(a, undefined, { numeric: true }),
  );
  for (const version of versions) {
    for (const exe of ['aapt2.exe', 'aapt2']) {
      const candidate = path.join(tools, version, exe);
      if (existsSync(candidate)) return candidate;
    }
  }
  return null;
}

function readMinSdk(aapt2, apk) {
  if (!aapt2) return null;
  const badging = execFileSync(aapt2, ['dump', 'badging', apk], { encoding: 'utf8' });
  const match = badging.match(/^minSdkVersion:'(\d+)'/m);
  return match ? Number(match[1]) : null;
}

const previous = existsSync(MANIFEST) ? JSON.parse(readFileSync(MANIFEST, 'utf8')) : {};
const aapt2 = findAapt2();
if (!aapt2) {
  console.warn('aapt2 not found (set ANDROID_HOME) — keeping the recorded minimum Android versions.');
}

mkdirSync(path.join(WEB, 'public', 'downloads'), { recursive: true });
mkdirSync(path.join(WEB, 'public', 'images', 'apps'), { recursive: true });

const manifest = {};

for (const app of APPS) {
  const outputs = path.join(REPO, app.appDir, 'build', 'app', 'outputs', 'apk', 'release');
  const apk = path.join(outputs, 'app-release.apk');
  if (!existsSync(apk)) {
    throw new Error(`${app.appDir}: no release APK at ${apk} — build it first.`);
  }

  const metadata = JSON.parse(readFileSync(path.join(outputs, 'output-metadata.json'), 'utf8'));
  const element = metadata.elements?.[0];
  if (!element) throw new Error(`${app.appDir}: output-metadata.json lists no APK.`);

  const minSdk = readMinSdk(aapt2, apk) ?? previous[app.key]?.minSdk;
  if (!minSdk) throw new Error(`${app.appDir}: minimum SDK unknown — install the Android SDK build-tools.`);

  const icon = path.join(REPO, app.appDir, 'android', 'app', 'src', 'main', 'res', 'mipmap-xxxhdpi', 'ic_launcher.png');

  copyFileSync(apk, path.join(WEB, 'public', 'downloads', app.apkName));
  copyFileSync(icon, path.join(WEB, 'public', 'images', 'apps', app.iconName));

  manifest[app.key] = {
    applicationId: metadata.applicationId,
    versionName: element.versionName,
    versionCode: element.versionCode,
    minSdk,
    minAndroid: ANDROID_VERSIONS[minSdk] ?? `API ${minSdk}`,
    sizeBytes: statSync(apk).size,
    sha256: sha256(apk),
    builtAt: statSync(apk).mtime.toISOString(),
    href: `/downloads/${app.apkName}`,
    icon: `/images/apps/${app.iconName}`,
  };

  // Decimal megabytes, the unit Android's own file manager reports.
  const mb = (manifest[app.key].sizeBytes / 1_000_000).toFixed(1);
  console.log(`${app.key.padEnd(8)} ${element.versionName} (${element.versionCode})  ${mb} MB  -> public${manifest[app.key].href}`);
}

writeFileSync(MANIFEST, `${JSON.stringify(manifest, null, 2)}\n`);
console.log(`wrote ${path.relative(WEB, MANIFEST)}`);
