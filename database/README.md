# SQLite Database

This folder contains a small SQLite database generated from the cleaned QILT CSV outputs.

## Generate the Database

Run:

```bash
python3 scripts/load_to_sqlite.py
```

This creates or refreshes:

```text
database/qilt_employment.db
```

## Tables

- `qilt_area_features`: study-area level employment, salary, salary growth, and gender pay gap metrics
- `qilt_institutional_summary`: university-level medium-term employment and salary metrics

## Source CSV Files

The SQLite loader uses committed project outputs:

- `outputs/tables/employment_by_field_year.csv`
- `outputs/tables/institutional_summary.csv`

This means the loader can run locally and in GitHub Actions without requiring ignored intermediate `data/processed` files.

## SQL Queries

Portfolio SQL queries are stored in:

```text
sql/analysis_queries.sql
```

You can run them in SQLite, DB Browser for SQLite, or adapt them for PostgreSQL.
