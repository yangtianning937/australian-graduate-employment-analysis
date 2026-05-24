clean_employment_data <- function(
  input_path = "data/raw/qilt_gosl_2025_raw_tables.rds",
  output_path = "data/processed/qilt_gosl_2025_area_clean.csv"
) {
  if (!file.exists(input_path)) {
    stop("缺少原始表格 RDS，请先运行 generate_sample_data()。")
  }

  dir.create(dirname(output_path), recursive = TRUE, showWarnings = FALSE)

  raw_tables <- readRDS(input_path)

  clean_rate <- function(x) {
    x <- as.numeric(x)
    x[x < 0 | x > 100] <- NA
    x
  }

  clean_salary <- function(x) {
    x <- as.numeric(x)
    x[x <= 0 | x > 250000] <- NA
    x
  }

  area_data <- raw_tables$area_data
  rate_columns <- grep("employment_rate|participation_rate", names(area_data), value = TRUE)
  salary_columns <- grep("salary", names(area_data), value = TRUE)
  area_data[rate_columns] <- lapply(area_data[rate_columns], clean_rate)
  area_data[salary_columns] <- lapply(area_data[salary_columns], clean_salary)
  area_data <- unique(area_data)

  gender_data <- raw_tables$gender_data
  gender_rate_columns <- grep("employment_rate", names(gender_data), value = TRUE)
  gender_salary_columns <- grep("salary", names(gender_data), value = TRUE)
  gender_data[gender_rate_columns] <- lapply(gender_data[gender_rate_columns], clean_rate)
  gender_data[gender_salary_columns] <- lapply(gender_data[gender_salary_columns], clean_salary)
  gender_data <- unique(gender_data)

  institution_fte <- unique(raw_tables$institution_fte)
  institution_salary <- unique(raw_tables$institution_salary)

  write.csv(area_data, output_path, row.names = FALSE)
  write.csv(gender_data, "data/processed/qilt_gosl_2025_gender_clean.csv", row.names = FALSE)
  write.csv(institution_fte, "data/processed/qilt_gosl_2025_institution_fte_clean.csv", row.names = FALSE)
  write.csv(institution_salary, "data/processed/qilt_gosl_2025_institution_salary_clean.csv", row.names = FALSE)

  saveRDS(
    list(
      area_data = area_data,
      gender_data = gender_data,
      institution_fte = institution_fte,
      institution_salary = institution_salary
    ),
    "data/processed/qilt_gosl_2025_clean_tables.rds"
  )

  message("已完成 QILT 数据清洗：", output_path)
}

