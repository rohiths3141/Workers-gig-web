# App translations

Both apps ship English plus Hindi, Bengali, Marathi, Telugu, Tamil, Gujarati,
Urdu, Kannada, Odia and Malayalam. Each language carries every string. The
l10n completeness test in each app (`test/core/l10n_completeness_test.dart`)
fails if any string is missing.

The ARB files in `<app>/lib/l10n/` are generated. Edit the sources here instead.

| Path | What it holds |
| --- | --- |
| `<app>/en/NN_*.json` | English strings, one file per area of the app, with `@` metadata |
| `shared/source.json` | Every distinct English sentence in either app, under one id (generated) |
| `shared/<lang>/*.json` | The translations, keyed by those ids |
| `<app>/<lang>/translations.json` | Per-app translations (generated) |

Both apps say many of the same things, so each sentence is translated once in
`shared/` and handed to every key that uses it.

## Adding or changing a string

1. Add the key to the right `<app>/en/NN_*.json` file.
2. Run `python3 tools/l10n/distribute.py source`. Any new sentence gets an id
   in `shared/source.json`.
3. Add that id to one file in each `shared/<lang>/`. Keep every `{placeholder}`
   and `plural` form exactly as in English.
4. Rebuild and check:

   ```sh
   python3 tools/l10n/distribute.py apply
   python3 tools/l10n/merge.py customer --strict
   python3 tools/l10n/merge.py worker --strict
   (cd customer-app && flutter gen-l10n)
   (cd worker-app && flutter gen-l10n)
   ```

   `merge.py --strict` names any missing key, extra key, or placeholder that
   doesn't match.

## Reviewing a language

The translations are machine translations. They have not been reviewed by
native speakers. A reviewer only needs `shared/source.json` (the English) and
`shared/<lang>/*.json` (their language). Fix the text in place and rebuild as
above.

Some text still shows in English whatever language is picked, because the
server writes it:

- server error messages
- notification titles and bodies
- service problem titles and short descriptions from the catalogue

Service names are translated in the app from their English names. See
`localizedServiceName`.
