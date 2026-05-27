# Interview Talking Points

This document helps explain the project clearly in a data analyst interview.

## 1. One-minute Project Pitch

This project analyses Australian graduate employment outcomes using real public QILT GOS-L 2025 data. I focused on Computing and Information Systems graduates and compared their employment rate, salary, salary growth, and gender pay gap with other study areas.

The project covers the full analysis workflow: extracting selected sheets from a public Excel workbook with Python, cleaning and transforming data in R, creating visualisations, running exploratory models, writing SQL-style analysis queries, and generating an HTML report.

## 2. Why I Chose This Project

I chose this topic because graduate employment is a practical business and policy question. Students, universities, and education decision-makers all care about whether a degree leads to strong employment and salary outcomes.

CIS is especially interesting because technology skills are in high demand, but gender pay gaps can still exist in technology-related fields.

## 3. Data Source

The data comes from the QILT Graduate Outcomes Survey - Longitudinal (GOS-L) 2025 National Report Tables.

QILT GOS-L reports graduate outcomes around three years after course completion. The public workbook includes employment rates, salary outcomes, gender breakdowns, study areas, and university-level summary results.

Important limitation: the data is aggregated summary data, not person-level survey data.

## 4. Tools Used

- Python and openpyxl for extracting selected sheets from Excel
- R for data cleaning, feature engineering, charts, modelling, and reporting
- SQL for portfolio-style analytical queries
- RMarkdown for the final HTML report
- Git and GitHub for version control

## 5. What I Did

1. Downloaded the official QILT GOS-L public workbook.
2. Extracted selected sheets into clean CSV files.
3. Cleaned employment rate and salary fields.
4. Created features such as CIS flag, STEM-related flag, salary growth, and gender pay gap.
5. Built charts to compare study areas and universities.
6. Created exploratory models to understand salary-related indicators.
7. Produced an HTML report, executive summary, data dictionary, methodology, SQL queries, and dashboard preview.

## 6. Key Findings

- CIS graduates had a 91.0% medium-term full-time employment rate.
- CIS graduates had a 92.0% medium-term overall employment rate.
- CIS medium-term median salary was AUD 100,000.
- CIS salary increased by AUD 30,900 from short-term to medium-term.
- Male CIS graduates had a medium-term median salary of AUD 103,000.
- Female CIS graduates had a medium-term median salary of AUD 94,000.
- The CIS gender pay gap was about 8.7%.

## 7. How I Would Explain the Business Value

This analysis helps compare graduate outcomes across study areas and institutions. It can support:

- students comparing study options;
- universities reviewing graduate outcomes;
- career services teams identifying strong and weaker outcome areas;
- analysts benchmarking employment and salary performance.

The project turns a complex public Excel workbook into clear insights, charts, summary tables, and a reproducible analysis workflow.

## 8. Modelling Explanation

Because the data is aggregated, I did not present the model as an individual graduate prediction model.

Instead, I used exploratory modelling:

- a linear regression model to examine relationships with medium-term median salary;
- a decision tree to classify whether a study area has above-median medium-term salary.

This is a careful approach because aggregated data can show relationships but cannot prove individual-level causes.

## 9. Main Limitation

The biggest limitation is that the public QILT file is summary-level data. It does not include individual graduate records such as GPA, internship history, job applications, or personal background.

Because of this, the project is suitable for descriptive analytics and benchmarking, but not for causal claims about individual graduate outcomes.

## 10. What I Would Improve Next

If I had more time, I would:

- add historical QILT tables to compare multiple years;
- create an interactive Power BI or Tableau dashboard;
- load the CSV files into PostgreSQL or SQLite and run the SQL analysis directly;
- add a Python notebook version of the analysis;
- compare CIS against selected STEM fields in more detail.

## 11. Interview Q&A Preparation

### What was the hardest part?

The source data was a multi-sheet public Excel workbook, not a single clean dataset. I had to inspect the workbook structure, select useful sheets, and convert them into tidy CSV files before analysis.

### Why did you use both Python and R?

Python was useful for extracting structured data from Excel sheets. R was useful for statistical analysis, visualisation, modelling, and generating the final report.

### Why did you add SQL if the project uses CSV?

SQL is a common data analyst skill. I added SQL queries to show how the same analysis could be done after loading the cleaned CSV files into a database.

### What is your strongest insight?

CIS shows strong employment and salary outcomes, with a 91.0% medium-term full-time employment rate and AUD 100,000 medium-term median salary. However, a gender pay gap of about 8.7% remains visible.

### What would you tell a non-technical stakeholder?

CIS graduates generally perform well in employment and salary outcomes, but salary equality still needs attention. The data supports using CIS as a strong study pathway while continuing to monitor gender pay differences.

