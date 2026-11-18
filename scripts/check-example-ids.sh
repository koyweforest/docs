#!/usr/bin/env bash
# Checks that identifiers used in documentation examples are placeholders.
#
# Flags, in .md/.mdx/.json/.yaml/.yml files:
#   - prefixed UUIDs (e.g. mrc_<uuid>) and bare UUIDs
#   - 24-hex ObjectIds
#   - JWTs
# unless the hex part is a placeholder: all zeros except up to the last
# 4 hex digits (e.g. 00000000-0000-0000-0000-000000000001), or the RFC 4122
# example 123e4567-e89b-12d3-a456-426614174000.
#
# Lines matching any extended regex in scripts/example-ids-allowlist.txt
# are skipped (use it for third-party URLs such as video embeds).
#
# Usage: scripts/check-example-ids.sh [path ...]   (default: repo root)

set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
allowlist="$root/scripts/example-ids-allowlist.txt"
if [ "$#" -eq 0 ]; then set -- "$root"; fi

uuid='[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}'
pattern="\\b([a-z0-9]{2,8}_)?${uuid}\\b|\\b[0-9a-fA-F]{24}\\b|eyJ[A-Za-z0-9_-]{10,}\\.eyJ[A-Za-z0-9_-]{10,}"

is_placeholder() {
  local v="${1,,}"
  v="${v#*_}"            # drop prefix, if any
  case "$v" in
    123e4567-e89b-12d3-a456-426614174000) return 0 ;;
    eyj*) return 1 ;;
  esac
  v="${v//-/}"
  [[ "$v" =~ ^0+[0-9a-f]{0,4}$ ]] && [ "${#v}" -ge 24 ]
}

allow_patterns=()
if [ -f "$allowlist" ]; then
  while IFS= read -r l; do
    [[ -z "$l" || "$l" == \#* ]] && continue
    allow_patterns+=("$l")
  done < "$allowlist"
fi

found=0
while IFS= read -r hit; do
  file="${hit%%:*}"; rest="${hit#*:}"; lineno="${rest%%:*}"; line="${rest#*:}"
  skip=0
  for p in "${allow_patterns[@]+"${allow_patterns[@]}"}"; do
    if grep -qE -- "$p" <<<"$line"; then skip=1; break; fi
  done
  [ "$skip" -eq 1 ] && continue
  while IFS= read -r m; do
    [ -z "$m" ] && continue
    if ! is_placeholder "$m"; then
      echo "${file#"$root"/}:$lineno: non-placeholder example id: ${m:0:60}"
      found=1
    fi
  done < <(grep -oE -- "$pattern" <<<"$line" || true)
done < <(grep -rnIE --exclude-dir=.git --exclude-dir=node_modules \
           --include='*.md' --include='*.mdx' --include='*.json' \
           --include='*.yaml' --include='*.yml' -- "$pattern" "$@" || true)

if [ "$found" -ne 0 ]; then
  echo
  echo "Examples must use placeholder values. See CONTRIBUTING.md."
  exit 1
fi
echo "check-example-ids: OK"
