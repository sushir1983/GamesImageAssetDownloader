#!/usr/bin/env bash

set -euo pipefail

JSON_FILE="ProductListBYOG2Feb.json"
OUT_DIR="output"
FAILED_LOG="failed_urls.txt"

mkdir -p "$OUT_DIR"
touch "$FAILED_LOG"

jq -r '
.products[] as $product |
  $product.name as $name |
  ($product | .. | objects | select(has("ImageUrl")) | .ImageUrl) as $url |
  [$name, $url] | @tsv
' "$JSON_FILE" | while IFS=$'\t' read -r name url; do

  [[ -z "$url" ]] && continue

  safe_name=$(echo "$name" | sed 's#[/:*?"<>|]#_#g')
  mkdir -p "$OUT_DIR/$safe_name"

  filename=$(basename "${url%%\?*}")
  target="$OUT_DIR/$safe_name/$filename"

  [[ -f "$target" ]] && continue

  encoded_url=$(python3 - <<EOF
import urllib.parse
print(urllib.parse.quote("""$url""", safe=":/"))
EOF
)

  echo "⬇️  Downloading: $safe_name/$filename"

  if ! curl -L --fail --silent --show-error \
        -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)" \
        -H "Referer: https://gamestream.img.netgemplatform.net/" \
        -o "$target" "$encoded_url"; then

    echo "❌ Failed (403 or network): $url"
    rm -f "$target"

    log_entry="$safe_name | $url"
    grep -Fqx "$log_entry" "$FAILED_LOG" || echo "$log_entry" >> "$FAILED_LOG"
  fi

done

