#!/usr/bin/env bash
# Updates the learning memory (.tutor/memory.md) in one call, so the tutor
# never has to read or hand-edit the file.
#
# Usage: memory.sh <project-dir> <op> <args...> [<op> <args...>]...
#   seen          "<[Area] concept>" "<note>"       add/replace in Seen (no-op if already Learned)
#   learned       "<[Area] concept>" "<evidence>"   move to Learned (removes Seen + Misconceptions entries)
#   misconception "<[Area] concept>" "<mix-up>"     move to Misconceptions (removes Learned + Seen entries)
#   question      "<[Area] question>" correct|incorrect|skipped
#                                                    replace the same question or append; keeps the latest 20
#
# Entry format: "- <key>: <note> (YYYY-MM-DD)". Keys are matched literally, never as patterns.

set -u

PLUGIN_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MAX_QUESTIONS=20

usage() {
  sed -n '5,11p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//' >&2
  exit 1
}

[ $# -ge 3 ] || usage
PROJECT_DIR="$1"; shift
MEMORY="$PROJECT_DIR/.tutor/memory.md"
TODAY="$(date +%Y-%m-%d)"

if [ ! -f "$MEMORY" ]; then
  mkdir -p "$PROJECT_DIR/.tutor" || exit 1
  if [ -f "$PLUGIN_ROOT/tutor/memory.template.md" ]; then
    cp "$PLUGIN_ROOT/tutor/memory.template.md" "$MEMORY" || exit 1
  else
    printf '# Learning memory\n\n## Learned\n\n## Seen\n\n## Misconceptions\n\n## Questions asked\n' > "$MEMORY" || exit 1
  fi
fi

# apply <target section> <sections to remove the key from, "|"-separated> <skip-if-in section or ""> <key> <line>
# Prints "added", "skipped" or nothing on error.
apply() {
  local tmp
  tmp="$(mktemp "${TMPDIR:-/tmp}/tutor-memory.XXXXXX")" || return 1
  MT="$1" MR="$2" MS="$3" MK="$4" ML="$5" MQ="$MAX_QUESTIONS" awk '
    BEGIN {
      target = ENVIRON["MT"]; skipin = ENVIRON["MS"]; key = ENVIRON["MK"]
      line = ENVIRON["ML"]; maxq = ENVIRON["MQ"] + 0
      prefix = "- " key ": "
      n = split(ENVIRON["MR"], r, "|"); for (i = 1; i <= n; i++) remove[r[i]] = 1
    }
    { raw[NR] = $0 }
    END {
      # Pass 1: no-op if the key already lives in the skip-if-in section.
      section = ""
      for (i = 1; i <= NR; i++) {
        if (raw[i] ~ /^## /) { section = substr(raw[i], 4); continue }
        if (skipin != "" && section == skipin && index(raw[i], prefix) == 1) {
          for (j = 1; j <= NR; j++) print raw[j]
          print "skipped" > "/dev/stderr"; exit
        }
      }
      # Pass 2: drop old entries for this key, remember where the target section ends.
      section = ""; m = 0; insert_at = 0
      for (i = 1; i <= NR; i++) {
        if (raw[i] ~ /^## /) {
          section = substr(raw[i], 4); out[++m] = raw[i]
          if (section == target) insert_at = m
          continue
        }
        if ((section in remove) && index(raw[i], prefix) == 1) continue
        out[++m] = raw[i]
        if (section == target && raw[i] != "") insert_at = m
      }
      if (insert_at == 0) { out[++m] = ""; out[++m] = "## " target; insert_at = m }
      # Insert the new line after the last entry of the target section.
      for (i = 1; i <= insert_at; i++) final[++f] = out[i]
      final[++f] = line
      for (i = insert_at + 1; i <= m; i++) final[++f] = out[i]
      # Keep only the latest maxq entries under "Questions asked".
      if (target == "Questions asked") {
        section = ""; count = 0
        for (i = 1; i <= f; i++) {
          if (final[i] ~ /^## /) section = substr(final[i], 4)
          else if (section == target && final[i] ~ /^- /) count++
        }
        drop = count - maxq; section = ""
        for (i = 1; i <= f; i++) {
          if (final[i] ~ /^## /) section = substr(final[i], 4)
          else if (drop > 0 && section == target && final[i] ~ /^- /) { drop--; continue }
          print final[i]
        }
      } else {
        for (i = 1; i <= f; i++) print final[i]
      }
      print "added" > "/dev/stderr"
    }
  ' "$MEMORY" > "$tmp" 2> "$tmp.status" || { rm -f "$tmp" "$tmp.status"; return 1; }
  mv "$tmp" "$MEMORY" || { rm -f "$tmp.status"; return 1; }
  cat "$tmp.status"; rm -f "$tmp.status"
}

summary=()
while [ $# -gt 0 ]; do
  op="$1"
  [ $# -ge 3 ] || { echo "memory: '$op' needs two values" >&2; usage; }
  key="$2"; value="$3"; shift 3
  [ -n "$key" ] && [ -n "$value" ] || { echo "memory: empty key or value for '$op'" >&2; exit 1; }
  entry="- $key: $value ($TODAY)"
  case "$op" in
    seen)          result="$(apply "Seen" "Seen" "Learned" "$key" "$entry")" ;;
    learned)       result="$(apply "Learned" "Learned|Seen|Misconceptions" "" "$key" "$entry")" ;;
    misconception) result="$(apply "Misconceptions" "Misconceptions|Learned|Seen" "" "$key" "$entry")" ;;
    question)
      case "$value" in correct|incorrect|skipped) ;; *) echo "memory: question result must be correct, incorrect or skipped" >&2; exit 1 ;; esac
      result="$(apply "Questions asked" "Questions asked" "" "$key" "$entry")" ;;
    *) echo "memory: unknown operation '$op'" >&2; usage ;;
  esac
  [ -n "$result" ] || { echo "memory: could not update $MEMORY" >&2; exit 1; }
  if [ "$result" = "skipped" ]; then summary+=("$op kept (already learned)"); else summary+=("$op +1"); fi
done

( IFS=','; printf 'memory: %s\n' "${summary[*]}" | sed 's/,/, /g' )
