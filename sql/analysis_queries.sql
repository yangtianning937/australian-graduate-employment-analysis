-- Australian Graduate Employment Outcomes Analysis
-- SQL portfolio queries for QILT GOS-L 2025 extracted tables.
--
-- Assumed tables after importing CSV files into PostgreSQL or SQLite:
-- 1. qilt_area_features
--    Source CSV: data/processed/qilt_gosl_2025_area_features.csv
-- 2. qilt_institutional_summary
--    Source CSV: outputs/tables/institutional_summary.csv
--
-- Notes:
-- - Values are aggregated by study area or institution.
-- - This is not person-level graduate data.
-- - Some syntax, such as ROUND(), works in both PostgreSQL and SQLite.


-- 1. CIS headline KPI summary
SELECT
    field_of_education,
    medium_term_full_time_employment_rate,
    medium_term_overall_employment_rate,
    short_term_median_salary_aud,
    medium_term_median_salary_aud,
    salary_growth,
    ROUND(salary_growth_rate * 100, 1) AS salary_growth_rate_pct,
    male_medium_salary_aud,
    female_medium_salary_aud,
    ROUND(gender_pay_gap * 100, 1) AS gender_pay_gap_pct
FROM qilt_area_features
WHERE is_cis = 'Yes';


-- 2. Study areas ranked by medium-term median salary
SELECT
    field_of_education,
    is_cis,
    is_stem_related,
    medium_term_median_salary_aud,
    medium_term_full_time_employment_rate
FROM qilt_area_features
WHERE medium_term_median_salary_aud IS NOT NULL
ORDER BY medium_term_median_salary_aud DESC;


-- 3. Study areas ranked by medium-term full-time employment
SELECT
    field_of_education,
    is_cis,
    is_stem_related,
    medium_term_full_time_employment_rate,
    medium_term_median_salary_aud
FROM qilt_area_features
WHERE medium_term_full_time_employment_rate IS NOT NULL
ORDER BY medium_term_full_time_employment_rate DESC;


-- 4. Salary growth from short-term to medium-term
SELECT
    field_of_education,
    short_term_median_salary_aud,
    medium_term_median_salary_aud,
    salary_growth,
    ROUND(salary_growth_rate * 100, 1) AS salary_growth_rate_pct
FROM qilt_area_features
WHERE salary_growth IS NOT NULL
ORDER BY salary_growth DESC;


-- 5. Gender pay gap by study area
SELECT
    field_of_education,
    male_medium_salary_aud,
    female_medium_salary_aud,
    ROUND(gender_pay_gap * 100, 1) AS gender_pay_gap_pct
FROM qilt_area_features
WHERE gender_pay_gap IS NOT NULL
ORDER BY gender_pay_gap DESC;


-- 6. STEM-related gender pay gap comparison
SELECT
    field_of_education,
    is_cis,
    male_medium_salary_aud,
    female_medium_salary_aud,
    ROUND(gender_pay_gap * 100, 1) AS gender_pay_gap_pct
FROM qilt_area_features
WHERE is_stem_related = 'Yes'
  AND gender_pay_gap IS NOT NULL
ORDER BY gender_pay_gap DESC;


-- 7. Combined score for portfolio-style ranking
-- This simple score combines normalised salary and full-time employment.
-- In a real business setting, weights should be agreed with stakeholders.
WITH bounds AS (
    SELECT
        MIN(medium_term_median_salary_aud) AS min_salary,
        MAX(medium_term_median_salary_aud) AS max_salary,
        MIN(medium_term_full_time_employment_rate) AS min_fte,
        MAX(medium_term_full_time_employment_rate) AS max_fte
    FROM qilt_area_features
    WHERE medium_term_median_salary_aud IS NOT NULL
      AND medium_term_full_time_employment_rate IS NOT NULL
),
scored AS (
    SELECT
        q.field_of_education,
        q.is_cis,
        q.medium_term_median_salary_aud,
        q.medium_term_full_time_employment_rate,
        (
            0.6 * (
                (q.medium_term_median_salary_aud - b.min_salary)
                / NULLIF((b.max_salary - b.min_salary), 0)
            )
            +
            0.4 * (
                (q.medium_term_full_time_employment_rate - b.min_fte)
                / NULLIF((b.max_fte - b.min_fte), 0)
            )
        ) AS outcome_score
    FROM qilt_area_features q
    CROSS JOIN bounds b
)
SELECT
    field_of_education,
    is_cis,
    medium_term_median_salary_aud,
    medium_term_full_time_employment_rate,
    ROUND(outcome_score, 3) AS outcome_score
FROM scored
ORDER BY outcome_score DESC;


-- 8. Top universities by medium-term median salary
SELECT
    institution,
    medium_term_median_salary_aud,
    medium_term_full_time_employment_rate
FROM qilt_institutional_summary
WHERE medium_term_median_salary_aud IS NOT NULL
ORDER BY medium_term_median_salary_aud DESC
LIMIT 10;


-- 9. Top universities by medium-term full-time employment
SELECT
    institution,
    medium_term_full_time_employment_rate,
    medium_term_median_salary_aud
FROM qilt_institutional_summary
WHERE medium_term_full_time_employment_rate IS NOT NULL
ORDER BY medium_term_full_time_employment_rate DESC
LIMIT 10;


-- 10. Universities with both strong salary and strong employment outcomes
SELECT
    institution,
    medium_term_median_salary_aud,
    medium_term_full_time_employment_rate
FROM qilt_institutional_summary
WHERE medium_term_median_salary_aud >= 90000
  AND medium_term_full_time_employment_rate >= 90
ORDER BY medium_term_median_salary_aud DESC,
         medium_term_full_time_employment_rate DESC;

