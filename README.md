# Luftskepp Research

Modulär forskningsmiljö för luftskepp, zeppelinare, motorballonger och historiska termer.

Innehåller:
- SQLite-schema + taxonomi
- Levande termordbok med svenska historiska varianter
- CLI (människa + AI-vänlig)
- MCP-server (JSON-RPC över stdio)
- Nyhetshämtning med cron-stöd

## Snabbstart

```bash
python scripts/init_db.py
python scripts/cli.py status
python scripts/cli.py terms list
python scripts/cli.py terms expand luftskepp
python scripts/mcp_server.py
```

Se `docs/` för CLI, cron och MCP-dokumentation.

## Struktur

```
├── schema/          # SQLite-schema
├── taxonomy/        # Klassificering (YAML)
├── terms/           # Seed för termordbok
├── scripts/         # CLI, init, MCP-server, cron
├── queries/         # Nyhetsämnen + sökfrågor
└── docs/            # Dokumentation
```

Databasen skapas lokalt med `init_db.py` (läggs inte in i git).
