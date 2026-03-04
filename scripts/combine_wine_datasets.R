#!/usr/bin/env Rscript

suppressMessages({
  if (!requireNamespace("readr", quietly = TRUE)) {
    install.packages("readr", repos = "https://cloud.r-project.org")
  }
  if (!requireNamespace("dplyr", quietly = TRUE)) {
    install.packages("dplyr", repos = "https://cloud.r-project.org")
  }
})

library(readr)
library(dplyr)

main <- function() {
  # Assume working directory is the project root
  raw_dir <- file.path("data", "raw")
  processed_dir <- file.path("data", "processed")

  if (!dir.exists(processed_dir)) {
    dir.create(processed_dir, recursive = TRUE)
  }

  red_path <- file.path(raw_dir, "winequality-red.csv")
  white_path <- file.path(raw_dir, "winequality-white.csv")

  # Read the datasets (semicolon-separated, quoted headers)
  red <- read_delim(red_path, delim = ";", col_types = cols())
  white <- read_delim(white_path, delim = ";", col_types = cols())

  # Add binary indicator for red wine
  red <- red %>% mutate(is_red = 1L)
  white <- white %>% mutate(is_red = 0L)

  # Combine datasets
  combined <- bind_rows(red, white)

  # Write combined dataset
  output_path <- file.path(processed_dir, "winequality-combined.csv")
  write_csv(combined, output_path)

  message(sprintf("Combined dataset written to: %s", output_path))
}

if (sys.nframe() == 0) {
  main()
}


