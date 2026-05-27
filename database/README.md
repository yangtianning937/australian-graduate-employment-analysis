# SQLite Database

This folder contains a small SQLite database generated from the cleaned QILT CSV outputs.

## Generate the Database

Run:

```bash
python3 scripts/load_to_sqlite.py
```

This creates:

```text
database/qilt_employment.db
```

## Tables

- `qilt_area_features`: study-area level employment, salary, salary growth, and gender pay gap metrics
- `qilt_institutional_summary`: university-level medium-term employment and salary metrics

## SQL Queries

Portfolio SQL queries are stored in:

```text
sql/analysis_queries.sql
```

You can run them in SQLite, DB Browser for SQLite, or adapt them for PostgreSQL.

