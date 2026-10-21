#!/bin/sh

# SPDX-FileCopyrightText: 2026 RickyWanga
#
# SPDX-License-Identifier: AGPL-3.0-only

# Run with: sh tests/converter-exit-status.sh [shell]
set -eu

repo=$(CDPATH='' cd "$(dirname "$0")/.." && pwd)
shell=${1:-sh}
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
trap 'exit 1' HUP INT TERM

mkdir -p "$work/input/nested dir"
touch "$work/input/nested dir/document with spaces.tex" "$work/input/ignored.txt"
export CONVERTER_LOG="$work/converter.log"
cat > "$work/converter" <<'EOF'
#!/bin/sh
set -u
if [ "$#" -ne 2 ] || [ "$1" != "--check-input" ] || [ ! -f "$2" ]; then
  exit 99
fi
printf '%s\n' "$PWD/$2" >> "$CONVERTER_LOG"
exit "$CONVERTER_STATUS"
EOF
chmod +x "$work/converter"
cd "$work/input"
failed=0

for mode in direct recursive; do
  if [ "$mode" = direct ]; then
    set -- "$repo/convert.sh" "nested dir/document with spaces.tex"
  else
    set -- "$repo/rec.sh" "$repo/convert.sh"
  fi

  : > "$CONVERTER_LOG"
  status=0
  CONVERTER_STATUS=37 "$shell" "$@" '\.tex$' "$work/converter --check-input" > "$work/stdout" 2> "$work/stderr" || status=$?
  if [ "$mode" = direct ] && [ "$status" -ne 37 ]; then
    echo "FAIL: direct failure returned $status, expected 37" >&2
    failed=1
  fi
  if [ "$mode" = recursive ] && [ "$status" -eq 0 ]; then
    echo "FAIL: recursive failure returned 0, expected nonzero" >&2
    failed=1
  fi
  if [ "$(cat "$CONVERTER_LOG")" != "$work/input/nested dir/document with spaces.tex" ]; then
    echo "FAIL: $mode failure did not receive the basename in its directory" >&2
    failed=1
  fi
  if ! grep -F 'converter --check-input ' "$work/stderr" > /dev/null || ! grep -F '+ set +x' "$work/stderr" > /dev/null; then
    echo "FAIL: $mode failure lost command tracing or its reset" >&2
    failed=1
  fi

  : > "$CONVERTER_LOG"
  status=0
  CONVERTER_STATUS=0 "$shell" "$@" '\.tex$' "$work/converter --check-input" > "$work/stdout" 2> "$work/stderr" || status=$?
  if [ "$status" -ne 0 ]; then
    echo "FAIL: $mode success returned $status, expected 0" >&2
    failed=1
  fi
  if [ "$(cat "$CONVERTER_LOG")" != "$work/input/nested dir/document with spaces.tex" ]; then
    echo "FAIL: $mode success did not convert exactly the matching file" >&2
    failed=1
  fi
  if ! grep -F 'converter --check-input ' "$work/stderr" > /dev/null || ! grep -F '+ set +x' "$work/stderr" > /dev/null; then
    echo "FAIL: $mode success lost command tracing or its reset" >&2
    failed=1
  fi

  : > "$CONVERTER_LOG"
  status=0
  CONVERTER_STATUS=37 "$shell" "$@" '\.md$' "$work/converter --check-input" > "$work/stdout" 2> "$work/stderr" || status=$?
  if [ "$status" -ne 0 ]; then
    echo "FAIL: $mode skip returned $status, expected 0" >&2
    failed=1
  fi
  if [ -s "$CONVERTER_LOG" ]; then
    echo "FAIL: $mode skip ran the converter" >&2
    failed=1
  fi

  : > "$CONVERTER_LOG"
  status=0
  CONVERTER_STATUS=0 "$shell" "$@" '[' "$work/converter --check-input" > "$work/stdout" 2> "$work/stderr" || status=$?
  if [ "$status" -eq 0 ]; then
    echo "FAIL: $mode invalid regex returned 0, expected nonzero" >&2
    failed=1
  fi
  if [ -s "$CONVERTER_LOG" ]; then
    echo "FAIL: $mode invalid regex ran the converter" >&2
    failed=1
  fi
  if ! grep -F 'grep returned an error' "$work/stderr" > /dev/null; then
    echo "FAIL: $mode invalid regex lost its error message" >&2
    failed=1
  fi
done

if [ "$failed" -eq 0 ]; then
  echo "PASS: converter and recursive failure/success/skip/invalid regex ($shell)"
fi
exit "$failed"
