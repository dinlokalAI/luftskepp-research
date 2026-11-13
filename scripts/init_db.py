#!/usr/bin/env python3
"""Initialize the luftskepp SQLite database from schema + seed terms."""
from __future__ import annotations
import argparse, json, sqlite3
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DEFAULT_DB = ROOT / "data" / "luftskepp.db"
SCHEMA = ROOT / "schema" / "airships_schema.sql"
SEED = ROOT / "terms" / "seed_terms.json"

def main():
    p = argparse.ArgumentParser()
    p.add_argument("--db", type=Path, default=DEFAULT_DB)
    args = p.parse_args()
    args.db.parent.mkdir(parents=True, exist_ok=True)
    conn = sqlite3.connect(args.db)
    conn.executescript(SCHEMA.read_text(encoding="utf-8"))
    if SEED.exists():
        data = json.loads(SEED.read_text(encoding="utf-8"))
        for item in data:
            conn.execute(
                """INSERT INTO terms (canonical_term, language, category, definition, historical_notes, confidence)
                   VALUES (?,?,?,?,?,?) ON CONFLICT(canonical_term, language) DO NOTHING""",
                (item["canonical_term"], item.get("language","sv"), item.get("category"),
                 item.get("definition"), item.get("historical_notes"), item.get("confidence","medium"))
            )
            tid = conn.execute("SELECT id FROM terms WHERE canonical_term=? AND language=?",
                               (item["canonical_term"], item.get("language","sv"))).fetchone()[0]
            for v in item.get("variants", []):
                conn.execute("INSERT OR IGNORE INTO term_variants (term_id, variant, source) VALUES (?,?,?)",
                             (tid, v["variant"], v.get("source")))
        conn.commit()
        print(f"Loaded {len(data)} terms")
    conn.close()
    print(f"Database ready: {args.db}")

if __name__ == "__main__":
    main()
