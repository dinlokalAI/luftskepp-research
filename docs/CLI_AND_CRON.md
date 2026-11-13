# CLI + Cron

## CLI

```bash
python scripts/cli.py status
python scripts/cli.py --json terms expand luftskepp
python scripts/cli.py terms search motor
python scripts/cli.py news fetch
```

## Cron

```bash
chmod +x scripts/news_cron.sh
# crontab:
# 15 7,19 * * * /path/to/scripts/news_cron.sh >> ~/logs/luftskepp_news.log 2>&1
```

Utöka ämnen i `queries/news_topics.json`.
