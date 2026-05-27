# Methodology

## 1. Data Extraction

The raw data comes from the QILT GOS-L 2025 National Report Tables workbook. The workbook contains many report sheets, so the project uses Python and `openpyxl` to extract selected sheets into clean CSV files.

Extracted tables include:

- study-area employment and salary summary;
- study-area and gender summary;
- university-level medium-term full-time employment;
- university-level medium-term median salary.

Script:

```text
scripts/extract_qilt_gosl_2025.py
```

## 2. Data Cleaning

The R cleaning script checks that:

- employment rates are between 0 and 100;
- salaries are positive and not unrealistically high;
- duplicate rows are removed;
- clean CSV and RDS files are written for later steps.

Script:

```text
R/01_clean_data.R
```

## 3. Feature Engineering

The feature engineering step creates:

- CIS flag;
- STEM-related flag;
- full-time employment growth;
- overall employment growth;
- salary growth;
- salary growth rate;
- high medium-term salary flag;
- gender pay gap by study area.

Script:

```text
R/02_feature_engineering.R
```

## 4. Analysis and Visualisation

The analysis compares:

- medium-term full-time employment by study area;
- medium-term overall employment by study area;
- medium-term median salary by study area;
- salary growth from short-term to medium-term;
- gender pay gap by study area;
- STEM-related gender pay gap;
- university-level employment and salary outcomes.

Charts are saved in:

```text
outputs/figures/
```

## 5. Exploratory Modelling

Two simple models are used:

1. Linear regression to examine relationships with medium-term median salary.
2. Decision tree to classify whether a study area has above-median medium-term salary.

Because the data is aggregated, these models are exploratory. They should not be interpreted as individual-level prediction models.

## 6. Reporting

The final report is generated with RMarkdown:

```text
reports/australia_graduate_employment_report.Rmd
```

Output:

```text
reports/australia_graduate_employment_report.html
```

