#!/usr/bin/env bash
set -euo pipefail

VAULT="${OBSIDIAN_VAULT:-$HOME/Documents/obsidian-vault}"
CARDS_DIR="$VAULT/Odoo/Upgrade/PR Review/Cards"

if ! command -v gh >/dev/null; then
    echo "gh not found in PATH" >&2
    exit 1
fi
if ! command -v jq >/dev/null; then
    echo "jq not found in PATH" >&2
    exit 1
fi

mkdir -p "$CARDS_DIR"

created=0
skipped=0

while IFS= read -r pr; do
    repo=$(echo "$pr" | jq -r '.repository.name')
    number=$(echo "$pr" | jq -r '.number')
    url=$(echo "$pr" | jq -r '.url')
    title=$(echo "$pr" | jq -r '.title')
    author=$(echo "$pr" | jq -r '.author.login')
    opened=$(echo "$pr" | jq -r '.createdAt' | cut -d'T' -f1)

    slug="${repo}-${number}"
    file="$CARDS_DIR/${slug}.md"

    if [[ -f "$file" ]]; then
        skipped=$((skipped + 1))
        continue
    fi

    title_yaml=${title//\"/\\\"}

    cat > "$file" <<EOF
---
url: $url
author: $author
repo: $repo
opened: $opened
status: inbox
title: "$title_yaml"
---

# [$slug]($url)

> $title

## Summary
> Scope, modules affected, why.

## Files touched
-

## Review notes
- [ ]

## Blockers / questions
-

## Comments
-
EOF

    echo "created: $slug"
    created=$((created + 1))
done < <(
    gh search prs \
        "user-review-requested:@me" "is:open" "is:pr" \
        --limit 50 \
        --json url,title,author,repository,number,createdAt \
        | jq -c '.[]'
)


# --- Pass 2: mark closed PRs (merged or not) as merged ---
  merged=0
  while IFS= read -r pr; do
      repo=$(echo "$pr" | jq -r '.repository.name')
      number=$(echo "$pr" | jq -r '.number')
      slug="${repo}-${number}"
      file="$CARDS_DIR/${slug}.md"

      [[ -f "$file" ]] || continue

      current=$(awk -F': *' '/^status:/{print $2; exit}' "$file")
      if [[ "$current" != "merged" ]]; then
          sed -i 's/^status: .*/status: merged/' "$file"
          echo "merged: $slug"
          merged=$((merged + 1))
      fi
  done < <(
      gh search prs \
          "user-review-requested:@me" "is:closed" "is:pr" \
          --limit 50 \
          --json repository,number \
          | jq -c '.[]'
  )


echo
echo "done: $created created, $skipped already existed"



