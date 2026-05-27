# 一键运行完整分析流程
# 运行方式：在 R 或 RStudio 中执行 source("run_analysis.R")

required_packages <- c("rpart", "rmarkdown", "knitr")
missing_packages <- required_packages[!required_packages %in% rownames(installed.packages())]

if (length(missing_packages) > 0) {
  stop(
    "缺少必要 R 包：",
    paste(missing_packages, collapse = ", "),
    "\n请先在 R 中运行 install.packages(c(",
    paste(sprintf("\"%s\"", missing_packages), collapse = ", "),
    "))"
  )
}

source("R/00_generate_sample_data.R")
source("R/01_clean_data.R")
source("R/02_feature_engineering.R")
source("R/03_modeling.R")
source("R/04_create_dashboard.R")

generate_sample_data()
clean_employment_data()
create_employment_features()
train_employment_models()
create_portfolio_dashboard()

if (!rmarkdown::pandoc_available()) {
  rstudio_pandoc_paths <- c(
    "/Applications/RStudio.app/Contents/Resources/app/quarto/bin/tools/aarch64",
    "/Applications/RStudio.app/Contents/Resources/app/quarto/bin/tools/x86_64"
  )
  existing_pandoc_paths <- rstudio_pandoc_paths[file.exists(file.path(rstudio_pandoc_paths, "pandoc"))]
  if (length(existing_pandoc_paths) > 0) {
    Sys.setenv(RSTUDIO_PANDOC = existing_pandoc_paths[1])
  }
}

if (rmarkdown::pandoc_available()) {
  rmarkdown::render(
    input = "reports/australia_graduate_employment_report.Rmd",
    output_format = "html_document",
    output_file = "australia_graduate_employment_report.html",
    quiet = TRUE
  )
  message("分析完成。请查看 outputs/ 文件夹和 reports/australia_graduate_employment_report.html。")
} else {
  message("分析完成。当前电脑没有检测到 pandoc，所以暂时没有自动生成 HTML。")
  message("请在 RStudio 中打开 reports/australia_graduate_employment_report.Rmd，然后点击 Knit 生成 HTML/PDF。")
}
