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

created=0; skipped=0; merged=0
declare -A seen_slugs

# Pass 1: create cards for open PRs assigned for review
while IFS=$'\t' read -r repo number url title author opened; do
    slug="${repo}-${number}"
    seen_slugs["$slug"]=1
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
    slug="${repo}-${number}"
    seen_slugs["$slug"]=1
    file="$CARDS_DIR/${slug}.md"
    [[ -f "$file" ]] && mark_merged "$file" && merged=$((merged + 1)) || true
done < <(
    gh search prs "user-review-requested:@me" "is:closed" "is:pr" --limit 10 \
        --json repository,number \
        | jq -r '.[] | [.repository.name, (.number|tostring)] | @tsv'
)

# Pass 3: catch cards missed by passes 1/2 (e.g. review request was dismissed before close)
while IFS= read -r file; do
    slug=$(basename "$file" .md)
    # already handled by pass 1 or 2 — skip to avoid a redundant API call
    [[ -n "${seen_slugs[$slug]:-}" ]] && continue
    url=$(awk '/^url:/{sub(/^url:[[:space:]]*/, ""); print; exit}' "$file")
    [[ -z "$url" ]] && continue
    state=$(gh pr view "$url" --json state -q '.state' 2>/dev/null) || continue
    if [[ "$state" == "MERGED" || "$state" == "CLOSED" ]]; then
        mark_merged "$file" && merged=$((merged + 1)) || true
    fi
done < <(grep -rL '^status: merged' "$CARDS_DIR")

echo
echo "done: $created created, $skipped skipped, $merged closed→merged"
