# Data Dictionary

This document explains the main fields used in the cleaned analysis dataset.

## Main Dataset

File:

```text
data/processed/qilt_gosl_2025_area_features.csv
```

| Field | Meaning |
|---|---|
| `field_of_education` | Study area reported by QILT |
| `source` | Data source name |
| `survey_year` | Survey/report year |
| `cohort` | Graduate cohort type |
| `short_term_full_time_employment_rate` | Full-time employment rate shortly after graduation |
| `medium_term_full_time_employment_rate` | Full-time employment rate around three years after graduation |
| `short_term_overall_employment_rate` | Overall employment rate shortly after graduation |
| `medium_term_overall_employment_rate` | Overall employment rate around three years after graduation |
| `short_term_labour_force_participation_rate` | Labour force participation rate shortly after graduation |
| `medium_term_labour_force_participation_rate` | Labour force participation rate around three years after graduation |
| `short_term_median_salary_aud` | Short-term median salary in AUD |
| `medium_term_median_salary_aud` | Medium-term median salary in AUD |
| `is_cis` | Whether the study area is Computing and information systems |
| `is_stem_related` | Whether the study area is treated as STEM-related in this project |
| `full_time_employment_growth` | Medium-term full-time employment rate minus short-term full-time employment rate |
| `overall_employment_growth` | Medium-term overall employment rate minus short-term overall employment rate |
| `salary_growth` | Medium-term salary minus short-term salary |
| `salary_growth_rate` | Salary growth divided by short-term salary |
| `high_medium_salary` | Whether medium-term salary is above or equal to the median across study areas |
| `male_medium_salary_aud` | Male medium-term median salary in AUD |
| `female_medium_salary_aud` | Female medium-term median salary in AUD |
| `gender_pay_gap` | `(male salary - female salary) / male salary` |

## Institution Dataset

File:

```text
outputs/tables/institutional_summary.csv
```

| Field | Meaning |
|---|---|
| `institution` | University name |
| `medium_term_full_time_employment_rate` | University-level medium-term full-time employment rate |
| `medium_term_full_time_employment_rate_ci_low` | Lower bound of confidence interval |
| `medium_term_full_time_employment_rate_ci_high` | Upper bound of confidence interval |
| `medium_term_median_salary_aud` | University-level medium-term median salary |
| `medium_term_median_salary_aud_ci_low` | Lower bound of confidence interval |
| `medium_term_median_salary_aud_ci_high` | Upper bound of confidence interval |

## Important Note

The dataset is aggregated. Each row represents a study area or university-level summary, not an individual graduate.

