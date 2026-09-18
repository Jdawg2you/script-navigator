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

echo
if [ "$FAIL" -eq 0 ]; then
  echo "PASS  $N script block(s) parse; every branch and section entry resolves."
  echo "      Still load the preview and look at it before pushing."
else
  echo "FAILED — do not push."
fi
exit $FAIL
