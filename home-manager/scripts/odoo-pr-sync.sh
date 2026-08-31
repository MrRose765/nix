#!/usr/bin/env bash
set -euo pipefail

VAULT="${OBSIDIAN_VAULT:-$HOME/Documents/obsidian-vault}"
CARDS_DIR="$VAULT/Odoo/Upgrade/PR Review/Cards"

for cmd in gh jq; do
    command -v "$cmd" >/dev/null || { echo "$cmd not found in PATH" >&2; exit 1; }
done

mkdir -p "$CARDS_DIR"

mark_merged() {
    local file=$1 label=${2:-}
    local current slug
    current=$(awk -F': *' '/^status:/{print $2; exit}' "$file")
    [[ "$current" == "merged" ]] && return 1
    slug=$(basename "$file" .md)
    sed -i 's/^status: .*/status: merged/' "$file"
    echo "merged${label:+ ($label)}: $slug"
}

created=0; skipped=0; merged=0; approved_merged=0

# Pass 1: create cards for open PRs assigned for review
while IFS=$'\t' read -r repo number url title author opened; do
    slug="${repo}-${number}"
    file="$CARDS_DIR/${slug}.md"
    if [[ -f "$file" ]]; then skipped=$((skipped + 1)); continue; fi

    cat > "$file" <<EOF
---
url: $url
author: $author
repo: $repo
opened: $opened
status: inbox
title: "${title//\"/\\\"}"
---

# [$slug]($url)

> $title

## Summary

## Comments
-
EOF
    echo "created: $slug"
    created=$((created + 1))
done < <(
    gh search prs "user-review-requested:@me" "is:open" "is:pr" --limit 50 \
        --json url,title,author,repository,number,createdAt \
        | jq -r '.[] | [.repository.name, (.number|tostring), .url, .title, .author.login, .createdAt[:10]] | @tsv'
)

# Pass 2: mark closed PRs as merged
while IFS=$'\t' read -r repo number; do
    file="$CARDS_DIR/${repo}-${number}.md"
    [[ -f "$file" ]] && mark_merged "$file" && merged=$((merged + 1)) || true
done < <(
    gh search prs "user-review-requested:@me" "is:closed" "is:pr" --limit 50 \
        --json repository,number \
        | jq -r '.[] | [.repository.name, (.number|tostring)] | @tsv'
)

# Pass 3: check locally-approved cards against GitHub
while IFS= read -r file; do
    url=$(awk -F': *' '/^url:/{print $2; exit}' "$file")
    [[ -z "$url" ]] && continue
    state=$(gh pr view "$url" --json state -q '.state' 2>/dev/null) || continue
    if [[ "$state" == "MERGED" || "$state" == "CLOSED" ]]; then
        mark_merged "$file" "was approved" && approved_merged=$((approved_merged + 1)) || true
    fi
done < <(grep -rl '^status: approved' "$CARDS_DIR")

echo
echo "done: $created created, $skipped skipped, $merged closed→merged, $approved_merged approved→merged"
