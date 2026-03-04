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

main <- function(seed = 123) {
  # Assume working directory is the project root
  processed_dir <- file.path("data", "processed")

  combined_path <- file.path(processed_dir, "winequality-combined.csv")

  if (!file.exists(combined_path)) {
    stop("Combined dataset not found at: ", combined_path)
  }

  data <- read_csv(combined_path, show_col_types = FALSE)

  set.seed(seed)
  n <- nrow(data)
  train_idx <- sample(seq_len(n), size = floor(0.8 * n))

  train <- data[train_idx, ]
  test <- data[-train_idx, ]

  train_path <- file.path(processed_dir, "train.csv")
  test_path <- file.path(processed_dir, "test.csv")

  write_csv(train, train_path)
  write_csv(test, test_path)

  message(sprintf("Train sample written to: %s", train_path))
  message(sprintf("Test sample written to: %s", test_path))
}

if (sys.nframe() == 0) {
  main()
}

