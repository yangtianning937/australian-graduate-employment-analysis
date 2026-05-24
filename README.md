# Computing and Information Systems Graduates Employment Analysis

本项目根据 `DEP_Yang_30138965.pdf` 的主题完善，分析澳洲 Computing and Information Systems（CIS，计算机与信息系统）毕业生的就业率、薪资和性别薪资差距。

项目已经从最初的模拟数据版本升级为 **QILT GOS-L 2025 官方公开汇总数据版本**。

## 1. 项目主题

项目主题：

> Computing and Information Systems Graduates: Employment Outcomes and Trends Analysis

本项目重点回答：

1. CIS 毕业生和其他专业相比，就业率和薪资表现如何？
2. CIS 毕业生的男女薪资差距是否明显？
3. 不同澳洲大学的中期全职就业率和薪资有什么差异？

说明：用户 PDF 原主题是 2018-2023 年分析。当前公开下载并稳定获取到的数据是 QILT GOS-L 2025 National Report Tables，因此本项目使用 2025 真实公开汇总数据复现同类分析框架。

## 2. 数据来源

数据来自 QILT 官方公开数据：

- 数据集：Graduate Outcomes Survey - Longitudinal (GOS-L) 2025 National Report Tables
- 发布机构：Quality Indicators for Learning and Teaching (QILT)
- 官方页面：https://qilt.edu.au/surveys/graduate-outcomes-survey---longitudinal-%28gos-l%29
- 原始文件：`GOSL_2025_National_Tables_Public.xlsx`

QILT 官网说明，GOS-L 是毕业生完成学业约三年后的调查，用于衡量中期就业结果、继续学习、就业状态、薪资、职业和技能利用等情况。

## 3. 技术栈

- R：主要分析语言
- base R：数据清洗、汇总和绘图
- rpart：决策树模型
- stats：线性回归模型
- rmarkdown / knitr：生成 HTML/PDF 报告
- Python + openpyxl：只用于从 QILT 官方 Excel 中提取整洁 CSV

## 4. 项目结构

```text
.
├── README.md
├── run_analysis.R
├── R
│   ├── 00_generate_sample_data.R
│   ├── 01_clean_data.R
│   ├── 02_feature_engineering.R
│   └── 03_modeling.R
├── scripts
│   └── extract_qilt_gosl_2025.py
├── docs
│   └── data_sources.md
├── reports
│   └── australia_graduate_employment_report.Rmd
├── data
│   ├── raw
│   └── processed
└── outputs
    ├── figures
    ├── models
    └── tables
```

## 5. 如何运行

如果已经下载并解压了官方 Excel，可以直接运行：

```bash
Rscript run_analysis.R
```

如果需要重新从 Excel 提取 CSV，先运行：

```bash
python3 scripts/extract_qilt_gosl_2025.py
```

然后再运行：

```bash
Rscript run_analysis.R
```

## 6. 运行后生成的内容

- `data/raw/qilt_extracted/`：从官方 Excel 提取出来的整洁 CSV
- `data/processed/qilt_gosl_2025_area_features.csv`：清洗和特征工程后的专业领域数据
- `outputs/tables/cis_summary.csv`：CIS 专业核心结果
- `outputs/tables/gender_pay_gap_by_field.csv`：按专业计算的性别薪资差距
- `outputs/tables/institutional_summary.csv`：大学层面的就业率和薪资
- `outputs/models/salary_regression_model.rds`：中期薪资回归模型
- `outputs/models/best_employment_model.rds`：高薪专业决策树模型
- `outputs/figures/`：就业率、薪资、性别薪资差距和特征重要性图表
- `reports/australia_graduate_employment_report.html`：最终 HTML 报告

## 7. 当前核心发现

根据 QILT GOS-L 2025 真实公开汇总数据：

- CIS 本科毕业生中期全职就业率为 91.0%
- CIS 本科毕业生中期总体就业率为 92.0%
- CIS 本科毕业生中期薪资中位数为 100,000 AUD
- CIS 男性中期薪资中位数为 103,000 AUD
- CIS 女性中期薪资中位数为 94,000 AUD
- CIS 中期性别薪资差距约为 8.7%

## 8. 注意事项

当前数据是官方公开汇总表，不是个人级调查原始数据。因此项目适合做课程展示、描述性统计、专业对比、性别薪资差距和简单模型分析；不适合声称做了个人级因果分析。

