#! /bin/zsh

set -euo pipefail

BINARY=".build/release/LSPService"
DEST_DIR="../../apps/codeface-io.github.io/lspservice/binaries/arm64-apple-macosx"
DEST_ZIP="$DEST_DIR/LSPService.zip"

swift build --configuration release

if [[ ! -f "$BINARY" ]]; then
  echo "error: missing binary at $BINARY after build" >&2
  exit 1
fi

mkdir -p "$DEST_DIR"
zip -j "$DEST_ZIP" "$BINARY"
echo "wrote $DEST_ZIP"
