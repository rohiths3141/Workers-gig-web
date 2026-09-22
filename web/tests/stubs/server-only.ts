/**
 * Stub for the `server-only` package under test.
 *
 * `server-only` exists to make a build fail if server code is imported into a
 * client bundle. Vitest is neither, so importing the real module throws and no
 * server module can be unit tested at all. Aliasing it here lets the pure,
 * security-critical helpers be tested directly while the real guard stays in
 * place for every actual build.
 */
export {};
