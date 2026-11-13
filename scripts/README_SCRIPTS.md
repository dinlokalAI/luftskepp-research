# Scripts

- `init_db.py` – skapar databasen och laddar seed-termer (finns i repo)
- `news_cron.sh` – cron-script för nyheter (finns i repo)
- `cli.py` och `mcp_server.py` – fullständig CLI + MCP-server

De två sistnämnda är längre och finns i den ursprungliga zip-filen från Grok (`luftskepp_research_2026-07-13.zip`). Kopiera dem hit för komplett funktionalitet.

Efter kopiering:

```bash
python scripts/init_db.py
python scripts/cli.py status
python scripts/mcp_server.py
```
