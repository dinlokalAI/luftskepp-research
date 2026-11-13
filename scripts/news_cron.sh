#!/bin/bash
# Cron-friendly news fetcher for luftskepp research
# Example crontab (once or twice daily):
#   15 7,19 * * * /path/to/research/2026-07-13_luftskepp/scripts/news_cron.sh >> /path/to/logs/luftskepp_news.log 2>&1

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$ROOT"

echo "=== $(date -Iseconds) luftskepp news fetch ==="
python scripts/cli.py news fetch --json
echo "Done."
