create_portfolio_dashboard <- function(
  input_path = "data/processed/qilt_gosl_2025_area_features.csv",
  output_path = "outputs/figures/portfolio_dashboard.png"
) {
  dir.create(dirname(output_path), recursive = TRUE, showWarnings = FALSE)

  area_data <- read.csv(input_path, stringsAsFactors = FALSE)
  cis_data <- area_data[area_data$is_cis == "Yes", ]

  png(output_path, width = 1500, height = 950, res = 120)
  par(bg = "#f7f8f5", mar = c(0, 0, 0, 0), oma = c(0, 0, 0, 0))
  plot.new()

  rect(0, 0, 1, 1, col = "#f7f8f5", border = NA)
  text(
    0.04, 0.95,
    "Australian Graduate Employment Outcomes",
    adj = 0,
    cex = 2.1,
    font = 2,
    col = "#243b3b"
  )
  text(
    0.04, 0.91,
    "QILT GOS-L 2025 portfolio dashboard | Focus: Computing and Information Systems",
    adj = 0,
    cex = 0.95,
    col = "#536261"
  )

  card <- function(x1, y1, x2, y2, title, value, subtitle, fill = "#ffffff") {
    rect(x1, y1, x2, y2, col = fill, border = "#d8ded8", lwd = 1.2)
    text(x1 + 0.018, y2 - 0.032, title, adj = 0, cex = 0.78, col = "#536261")
    text(x1 + 0.018, y1 + 0.072, value, adj = 0, cex = 1.45, font = 2, col = "#2f6f73")
    text(x1 + 0.018, y1 + 0.028, subtitle, adj = 0, cex = 0.72, col = "#6d7775")
  }

  card(0.04, 0.75, 0.25, 0.87, "Medium-term full-time employment", "91.0%", "CIS graduates")
  card(0.27, 0.75, 0.48, 0.87, "Medium-term median salary", "AUD 100k", "CIS graduates")
  card(0.50, 0.75, 0.71, 0.87, "Salary growth", "AUD 30.9k", "Short-term to medium-term")
  card(0.73, 0.75, 0.94, 0.87, "Gender pay gap", "8.7%", "CIS medium-term salaries")

  salary_top <- head(area_data[order(-area_data$medium_term_median_salary_aud), ], 8)
  employment_top <- head(area_data[order(-area_data$medium_term_full_time_employment_rate), ], 8)

  par(fig = c(0.05, 0.48, 0.38, 0.69), new = TRUE, mar = c(4, 11, 3, 1), bg = "#ffffff")
  barplot(
    rev(salary_top$medium_term_median_salary_aud),
    names.arg = rev(salary_top$field_of_education),
    horiz = TRUE,
    las = 1,
    col = ifelse(rev(salary_top$is_cis) == "Yes", "#2f6f73", "#c3a15f"),
    border = NA,
    main = "Top Study Areas by Median Salary",
    xlab = "AUD",
    cex.names = 0.68,
    cex.main = 1
  )
  box(col = "#d8ded8")

  par(fig = c(0.54, 0.95, 0.38, 0.69), new = TRUE, mar = c(4, 11, 3, 1), bg = "#ffffff")
  barplot(
    rev(employment_top$medium_term_full_time_employment_rate),
    names.arg = rev(employment_top$field_of_education),
    horiz = TRUE,
    las = 1,
    col = ifelse(rev(employment_top$is_cis) == "Yes", "#2f6f73", "#8aa6a3"),
    border = NA,
    main = "Top Study Areas by Full-time Employment",
    xlab = "Employment rate (%)",
    cex.names = 0.68,
    cex.main = 1
  )
  box(col = "#d8ded8")

  par(fig = c(0.08, 0.56, 0.07, 0.31), new = TRUE, mar = c(4, 4, 3, 1), bg = "#ffffff")
  point_colours <- ifelse(area_data$is_cis == "Yes", "#c4513b", ifelse(area_data$is_stem_related == "Yes", "#2f6f73", "#8aa6a3"))
  plot(
    area_data$medium_term_full_time_employment_rate,
    area_data$medium_term_median_salary_aud,
    pch = 19,
    col = point_colours,
    xlab = "Medium-term full-time employment (%)",
    ylab = "Median salary (AUD)",
    main = "Employment and Salary Relationship"
  )
  text(
    cis_data$medium_term_full_time_employment_rate,
    cis_data$medium_term_median_salary_aud,
    labels = "CIS",
    pos = 4,
    col = "#c4513b",
    font = 2
  )
  box(col = "#d8ded8")

  gender_gap <- area_data[complete.cases(area_data$gender_pay_gap), ]
  stem_gap <- gender_gap[gender_gap$is_stem_related == "Yes", ]
  stem_gap <- stem_gap[order(stem_gap$gender_pay_gap), ]

  par(fig = c(0.64, 0.95, 0.07, 0.31), new = TRUE, mar = c(4, 8, 3, 1), bg = "#ffffff")
  barplot(
    stem_gap$gender_pay_gap * 100,
    names.arg = stem_gap$field_of_education,
    horiz = TRUE,
    las = 1,
    col = ifelse(stem_gap$is_cis == "Yes", "#2f6f73", "#b7a77d"),
    border = NA,
    main = "STEM-related Gender Pay Gap",
    xlab = "Pay gap (%)",
    cex.names = 0.7,
    cex.main = 1
  )
  box(col = "#d8ded8")

  dev.off()
  message("已生成作品集仪表盘：", output_path)
}

