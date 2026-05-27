"""Run lightweight repository health checks for the portfolio project."""

from __future__ import annotations

import csv
import json
import sqlite3
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


REQUIRED_FILES = [
    "README.md",
    "index.html",
    "reports/australia_graduate_employment_report.html",
    "outputs/figures/portfolio_dashboard.png",
    "outputs/tables/cis_summary.csv",
    "outputs/tables/data_quality_checks.csv",
    "outputs/tables/employment_by_field_year.csv",
    "outputs/tables/institutional_summary.csv",
    "sql/analysis_queries.sql",
    "notebooks/qilt_employment_analysis.ipynb",
    "database/qilt_employment.db",
]


def check_required_files() -> list[str]:
    errors = []
    for relative_path in REQUIRED_FILES:
        path = ROOT / relative_path
        if not path.exists():
            errors.append(f"Missing required file: {relative_path}")
        elif path.stat().st_size == 0:
            errors.append(f"Required file is empty: {relative_path}")
    return errors


def read_csv_rows(relative_path: str) -> list[dict[str, str]]:
    with (ROOT / relative_path).open("r", newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f))


def check_cis_metrics() -> list[str]:
    errors = []
    rows = read_csv_rows("outputs/tables/cis_summary.csv")
    if len(rows) != 1:
        return [f"Expected 1 CIS summary row, found {len(rows)}"]

    cis = rows[0]
    if cis.get("field_of_education") != "Computing and information systems":
        errors.append("CIS summary row has unexpected field_of_education")

    expected_values = {
        "medium_term_full_time_employment_rate": 91.0,
        "medium_term_overall_employment_rate": 92.0,
        "medium_term_median_salary_aud": 100000.0,
    }
    for column, expected in expected_values.items():
        actual = float(cis[column])
        if abs(actual - expected) > 0.001:
            errors.append(f"Unexpected {column}: expected {expected}, found {actual}")

    return errors


def check_data_quality_results() -> list[str]:
    rows = read_csv_rows("outputs/tables/data_quality_checks.csv")
    if not rows:
        return ["Data quality checks file has no rows"]

    failures = [row for row in rows if row.get("result") == "FAIL"]
    if failures:
        names = ", ".join(row.get("check_name", "unknown") for row in failures)
        return [f"Data quality checks contain FAIL rows: {names}"]

    return []


def check_notebook_json() -> list[str]:
    path = ROOT / "notebooks/qilt_employment_analysis.ipynb"
    try:
        with path.open("r", encoding="utf-8") as f:
            notebook = json.load(f)
    except json.JSONDecodeError as exc:
        return [f"Notebook JSON is invalid: {exc}"]

    if notebook.get("nbformat") != 4:
        return ["Notebook nbformat is not 4"]
    if not notebook.get("cells"):
        return ["Notebook has no cells"]
    return []


def check_sqlite_database() -> list[str]:
    db_path = ROOT / "database/qilt_employment.db"
    errors = []
    with sqlite3.connect(db_path) as conn:
        tables = {
            row[0]
            for row in conn.execute(
                "SELECT name FROM sqlite_master WHERE type = 'table'"
            ).fetchall()
        }
        expected_tables = {"qilt_area_features", "qilt_institutional_summary"}
        missing_tables = expected_tables - tables
        if missing_tables:
            errors.append(f"Missing SQLite tables: {sorted(missing_tables)}")

        for table_name in expected_tables & tables:
            count = conn.execute(f"SELECT COUNT(*) FROM {table_name}").fetchone()[0]
            if count == 0:
                errors.append(f"SQLite table has no rows: {table_name}")

    return errors


def main():
    checks = [
        check_required_files,
        check_cis_metrics,
        check_data_quality_results,
        check_notebook_json,
        check_sqlite_database,
    ]

    errors = []
    for check in checks:
        errors.extend(check())

    if errors:
        print("Project health check failed:")
        for error in errors:
            print(f"- {error}")
        raise SystemExit(1)

    print("Project health check passed.")


if __name__ == "__main__":
    main()

