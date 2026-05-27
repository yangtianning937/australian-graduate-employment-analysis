run_data_quality_checks <- function(
  input_path = "data/processed/qilt_gosl_2025_area_features.csv",
  institution_path = "outputs/tables/institutional_summary.csv",
  output_path = "outputs/tables/data_quality_checks.csv"
) {
  dir.create(dirname(output_path), recursive = TRUE, showWarnings = FALSE)

  area_data <- read.csv(input_path, stringsAsFactors = FALSE)
  institution_data <- read.csv(institution_path, stringsAsFactors = FALSE)

  check_result <- function(check_name, dataset, result, details) {
    data.frame(
      check_name = check_name,
      dataset = dataset,
      result = result,
      details = details,
      stringsAsFactors = FALSE
    )
  }

  rate_columns <- grep("employment_rate|participation_rate", names(area_data), value = TRUE)
  salary_columns <- grep("salary_aud$|salary_growth$", names(area_data), value = TRUE)

  checks <- list()

  checks[[length(checks) + 1]] <- check_result(
    "Area row count",
    "qilt_gosl_2025_area_features",
    ifelse(nrow(area_data) > 0, "PASS", "FAIL"),
    paste("Rows:", nrow(area_data))
  )

  checks[[length(checks) + 1]] <- check_result(
    "Institution row count",
    "institutional_summary",
    ifelse(nrow(institution_data) > 0, "PASS", "FAIL"),
    paste("Rows:", nrow(institution_data))
  )

  duplicate_area_rows <- sum(duplicated(area_data))
  checks[[length(checks) + 1]] <- check_result(
    "Duplicate area rows",
    "qilt_gosl_2025_area_features",
    ifelse(duplicate_area_rows == 0, "PASS", "WARN"),
    paste("Duplicate rows:", duplicate_area_rows)
  )

  missing_cis <- sum(area_data$is_cis == "Yes", na.rm = TRUE)
  checks[[length(checks) + 1]] <- check_result(
    "CIS record exists",
    "qilt_gosl_2025_area_features",
    ifelse(missing_cis == 1, "PASS", "FAIL"),
    paste("CIS rows:", missing_cis)
  )

  for (column in rate_columns) {
    invalid_count <- sum(area_data[[column]] < 0 | area_data[[column]] > 100, na.rm = TRUE)
    missing_count <- sum(is.na(area_data[[column]]))
    checks[[length(checks) + 1]] <- check_result(
      paste("Rate range:", column),
      "qilt_gosl_2025_area_features",
      ifelse(invalid_count == 0, "PASS", "FAIL"),
      paste("Invalid:", invalid_count, "| Missing:", missing_count)
    )
  }

  for (column in salary_columns) {
    invalid_count <- sum(area_data[[column]] <= 0 | area_data[[column]] > 250000, na.rm = TRUE)
    missing_count <- sum(is.na(area_data[[column]]))
    checks[[length(checks) + 1]] <- check_result(
      paste("Salary range:", column),
      "qilt_gosl_2025_area_features",
      ifelse(invalid_count == 0, "PASS", "FAIL"),
      paste("Invalid:", invalid_count, "| Missing:", missing_count)
    )
  }

  institution_missing_salary <- sum(is.na(institution_data$medium_term_median_salary_aud))
  checks[[length(checks) + 1]] <- check_result(
    "Institution salary completeness",
    "institutional_summary",
    ifelse(institution_missing_salary == 0, "PASS", "WARN"),
    paste("Missing salaries:", institution_missing_salary)
  )

  institution_missing_fte <- sum(is.na(institution_data$medium_term_full_time_employment_rate))
  checks[[length(checks) + 1]] <- check_result(
    "Institution employment completeness",
    "institutional_summary",
    ifelse(institution_missing_fte == 0, "PASS", "WARN"),
    paste("Missing full-time employment rates:", institution_missing_fte)
  )

  quality_checks <- do.call(rbind, checks)
  write.csv(quality_checks, output_path, row.names = FALSE)

  message("已生成数据质量检查结果：", output_path)
}
