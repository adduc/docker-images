#!/bin/bash

set -o pipefail -o nounset

[ -d "${1:-}" ] || { >&2 echo "Usage: $0 <dir>"; exit 1; }

IMAGE="${CLAUDE_CODE_IMAGE:-local/ai-agent-claude-code-fedora:44-amd64}"
TZ="${TZ:-$(readlink /etc/localtime 2>/dev/null | sed -n 's#.*/zoneinfo/##p')}"
TZ="${TZ:-UTC}"

[ -d ~/.claude ] || mkdir ~/.claude
[ -f ~/.claude.json ] || touch ~/.claude.json

docker run -t -i \
  -e "TERM=$TERM" \
  -e "UID=$(id -u)" \
  -e "GID=$(id -g)" \
  -e "TZ=$TZ" \
  -v "$(cd "$1" && pwd):/srv" \
  -v ~/.claude:/home/user/.claude \
  -v ~/.claude.json:/home/user/.claude.json \
  "$IMAGE"
