#!/bin/bash
# Pre-push checks for index.html. Run from the repo root: tools/check.sh
#
# Exists because this file is one 460KB script: a stray quote inside a string throws
# SyntaxError, which kills the ENTIRE block, and the live site serves a dead shell. Grepping the
# deployed HTML still passes, because the text is there — the file just doesn't parse.
#
# The wizard checks the other direction (its medications, condition names and follow-up questions
# against this file). This is the check for this side.
#
# Uses JavaScriptCore, which ships with macOS. No node, no install.

set -uo pipefail
cd "$(dirname "$0")/.." || exit 2

JSC="/System/Library/Frameworks/JavaScriptCore.framework/Versions/A/Helpers/jsc"
FILE="index.html"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
FAIL=0

[ -x "$JSC" ] || { echo "FAIL  JavaScriptCore not found at $JSC"; exit 2; }

python3 - "$FILE" "$TMP" <<'PY'
import re, sys, io, os
src = io.open(sys.argv[1], encoding='utf-8').read()
for i, b in enumerate(re.findall(r'<script>(.*?)</script>', src, re.S)):
    io.open(os.path.join(sys.argv[2], 'block%d.js' % i), 'w', encoding='utf-8').write(b)
PY
N=$(ls "$TMP"/block*.js 2>/dev/null | wc -l | tr -d ' ')

# ---- 1. does every block parse? ------------------------------------------------------
for f in "$TMP"/block*.js; do
  OUT=$("$JSC" -e "var src=readFile('$f'); try{ new Function(src); print('OK'); }catch(e){ print('SYNTAX ERROR: '+e.message); }" 2>&1)
  if [ "$OUT" = "OK" ]; then echo "ok    $(basename "$f") parses"
  else echo "FAIL  $(basename "$f"): $OUT"; FAIL=1; fi
done

# ---- 2. does every branch point at a card that exists? -------------------------------
# A typo'd `to:` is a dead button: the click handler returns silently and the card never changes.
if [ "$FAIL" -eq 0 ]; then
  OUT=$("$JSC" -e "
    globalThis.document={getElementById:function(){return null},querySelector:function(){return null},
      querySelectorAll:function(){return []},addEventListener:function(){},createElement:function(){return {}},readyState:'complete'};
    globalThis.window=globalThis;
    globalThis.location={search:'',hash:'',href:'https://script.ffloptimum.com/',origin:'https://script.ffloptimum.com',protocol:'https:',hostname:'script.ffloptimum.com'};
    globalThis.navigator={userAgent:'jsc',clipboard:null};
    globalThis.localStorage={getItem:function(){return null},setItem:function(){},removeItem:function(){}};
    globalThis.sessionStorage=globalThis.localStorage;
    globalThis.setTimeout=function(){return 0};globalThis.clearTimeout=function(){};
    globalThis.setInterval=function(){return 0};globalThis.clearInterval=function(){};
    globalThis.matchMedia=function(){return {matches:false,addEventListener:function(){}}};
    var src=readFile('$TMP/block0.js');
    try{
      var lib=(new Function(src.slice(0, src.indexOf('var S,STAGES')) + ';return {LIB:LIB};'))();
      var bad=[], warn=[];
      Object.keys(lib.LIB).forEach(function(k){
        var L=lib.LIB[k];
        if(!L.N[L.first]) bad.push(k+' first card '+L.first+' does not exist');
        Object.keys(L.N).forEach(function(id){
          (L.N[id].b||[]).forEach(function(b){ if(!L.N[b.to]) bad.push(k+' '+id+' -> '+b.to); });
          /* A stray comma in a card's line list leaves an undefined hole. [a,,b] is valid
             JavaScript, so it parses clean and the navigator skips over it - but the readable
             and printed scripts walk the same array and throw on the hole. One of these broke
             the veteran print-out for four days without anything surfacing it. */
          /* NB: forEach SKIPS holes, which is exactly why this is so easy to miss. Index it. */
          /* The branch renderer dedupes by target, so two buttons pointing at the same card
             means only the first one is ever drawn and the rest vanish with no error. Four
             branches on the mortgage decision-maker card silently collapsed to two this way. */
          /* Conditional branches to one target are fine and deliberate - the condition picks
             which of them is on screen. Only UNCONDITIONAL duplicates lose a button. */
          var seenTo={}, dupTo=null;
          (L.N[id].b||[]).forEach(function(b){
            if(!b.to || b.when || b.allOf) return;
            if(seenTo[b.to]&&!dupTo) dupTo=b.to; seenTo[b.to]=1; });
          if(dupTo) bad.push(k+' '+id+' has two branches pointing at '+dupTo+' - only the first is drawn');
          var ll=L.N[id].l||[];
          for(var li=0; li<ll.length; li++){
            if(!ll[li] || typeof ll[li]!=='object') bad.push(k+' '+id+' line '+li+' is an empty slot - stray comma');
          }
          /* A missing card number only shows as "?" on the badge — worth knowing, not worth
             blocking a commit for, and the number to use is an editorial choice. */
          if(!L.ID[id]) warn.push(k+' '+id+' (card number badge shows "?")');
        });
        Object.keys(L.ENTRY).forEach(function(s){ if(!L.N[L.ENTRY[s]]) bad.push(k+' section '+s+' entry missing'); });
      });
      if(bad.length){ print('DEAD LINKS:'); bad.slice(0,15).forEach(function(x){print('  '+x)}); }
      else {
        print('LINKS OK '+Object.keys(lib.LIB).map(function(k){return k+'='+Object.keys(lib.LIB[k].N).length;}).join(' '));
        if(warn.length){ print('WARN  cards with no card number:'); warn.slice(0,10).forEach(function(x){print('        '+x)}); }
      }
    }catch(e){ print('RUNTIME ERROR: '+e.message); }
  " 2>&1)
  case "$OUT" in
    "LINKS OK"*) echo "$OUT" | sed '1s/^/ok    /' ;;
    *)           echo "FAIL  $OUT"; FAIL=1 ;;
  esac
