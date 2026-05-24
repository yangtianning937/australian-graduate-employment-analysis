# 数据来源说明

本项目使用 QILT 官方公开数据：

- 数据名称：Graduate Outcomes Survey - Longitudinal (GOS-L) 2025 National Report Tables
- 发布机构：Quality Indicators for Learning and Teaching (QILT)
- 官方页面：https://qilt.edu.au/surveys/graduate-outcomes-survey---longitudinal-%28gos-l%29
- 下载文件：`GOSL_2025_National_Tables_Public.xlsx`

QILT 官网说明，GOS-L 是毕业生完成学业约三年后的纵向调查，用于衡量中期就业结果和继续学习情况。官方页面还说明，GOS-L 包含就业状态、薪资、职业和技能利用等信息。

## 本项目使用的数据表

由于公开下载的数据是汇总报告表，而不是个人级原始调查数据，本项目从官方 Excel 中提取了以下表格：

- `qilt_gosl_2025_area_summary.csv`：按专业领域汇总的就业率和薪资
- `qilt_gosl_2025_gender_summary.csv`：按专业领域和性别汇总的就业率和薪资
- `qilt_gosl_2025_institution_fte.csv`：按大学汇总的中期全职就业率
- `qilt_gosl_2025_institution_salary.csv`：按大学汇总的中期薪资

## 与原 PDF 的关系

用户提供的 PDF 主题是 2018-2023 年 Computing and Information Systems 毕业生就业分析。当前项目使用 QILT 2025 真实公开汇总数据来复现同类分析框架，重点仍然是：

- CIS 与其他专业的就业和薪资对比
- CIS 性别薪资差距
- 不同大学的就业率和薪资差异

需要注意的是，当前公开表格是汇总数据，不包含个人级记录，因此模型部分使用聚合指标进行简单回归分析，而不是个人级分类模型。

