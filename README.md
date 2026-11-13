# Luftskepp Research

Modulär forskningsmiljö för luftskepp, zeppelinare, motorballonger och historiska termer.

## Snabbstart

```bash
python scripts/init_db.py
python scripts/cli.py status
python scripts/cli.py terms list
python scripts/mcp_server.py   # MCP-server för AI-verktyg
```

Se `docs/` för detaljerad dokumentation om CLI, cron och MCP.

## Struktur

- `schema/` – SQLite-schema
- `taxonomy/` – Klassificering
- `terms/` – Seed för termordbok
- `scripts/` – CLI, init, MCP-server, cron
- `queries/` – Nyhetsämnen och sökfrågor
- `docs/` – Dokumentation
