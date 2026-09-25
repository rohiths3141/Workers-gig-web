"""Exact-match string replacement for localizing Dart files.

Each replacement must match exactly once (or `count` times) or the whole file
is left untouched and the script stops, so a half-applied edit never lands.
"""
import io
import sys


def sub(path, pairs, add_import=None):
    s = io.open(path, encoding='utf-8').read()
    for pair in pairs:
        a, b = pair[0], pair[1]
        expected = pair[2] if len(pair) > 2 else 1
        n = s.count(a)
        if n != expected:
            sys.exit(f"MATCH COUNT {n} != {expected} in {path}:\n{a}")
        s = s.replace(a, b)
    if add_import and add_import not in s:
        lines = s.split('\n')
        idx = max(i for i, l in enumerate(lines) if l.startswith('import '))
        lines.insert(idx + 1, add_import)
        s = '\n'.join(lines)
    io.open(path, 'w', encoding='utf-8', newline='\n').write(s)
    print('ok', path)
