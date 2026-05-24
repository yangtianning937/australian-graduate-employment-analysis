create_employment_features <- function(
  input_path = "data/processed/qilt_gosl_2025_clean_tables.rds",
  output_path = "data/processed/qilt_gosl_2025_area_features.csv"
) {
  if (!file.exists(input_path)) {
    stop("缺少清洗后的表格 RDS，请先运行 clean_employment_data()。")
  }

  clean_tables <- readRDS(input_path)
  area_data <- clean_tables$area_data
  gender_data <- clean_tables$gender_data

  stem_fields <- c(
    "Computing and information systems",
    "Engineering",
    "Science and mathematics",
    "Medicine",
    "Nursing",
    "Pharmacy",
    "Veterinary science",
    "Dentistry",
    "Health services and support",
    "Rehabilitation"
  )

  area_data$is_cis <- ifelse(area_data$field_of_education == "Computing and information systems", "Yes", "No")
  area_data$is_stem_related <- ifelse(area_data$field_of_education %in% stem_fields, "Yes", "No")
  area_data$full_time_employment_growth <- area_data$medium_term_full_time_employment_rate -
    area_data$short_term_full_time_employment_rate
  area_data$overall_employment_growth <- area_data$medium_term_overall_employment_rate -
    area_data$short_term_overall_employment_rate
  area_data$salary_growth <- area_data$medium_term_median_salary_aud -
    area_data$short_term_median_salary_aud
  area_data$salary_growth_rate <- area_data$salary_growth / area_data$short_term_median_salary_aud
  area_data$high_medium_salary <- ifelse(
    area_data$medium_term_median_salary_aud >= median(area_data$medium_term_median_salary_aud, na.rm = TRUE),
    "Yes",
    "No"
  )

  male_data <- gender_data[gender_data$gender == "Male", c("field_of_education", "medium_term_median_salary_aud")]
  female_data <- gender_data[gender_data$gender == "Female", c("field_of_education", "medium_term_median_salary_aud")]
  names(male_data)[2] <- "male_medium_salary_aud"
  names(female_data)[2] <- "female_medium_salary_aud"

  gender_pay_gap <- merge(male_data, female_data, by = "field_of_education", all = TRUE)
  gender_pay_gap$gender_pay_gap <- (
    gender_pay_gap$male_medium_salary_aud - gender_pay_gap$female_medium_salary_aud
  ) / gender_pay_gap$male_medium_salary_aud

  area_data <- merge(area_data, gender_pay_gap, by = "field_of_education", all.x = TRUE)

  write.csv(area_data, output_path, row.names = FALSE)
  write.csv(gender_pay_gap, "outputs/tables/gender_pay_gap_by_field.csv", row.names = FALSE)
  saveRDS(area_data, "data/processed/qilt_gosl_2025_area_features.rds")

  message("已完成 QILT 特征工程：", output_path)
}

