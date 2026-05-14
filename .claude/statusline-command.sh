#!/usr/bin/env bash

input=$(cat)

# Gruvbox true-color palette
R=$'\033[0m'
GRV_FG4=$'\033[38;2;168;153;132m'       # #a89984  muted warm gray
GRV_SEP=$'\033[38;2;124;111;100m'       # #7c6f64  dim separator
GRV_BLUE=$'\033[38;2;131;165;152m'      # #83a598  repo name
GRV_YELLOW=$'\033[38;2;250;189;47m'     # #fabd2f  branch
GRV_GREEN=$'\033[38;2;184;187;38m'      # #b8bb26  additions / ctx ok
GRV_RED=$'\033[38;2;251;73;52m'         # #fb4934  deletions / ctx danger
GRV_ORANGE=$'\033[38;2;254;128;25m'     # #fe8019  ctx warn / usage warn
GRV_AQUA=$'\033[38;2;142;192;124m'      # #8ec07c  model
GRV_PURPLE=$'\033[38;2;211;134;155m'    # #d3869b  usage % high

SEP=" ${GRV_SEP}|${R} "

# --- Repo + Branch ---
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
repo_branch="" velocity=""

if [ -n "$cwd" ] && git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  repo=$(basename "$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null)")
  branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null \
    || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
  git -C "$cwd" status --no-optional-locks --porcelain 2>/dev/null \
    | grep -qE '^[^?][^ ]|^ [^ ]' && dirty="*"

  repo_branch="${GRV_BLUE}${repo}${R} ${GRV_FG4}(${GRV_YELLOW}${branch}${dirty}${GRV_FG4})${R}"

  # --- Code velocity: uncommitted diff ---
  diff_stat=$(git -C "$cwd" diff --numstat HEAD 2>/dev/null)
  added=$(echo "$diff_stat" | awk '{s+=$1} END {print s+0}')
  removed=$(echo "$diff_stat" | awk '{s+=$2} END {print s+0}')
  if [ "$added" -gt 0 ] || [ "$removed" -gt 0 ]; then
    velocity="${GRV_GREEN}+${added}${R} ${GRV_RED}-${removed}${R}"
  fi
fi

# --- Context ---
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
if [ -n "$used_pct" ]; then
  ctx_val=$(printf "%.0f%%" "$used_pct")
  pct_int=$(printf "%.0f" "$used_pct")
  if   [ "$pct_int" -ge 80 ]; then ctx_color=$GRV_RED
  elif [ "$pct_int" -ge 50 ]; then ctx_color=$GRV_ORANGE
  else ctx_color=$GRV_GREEN; fi
else
  ctx_val="?" ctx_color=$GRV_FG4
fi
ctx="${GRV_FG4}ctx:${R}${ctx_color}${ctx_val}${R}"

# --- Model ---
model=$(echo "$input" | jq -r '.model.display_name // "?"')
model=$(echo "$model" | sed 's/^[Cc]laude[- ]//' | sed 's/-[0-9]\{8\}$//')

# --- Usage + Reset timer ---
usage_part=""
for window in five_hour seven_day; do
  pct=$(echo "$input"  | jq -r ".rate_limits.${window}.used_percentage // empty")
  reset=$(echo "$input" | jq -r ".rate_limits.${window}.resets_at      // empty")
  [ -z "$pct" ] && continue

  pct_int=$(printf "%.0f" "$pct")
  if   [ "$pct_int" -ge 80 ]; then usage_color=$GRV_PURPLE
  elif [ "$pct_int" -ge 50 ]; then usage_color=$GRV_ORANGE
  else usage_color=$GRV_GREEN; fi

  timer=""
  if [ -n "$reset" ] && [ "$reset" != "null" ]; then
    now=$(date +%s)
    diff=$(( reset - now ))
    if [ "$diff" -gt 0 ]; then
      h=$(( diff / 3600 ))
      m=$(( (diff % 3600) / 60 ))
      [ "$h" -gt 0 ] && timer=" ${GRV_FG4}${h}h${m}m${R}" || timer=" ${GRV_FG4}${m}m${R}"
    fi
  fi

  label=$( [ "$window" = "five_hour" ] && echo "5h" || echo "7d" )
  entry="${GRV_FG4}${label}:${R}${usage_color}$(printf "%.0f%%" "$pct")${R}${timer}"
  [ -n "$usage_part" ] && usage_part="${usage_part} ${entry}" || usage_part="$entry"
  break  # show only the most immediate window (5h takes priority)
done

# --- Assemble ---
parts=()
[ -n "$repo_branch" ] && parts+=("$repo_branch")
[ -n "$velocity" ]    && parts+=("$velocity")
parts+=("$ctx")
parts+=("${GRV_AQUA}${model}${R}")
[ -n "$usage_part" ]  && parts+=("$usage_part")

result=""
for i in "${!parts[@]}"; do
  [ "$i" -eq 0 ] && result="${parts[$i]}" || result="${result}${SEP}${parts[$i]}"
done

printf "%s" "$result"
