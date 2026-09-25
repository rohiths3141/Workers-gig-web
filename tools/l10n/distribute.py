"""Share translations between the two apps.

  python tools/l10n/distribute.py source   # refresh shared/source.json
  python tools/l10n/distribute.py apply    # write <app>/<lang>/translations.json

Both apps say many of the same things ("Try again", "Save"), so each English
sentence is translated once. shared/source.json lists every distinct English
message across both apps under one id (the first app key that uses it).
shared/<lang>/*.json holds the translations under those ids. `apply` hands
each translation to every key, in either app, whose English is that sentence,
and then merge.py checks and builds the ARB files as usual.
"""
import io
import json
import os
import sys
from collections import OrderedDict

HERE = os.path.dirname(os.path.abspath(__file__))
SHARED = os.path.join(HERE, 'shared')
APPS = ('customer', 'worker')


def load_dir(d):
    merged = OrderedDict()
    for name in sorted(os.listdir(d)):
        if name.endswith('.json'):
            with io.open(os.path.join(d, name), encoding='utf-8') as f:
                merged.update(json.load(f, object_pairs_hook=OrderedDict))
    return merged


def english(app):
    data = load_dir(os.path.join(HERE, app, 'en'))
    return OrderedDict((k, v) for k, v in data.items() if not k.startswith('@'))


def dump(path, data):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with io.open(path, 'w', encoding='utf-8', newline='\n') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
        f.write('\n')


def source():
    ids = OrderedDict()  # English text -> id
    for app in APPS:
        for key, text in english(app).items():
            if text in ids:
                continue
            key_id = key if key not in ids.values() else f'{app}_{key}'
            ids[text] = key_id
    dump(os.path.join(SHARED, 'source.json'),
         OrderedDict((i, t) for t, i in ids.items()))
    print(f'{len(ids)} distinct messages')


def apply():
    with io.open(os.path.join(SHARED, 'source.json'), encoding='utf-8') as f:
        src = json.load(f)
    by_text = {text: i for i, text in src.items()}
    for lang in sorted(os.listdir(SHARED)):
        d = os.path.join(SHARED, lang)
        if not os.path.isdir(d):
            continue
        tr = load_dir(d)
        unknown = [i for i in tr if i not in src]
        if unknown:
            sys.exit(f'{lang}: unknown ids {unknown[:8]}')
        for app in APPS:
            out = OrderedDict()
            for key, text in english(app).items():
                i = by_text.get(text)
                if i is not None and i in tr:
                    out[key] = tr[i]
            dump(os.path.join(HERE, app, lang, 'translations.json'), out)
        print(f'{lang}: {len(tr)}/{len(src)}')


if __name__ == '__main__':
    {'source': source, 'apply': apply}[sys.argv[1]]()
