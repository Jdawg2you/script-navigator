#!/bin/bash
# Copy MEDS and MED_FOR from the navigator into the Product Wizard and POP Pro.
#
# The navigator is the source of truth (SOURCES.md). Both other tools carry a verbatim copy,
# and both have a check that fails when the copies drift - so edit the navigator, run this,
# then run their checks. Doing it by hand is how the three copies diverge.
set -uo pipefail
cd "$(dirname "$0")/.." || exit 2
NAV="${1:-index.html}"
WIZ="${2:-$HOME/Documents/product-wizard/index.html}"
POP="${3:-$HOME/Documents/poppro/tool/index.html}"

python3 - "$NAV" "$WIZ" "$POP" <<'PY'
import io, re, sys
def span(src, pat, o, c):
    m = re.search(pat, src)
    if not m: return None, None, None
    i = src.index(o, m.start()); d = 0
    for k in range(i, len(src)):
        if src[k] == o: d += 1
        elif src[k] == c:
            d -= 1
            if d == 0: return src[i:k+1], i, k+1
    return None, None, None

nav = io.open(sys.argv[1], encoding='utf-8').read()
blocks = {}
for name, o, c in (('MEDS','[',']'), ('MED_FOR','{','}')):
    b, _, _ = span(nav, r'(?:var|const|let)\s+%s\s*=' % name, o, c)
    if not b: sys.exit('could not read %s from the navigator' % name)
    blocks[name] = (b, o, c)

for path in sys.argv[2:]:
    try: tgt = io.open(path, encoding='utf-8').read()
    except Exception as e: print('  skip %s (%s)' % (path, e)); continue
    before = tgt; changed = []
    for name, (b, o, c) in blocks.items():
        cur, i, j = span(tgt, r'(?:var|const|let)\s+%s\s*=' % name, o, c)
        if cur is None: print('  %s: no %s block' % (path, name)); continue
        if re.sub(r'\s+', '', cur) == re.sub(r'\s+', '', b): continue
        tgt = tgt[:i] + b + tgt[j:]; changed.append(name)
    if changed:
        io.open(path, 'w', encoding='utf-8').write(tgt)
        print('  ported %s -> %s' % (', '.join(changed), path))
    else:
        print('  already in step: %s' % path)
PY
