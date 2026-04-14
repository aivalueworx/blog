#!/usr/bin/env bash
set -euo pipefail

# Symlinks vault-shared/published/blog → src/posts/imported for local dev.
# Keeps src/posts/posts.11tydata.js in the repo (not inside the symlink).

VAULT_SHARED="${1:?Usage: $0 /path/to/vault-shared}"
CONTENT_SOURCE="$VAULT_SHARED/published/blog"
IMPORT_DIR="src/posts/imported"

if [ ! -d "$CONTENT_SOURCE" ]; then
  echo "ERROR: $CONTENT_SOURCE does not exist."
  echo "Create published/blog/ in vault-shared with .md posts."
  exit 1
fi

ABS_SOURCE="$(cd "$CONTENT_SOURCE" && pwd)"

if [ -L "$IMPORT_DIR" ]; then
  echo "Removing existing symlink $IMPORT_DIR"
  rm "$IMPORT_DIR"
elif [ -d "$IMPORT_DIR" ]; then
  echo "Removing existing directory $IMPORT_DIR"
  rm -rf "$IMPORT_DIR"
fi

ln -s "$ABS_SOURCE" "$IMPORT_DIR"
echo "Linked: $IMPORT_DIR -> $ABS_SOURCE"
echo "Run: npm run dev  (http://localhost:8081)"
