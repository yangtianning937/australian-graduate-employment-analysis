# Data Quality Report

This report summarises the data quality checks used in the QILT graduate employment analysis project.

## Purpose

Data quality checking is important because the project uses public summary tables extracted from a multi-sheet Excel workbook. Before analysis, the project checks whether the cleaned tables are complete enough and whether key numeric fields are within expected ranges.

## Output File

The automated check results are saved to:

```text
outputs/tables/data_quality_checks.csv
```

## Checks Included

| Check | Purpose |
|---|---|
| Area row count | Confirms the study-area dataset is not empty |
| Institution row count | Confirms the university-level dataset is not empty |
| Duplicate area rows | Checks whether duplicate study-area rows exist |
| CIS record exists | Confirms Computing and information systems is present |
| Rate range checks | Confirms employment and participation rates are between 0 and 100 |
| Salary range checks | Confirms salaries are positive and below a reasonable upper bound |
| Institution salary completeness | Checks missing values in university salary data |
| Institution employment completeness | Checks missing values in university employment data |

## How to Run

Run the full project pipeline:

```bash
Rscript run_analysis.R
```

Or source the R file directly after processed data has been generated:

```r
source("R/05_data_quality_checks.R")
run_data_quality_checks()
```

## Interpretation

- `PASS`: check passed
- `WARN`: not necessarily wrong, but worth reviewing
- `FAIL`: should be fixed before relying on the analysis

## Notes

The source data is aggregated public report data. Some missing values can be expected because QILT may suppress or omit values for small groups or unavailable categories.

