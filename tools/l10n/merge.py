"""Merge per-screen string fragments into each app's ARB files, and check them.

  python tools/l10n/merge.py customer|worker [--strict]

en/ fragments are the template (with @-metadata). Every other language
directory is checked against it: no unknown keys, the same placeholders in
every message, and (with --strict) no missing keys.
"""
import io
import json
import os
import re
import sys
from collections import OrderedDict

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(HERE, '..', '..'))
APPS = {
    'customer': os.path.join(REPO, 'customer-app', 'lib', 'l10n'),
    'worker': os.path.join(REPO, 'worker-app', 'lib', 'l10n'),
}
PH = re.compile(r'\{\s*([A-Za-z_]\w*)\s*[,}]')


def placeholders(text):
    return set(PH.findall(text))


def load_dir(d):
    merged = OrderedDict()
    for name in sorted(os.listdir(d)):
        if not name.endswith('.json'):
            continue
        path = os.path.join(d, name)
        try:
            data = json.load(io.open(path, encoding='utf-8'),
                             object_pairs_hook=OrderedDict)
        except Exception as e:
            sys.exit(f'BAD JSON {path}: {e}')
        for k, v in data.items():
            if k in merged and merged[k] != v:
                sys.exit(f'DUPLICATE KEY {k} in {path} with a different value')
            merged[k] = v
    return merged


def write_arb(out_dir, lang, data):
    out = OrderedDict([('@@locale', lang)])
    out.update(data)
    path = os.path.join(out_dir, f'app_{lang}.arb')
    with io.open(path, 'w', encoding='utf-8', newline='\n') as f:
        json.dump(out, f, ensure_ascii=False, indent=2)
        f.write('\n')


def main():
    app = sys.argv[1]
    strict = '--strict' in sys.argv
    root = os.path.join(HERE, app)
    out_dir = APPS[app]
    os.makedirs(out_dir, exist_ok=True)

    en = load_dir(os.path.join(root, 'en'))
    messages = {k: v for k, v in en.items() if not k.startswith('@')}
    write_arb(out_dir, 'en', en)
    print(f'en: {len(messages)} messages')

    problems = 0
    for lang in sorted(os.listdir(root)):
        d = os.path.join(root, lang)
        if lang == 'en' or not os.path.isdir(d):
            continue
        tr = load_dir(d)
        for k, v in tr.items():
            if k not in messages:
                print(f'  {lang}: unknown key {k}')
                problems += 1
            elif placeholders(v) != placeholders(messages[k]):
                print(f'  {lang}: {k} placeholders {sorted(placeholders(v))}'
                      f' != {sorted(placeholders(messages[k]))}')
                problems += 1
            elif ('plural,' in messages[k]) != ('plural,' in v):
                print(f'  {lang}: {k} plural form differs from English')
                problems += 1
        missing = [k for k in messages if k not in tr]
        ordered = OrderedDict((k, tr[k]) for k in messages if k in tr)
        write_arb(out_dir, lang, ordered)
        print(f'{lang}: {len(ordered)}/{len(messages)}'
              + (f'  MISSING {len(missing)}: {missing[:8]}' if missing else ''))
        if strict and missing:
            problems += 1
    if problems:
        sys.exit(f'{problems} problem(s)')


main()
