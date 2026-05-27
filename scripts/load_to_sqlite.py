"""Load cleaned QILT analysis CSV files into a local SQLite database."""

from __future__ import annotations

import csv
import sqlite3
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DB_PATH = ROOT / "database/qilt_employment.db"

TABLES = {
    "qilt_area_features": ROOT / "data/processed/qilt_gosl_2025_area_features.csv",
    "qilt_institutional_summary": ROOT / "outputs/tables/institutional_summary.csv",
}

NUMERIC_COLUMNS = {
    "survey_year",
    "short_term_full_time_employment_rate",
    "medium_term_full_time_employment_rate",
    "short_term_overall_employment_rate",
    "medium_term_overall_employment_rate",
    "short_term_labour_force_participation_rate",
    "medium_term_labour_force_participation_rate",
    "short_term_median_salary_aud",
    "medium_term_median_salary_aud",
    "full_time_employment_growth",
    "overall_employment_growth",
    "salary_growth",
    "salary_growth_rate",
    "male_medium_salary_aud",
    "female_medium_salary_aud",
    "gender_pay_gap",
    "medium_term_full_time_employment_rate_ci_low",
    "medium_term_full_time_employment_rate_ci_high",
    "medium_term_median_salary_aud_ci_low",
    "medium_term_median_salary_aud_ci_high",
}


def column_type(column_name: str) -> str:
    return "REAL" if column_name in NUMERIC_COLUMNS else "TEXT"


def clean_value(column_name: str, value: str):
    if value is None or value == "" or value.lower() in {"na", "n/a", "nan"}:
        return None
    if column_name in NUMERIC_COLUMNS:
        return float(value)
    return value


def load_csv(conn: sqlite3.Connection, table_name: str, csv_path: Path) -> int:
    if not csv_path.exists():
        raise FileNotFoundError(f"Missing CSV file: {csv_path}")

    with csv_path.open("r", newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        columns = reader.fieldnames or []
        if not columns:
            raise ValueError(f"No columns found in {csv_path}")

        conn.execute(f'DROP TABLE IF EXISTS "{table_name}"')
        column_sql = ", ".join(f'"{col}" {column_type(col)}' for col in columns)
        conn.execute(f'CREATE TABLE "{table_name}" ({column_sql})')

        placeholders = ", ".join("?" for _ in columns)
        quoted_columns = ", ".join(f'"{col}"' for col in columns)
        insert_sql = f'INSERT INTO "{table_name}" ({quoted_columns}) VALUES ({placeholders})'

        rows = []
        for row in reader:
            rows.append([clean_value(col, row[col]) for col in columns])

        conn.executemany(insert_sql, rows)
        return len(rows)


def main():
    DB_PATH.parent.mkdir(parents=True, exist_ok=True)

    with sqlite3.connect(DB_PATH) as conn:
        loaded_counts = {}
        for table_name, csv_path in TABLES.items():
            loaded_counts[table_name] = load_csv(conn, table_name, csv_path)

        conn.execute(
            "CREATE INDEX IF NOT EXISTS idx_area_field ON qilt_area_features(field_of_education)"
        )
        conn.execute(
            "CREATE INDEX IF NOT EXISTS idx_institution_name ON qilt_institutional_summary(institution)"
        )

    print(f"Created SQLite database: {DB_PATH}")
    for table_name, count in loaded_counts.items():
        print(f"Loaded {count} rows into {table_name}")


if __name__ == "__main__":
    main()
