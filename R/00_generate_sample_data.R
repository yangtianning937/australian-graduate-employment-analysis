generate_sample_data <- function(
  area_path = "data/raw/qilt_extracted/qilt_gosl_2025_area_summary.csv",
  gender_path = "data/raw/qilt_extracted/qilt_gosl_2025_gender_summary.csv",
  institution_fte_path = "data/raw/qilt_extracted/qilt_gosl_2025_institution_fte.csv",
  institution_salary_path = "data/raw/qilt_extracted/qilt_gosl_2025_institution_salary.csv",
  output_path = "data/raw/qilt_gosl_2025_combined.csv"
) {
  required_files <- c(area_path, gender_path, institution_fte_path, institution_salary_path)
  missing_files <- required_files[!file.exists(required_files)]

  if (length(missing_files) > 0) {
    stop(
      "缺少 QILT 提取后的 CSV 文件：\n",
      paste(missing_files, collapse = "\n"),
      "\n请先运行：python3 scripts/extract_qilt_gosl_2025.py"
    )
  }

  area_data <- read.csv(area_path, stringsAsFactors = FALSE)
  gender_data <- read.csv(gender_path, stringsAsFactors = FALSE)
  institution_fte <- read.csv(institution_fte_path, stringsAsFactors = FALSE)
  institution_salary <- read.csv(institution_salary_path, stringsAsFactors = FALSE)

  dir.create(dirname(output_path), recursive = TRUE, showWarnings = FALSE)
  write.csv(area_data, output_path, row.names = FALSE)

  saveRDS(
    list(
      area_data = area_data,
      gender_data = gender_data,
      institution_fte = institution_fte,
      institution_salary = institution_salary
    ),
    "data/raw/qilt_gosl_2025_raw_tables.rds"
  )

  message("已加载 QILT 真实公开数据：", output_path)
}

