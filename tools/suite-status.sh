#!/bin/bash
# Is what I'm looking at what everyone else is looking at?
#
#   tools/suite-status.sh
#
# For each site in the Optimum suite this answers two questions that are easy to get wrong when
# work happens across several sessions and clones:
#   1. Does this Mac have work that never reached GitHub?  (uncommitted, or committed but unpushed)
#   2. Does the page GitHub Pages is actually serving match the file on this Mac?
#
# The second one is the important one. A repo can be clean and pushed and the live site can still
# be a few minutes behind, or — worse — you can be editing a clone that is not the one deploying.

set -uo pipefail
ISSUES=0

row() { # name  repo-path  live-url
  local name="$1" dir="${2/#\~/$HOME}" url="$3" state="" live=""

  if [ ! -d "$dir/.git" ]; then
    printf "  %-10s %-34s %s\n" "$name" "no local clone" "(nothing here can be out of sync)"
    return
  fi

  cd "$dir" || return
  git fetch origin -q 2>/dev/null
  local br dirty ahead behind
  br=$(git branch --show-current)
  dirty=$(git status --porcelain | wc -l | tr -d ' ')
  ahead=$(git rev-list --count "origin/$br..HEAD" 2>/dev/null || echo 0)
  behind=$(git rev-list --count "HEAD..origin/$br" 2>/dev/null || echo 0)

  [ "$dirty"  != "0" ] && { state="$state ${dirty} uncommitted"; ISSUES=$((ISSUES+1)); }
  [ "$ahead"  != "0" ] && { state="$state ${ahead} unpushed";    ISSUES=$((ISSUES+1)); }
  [ "$behind" != "0" ] && { state="$state ${behind} behind";     ISSUES=$((ISSUES+1)); }
  [ -z "$state" ] && state="in step with GitHub"

  # Compare the deployed page to the local file, byte for byte.
  local lh rh
  lh=$(shasum -a 256 index.html 2>/dev/null | cut -c1-12)
  rh=$(curl -s --max-time 20 "$url" 2>/dev/null | shasum -a 256 | cut -c1-12)
  if [ -z "$rh" ] || [ "$rh" = "$(printf '' | shasum -a 256 | cut -c1-12)" ]; then
    live="could not reach the live site"; ISSUES=$((ISSUES+1))
  elif [ "$lh" = "$rh" ]; then
    live="live matches this clone"
  else
    live="LIVE DIFFERS from this clone"; ISSUES=$((ISSUES+1))
  fi

  printf "  %-10s %-34s %s\n" "$name" "$state" "$live"
}

echo "Optimum suite — what is actually deployed"
echo
row "wizard"  "~/Documents/product-wizard" "https://wizard.ffloptimum.com/"
row "script"  "~/script-navigator"         "https://script.ffloptimum.com/"
row "tools"   "~/Documents/optimum-tools"  "https://tools.ffloptimum.com/"
row "portal"  "~/Documents/optimum-portal" "https://portal.ffloptimum.com/"
echo

if [ "$ISSUES" -eq 0 ]; then
  echo "Everything on this Mac is committed, pushed, and live. What you see is what agents see."
else
  echo "$ISSUES thing(s) to look at above."
  echo "A fresh push takes a minute or two to reach the live site — if you just pushed, re-run this."
fi
