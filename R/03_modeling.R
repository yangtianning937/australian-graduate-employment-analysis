train_employment_models <- function(
  input_path = "data/processed/qilt_gosl_2025_area_features.csv"
) {
  library(rpart)

  dir.create("outputs/models", recursive = TRUE, showWarnings = FALSE)
  dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)
  dir.create("outputs/figures", recursive = TRUE, showWarnings = FALSE)

  area_data <- read.csv(input_path, stringsAsFactors = FALSE)
  institution_fte <- read.csv("data/processed/qilt_gosl_2025_institution_fte_clean.csv", stringsAsFactors = FALSE)
  institution_salary <- read.csv("data/processed/qilt_gosl_2025_institution_salary_clean.csv", stringsAsFactors = FALSE)

  model_data <- area_data[complete.cases(area_data[, c(
    "medium_term_median_salary_aud",
    "medium_term_full_time_employment_rate",
    "medium_term_overall_employment_rate",
    "short_term_median_salary_aud",
    "salary_growth",
    "gender_pay_gap"
  )]), ]

  salary_lm <- lm(
    medium_term_median_salary_aud ~ medium_term_full_time_employment_rate +
      medium_term_overall_employment_rate +
      short_term_median_salary_aud +
      gender_pay_gap,
    data = model_data
  )

  high_salary_tree <- rpart(
    as.factor(high_medium_salary) ~ short_term_full_time_employment_rate +
      medium_term_full_time_employment_rate +
      short_term_overall_employment_rate +
      medium_term_overall_employment_rate +
      salary_growth +
      gender_pay_gap +
      is_stem_related,
    data = model_data,
    method = "class"
  )

  salary_prediction <- predict(salary_lm, newdata = model_data)
  salary_rmse <- sqrt(mean((salary_prediction - model_data$medium_term_median_salary_aud)^2))
  salary_mae <- mean(abs(salary_prediction - model_data$medium_term_median_salary_aud))

  model_comparison <- data.frame(
    model = c("linear_regression_salary_model", "decision_tree_high_salary_model"),
    task = c("Predict medium-term median salary", "Classify whether field has high medium-term salary"),
    metric = c("RMSE", "Training accuracy"),
    value = c(
      round(salary_rmse, 2),
      round(mean(predict(high_salary_tree, newdata = model_data, type = "class") == model_data$high_medium_salary), 4)
    )
  )

  saveRDS(salary_lm, "outputs/models/salary_regression_model.rds")
  saveRDS(high_salary_tree, "outputs/models/best_employment_model.rds")
  write.csv(model_comparison, "outputs/tables/model_comparison.csv", row.names = FALSE)

  coef_table <- summary(salary_lm)$coefficients
  feature_importance <- data.frame(
    feature = rownames(coef_table),
    importance = abs(coef_table[, "t value"]),
    row.names = NULL
  )
  feature_importance <- feature_importance[feature_importance$feature != "(Intercept)", ]
  feature_importance <- feature_importance[order(-feature_importance$importance), ]
  write.csv(feature_importance, "outputs/tables/feature_importance.csv", row.names = FALSE)

  write.csv(
    area_data[order(-area_data$medium_term_full_time_employment_rate), ],
    "outputs/tables/employment_by_field_year.csv",
    row.names = FALSE
  )
  write.csv(
    area_data[order(-area_data$medium_term_median_salary_aud), ],
    "outputs/tables/salary_by_field.csv",
    row.names = FALSE
  )

  cis_summary <- area_data[area_data$is_cis == "Yes", ]
  write.csv(cis_summary, "outputs/tables/cis_summary.csv", row.names = FALSE)

  gender_gap <- area_data[, c(
    "field_of_education",
    "male_medium_salary_aud",
    "female_medium_salary_aud",
    "gender_pay_gap"
  )]
  gender_gap <- gender_gap[order(-gender_gap$gender_pay_gap), ]
  write.csv(gender_gap, "outputs/tables/gender_pay_gap_stem.csv", row.names = FALSE)
  write.csv(gender_gap, "outputs/tables/gender_pay_gap_by_year.csv", row.names = FALSE)

  institution_summary <- merge(
    institution_fte,
    institution_salary,
    by = c("source", "survey_year", "cohort", "institution"),
    all = TRUE
  )
  institution_summary <- institution_summary[order(-institution_summary$medium_term_median_salary_aud), ]
  write.csv(institution_summary, "outputs/tables/institutional_summary.csv", row.names = FALSE)
  write.csv(institution_summary, "outputs/tables/regional_summary.csv", row.names = FALSE)

  numeric_data <- area_data[, c(
    "short_term_full_time_employment_rate",
    "medium_term_full_time_employment_rate",
    "short_term_overall_employment_rate",
    "medium_term_overall_employment_rate",
    "short_term_median_salary_aud",
    "medium_term_median_salary_aud",
    "salary_growth",
    "gender_pay_gap"
  )]
  correlation_table <- round(cor(numeric_data, use = "pairwise.complete.obs"), 4)
  write.csv(correlation_table, "outputs/tables/correlation_table.csv")

  png("outputs/figures/employment_rate_by_field_year.png", width = 1100, height = 700)
  ordered <- area_data[order(area_data$medium_term_full_time_employment_rate), ]
  par(mar = c(5, 14, 4, 2))
  barplot(
    ordered$medium_term_full_time_employment_rate,
    names.arg = ordered$field_of_education,
    horiz = TRUE,
    las = 1,
    col = ifelse(ordered$is_cis == "Yes", "#2f6f73", "#8aa6a3"),
    main = "QILT GOS-L 2025: Medium-term Full-time Employment by Study Area",
    xlab = "Full-time employment rate (%)",
    cex.names = 0.65
  )
  dev.off()

  png("outputs/figures/overall_employment_by_field.png", width = 1100, height = 700)
  ordered_overall <- area_data[order(area_data$medium_term_overall_employment_rate), ]
  par(mar = c(5, 14, 4, 2))
  barplot(
    ordered_overall$medium_term_overall_employment_rate,
    names.arg = ordered_overall$field_of_education,
    horiz = TRUE,
    las = 1,
    col = ifelse(ordered_overall$is_cis == "Yes", "#2f6f73", "#9fb8b2"),
    main = "QILT GOS-L 2025: Medium-term Overall Employment by Study Area",
    xlab = "Overall employment rate (%)",
    cex.names = 0.65
  )
  dev.off()

  png("outputs/figures/salary_by_field.png", width = 1100, height = 700)
  salary_ordered <- area_data[order(area_data$medium_term_median_salary_aud), ]
  par(mar = c(5, 14, 4, 2))
  barplot(
    salary_ordered$medium_term_median_salary_aud,
    names.arg = salary_ordered$field_of_education,
    horiz = TRUE,
    las = 1,
    col = ifelse(salary_ordered$is_cis == "Yes", "#2f6f73", "#c3a15f"),
    main = "QILT GOS-L 2025: Medium-term Median Salary by Study Area",
    xlab = "Median salary (AUD)",
    cex.names = 0.65
  )
  dev.off()

  png("outputs/figures/salary_growth_by_field.png", width = 1100, height = 700)
  growth_ordered <- area_data[order(area_data$salary_growth), ]
  par(mar = c(5, 14, 4, 2))
  barplot(
    growth_ordered$salary_growth,
    names.arg = growth_ordered$field_of_education,
    horiz = TRUE,
    las = 1,
    col = ifelse(growth_ordered$is_cis == "Yes", "#2f6f73", "#8f9f6f"),
    main = "QILT GOS-L 2025: Salary Growth from Short-term to Medium-term",
    xlab = "Salary growth (AUD)",
    cex.names = 0.65
  )
  dev.off()

  png("outputs/figures/employment_salary_scatter.png", width = 950, height = 650)
  point_colours <- ifelse(area_data$is_cis == "Yes", "#c4513b", ifelse(area_data$is_stem_related == "Yes", "#2f6f73", "#8aa6a3"))
  par(mar = c(5, 5, 4, 2))
  plot(
    area_data$medium_term_full_time_employment_rate,
    area_data$medium_term_median_salary_aud,
    pch = 19,
    col = point_colours,
    xlab = "Medium-term full-time employment rate (%)",
    ylab = "Medium-term median salary (AUD)",
    main = "Employment Rate and Salary by Study Area"
  )
  text(
    area_data$medium_term_full_time_employment_rate,
    area_data$medium_term_median_salary_aud,
    labels = ifelse(area_data$is_cis == "Yes", "CIS", ""),
    pos = 4,
    col = "#c4513b"
  )
  legend(
    "bottomright",
    legend = c("CIS", "STEM-related", "Other"),
    col = c("#c4513b", "#2f6f73", "#8aa6a3"),
    pch = 19,
    bty = "n"
  )
  dev.off()

  png("outputs/figures/cis_gender_pay_gap.png", width = 950, height = 650)
  gap_ordered <- gender_gap[order(gender_gap$gender_pay_gap), ]
  par(mar = c(5, 14, 4, 2))
  barplot(
    gap_ordered$gender_pay_gap * 100,
    names.arg = gap_ordered$field_of_education,
    horiz = TRUE,
    las = 1,
    col = ifelse(gap_ordered$field_of_education == "Computing and information systems", "#2f6f73", "#b7a77d"),
    main = "QILT GOS-L 2025: Medium-term Gender Pay Gap by Study Area",
    xlab = "Gender pay gap (%)",
    cex.names = 0.65
  )
  dev.off()

  png("outputs/figures/stem_gender_pay_gap.png", width = 950, height = 650)
  stem_gap <- merge(
    gender_gap,
    area_data[, c("field_of_education", "is_stem_related", "is_cis")],
    by = "field_of_education",
    all.x = TRUE
  )
  stem_gap <- stem_gap[stem_gap$is_stem_related == "Yes", ]
  stem_gap <- stem_gap[order(stem_gap$gender_pay_gap), ]
  par(mar = c(5, 14, 4, 2))
  barplot(
    stem_gap$gender_pay_gap * 100,
    names.arg = stem_gap$field_of_education,
    horiz = TRUE,
    las = 1,
    col = ifelse(stem_gap$is_cis == "Yes", "#2f6f73", "#b7a77d"),
    main = "QILT GOS-L 2025: Gender Pay Gap in STEM-related Study Areas",
    xlab = "Gender pay gap (%)",
    cex.names = 0.75
  )
  dev.off()

  png("outputs/figures/regional_salary_employment.png", width = 1000, height = 700)
  top_institutions <- head(institution_summary[order(-institution_summary$medium_term_median_salary_aud), ], 15)
  par(mar = c(5, 14, 4, 2))
  barplot(
    rev(top_institutions$medium_term_median_salary_aud),
    names.arg = rev(top_institutions$institution),
    horiz = TRUE,
    las = 1,
    col = "#6b8e9b",
    main = "QILT GOS-L 2025: Top University Median Salaries",
    xlab = "Median salary (AUD)",
    cex.names = 0.75
  )
  dev.off()

  png("outputs/figures/feature_importance.png", width = 900, height = 600)
  top_importance <- head(feature_importance, 8)
  par(mar = c(5, 12, 4, 2))
  barplot(
    rev(top_importance$importance),
    names.arg = rev(top_importance$feature),
    horiz = TRUE,
    las = 1,
    col = "#2f6f73",
    main = "Salary Model Feature Importance",
    xlab = "Absolute t value",
    cex.names = 0.8
  )
  dev.off()

  message("已完成 QILT 真实数据分析和建模。")
}