fi

# ---- 3. does restart() reset to THIS script's first card? ----------------------------
# It used to set cur="start" unconditionally. That card only exists in the veteran script, so on
# IUL and Mortgage it set cur to a nonexistent node and render() threw.
if [ "$FAIL" -eq 0 ]; then
  if sed -n '/^function restart(){/,/^}/p' "$FILE" | grep -q 'LIB\[curScript\]'; then
    echo "ok    restart() resets to the current script's own first card"
  else
    echo "FAIL  restart() resets to a hardcoded card id — use LIB[curScript].first, or IUL and Mortgage break"
    FAIL=1
  fi
fi

# ---- 4. does any ___(label) map to two different profile fields? --------------------
# BLANKMAP is one flat object shared by all four scripts, so a label added twice silently keeps
# only the last one. That is how the burial figure on the veteran script started writing into the
# client's phone number: a later phone block re-mapped "their number". Nothing surfaced it.
if [ "$FAIL" -eq 0 ]; then
  OUT=$(python3 - "$FILE" <<'PY'
import re,sys,collections
h=open(sys.argv[1]).read()
i=h.index('var BLANKMAP={'); j=h.index('"agent email":"a_email",};', i)
pairs=re.findall(r'"((?:[^"\\]|\\.)*)"\s*:\s*"((?:[^"\\]|\\.)*)"', h[i:j])
seen=collections.defaultdict(list)
for k,v in pairs: seen[k].append(v)
bad=[(k,vs) for k,vs in seen.items() if len(set(vs))>1]
if bad:
    for k,vs in bad: print('%s -> %s (uses %s)' % (k, " then ".join(vs), vs[-1]))
else:
    print('BLANKMAP OK')
PY
)
  case "$OUT" in
    "BLANKMAP OK") echo "ok    no ___(label) maps to two different profile fields" ;;
    *) echo "FAIL  a ___(label) maps to two different fields — only the last one takes effect:"
       echo "$OUT" | sed 's/^/        /'; FAIL=1 ;;
  esac
fi

# ---- 5. does every linked objections sheet exist in this repo? -----------------------
# The sheets live here now, at <script>/objections/index.html, so the link and the page ship in
# the same commit and cannot get out of step. The local file is the hard gate. The live URL is
# checked too, but only as a warning: a page added in this commit is not on Pages yet.
if [ "$FAIL" -eq 0 ]; then
  SLUGS=$(node -e '
    const h=require("fs").readFileSync(process.argv[1],"utf8");
    const m=h.match(/var OBJ_SHEET=\{([^}]*)\}/);
    if(!m){ console.error("OBJ_SHEET not found"); process.exit(3); }
    [...m[1].matchAll(/:"([a-z-]+)"/g)].forEach(x=>console.log(x[1]));
  ' "$FILE") || { echo "FAIL  could not read OBJ_SHEET from $FILE"; FAIL=1; }
  MISSING=""
  for s in $SLUGS; do
    [ -f "$(dirname "$FILE")/$s/objections/index.html" ] || MISSING="$MISSING $s"
  done
  if [ -n "$MISSING" ]; then
    echo "FAIL  the navigator links to an objections sheet that is not in this repo:$MISSING"
    FAIL=1
  else
    echo "ok    every linked objections sheet is in the repo ($(echo $SLUGS | wc -w | tr -d ' ') checked)"
    if curl -s -m 4 -o /dev/null https://script.ffloptimum.com/ 2>/dev/null; then
      for s in $SLUGS; do
        code=$(curl -s -m 6 -o /dev/null -w '%{http_code}' "https://script.ffloptimum.com/$s/objections/")
        [ "$code" = "200" ] || echo "      note: /$s/objections/ is not live yet ($code) — expected until this commit deploys"
      done
    fi
  fi
fi

echo
if [ "$FAIL" -eq 0 ]; then
  echo "PASS  $N script block(s) parse; every branch and section entry resolves."
  echo "      Still load the preview and look at it before pushing."
else
  echo "FAILED — do not push."
fi
exit $FAIL
