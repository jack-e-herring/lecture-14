#!/usr/bin/env Rscript

suppressMessages({
  if (!requireNamespace("readr", quietly = TRUE)) {
    install.packages("readr", repos = "https://cloud.r-project.org")
  }
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    install.packages("ggplot2", repos = "https://cloud.r-project.org")
  }
})

library(readr)
library(ggplot2)

main <- function() {
  # Assume working directory is the project root
  train_path <- file.path("data", "processed", "train.csv")

  if (!file.exists(train_path)) {
    stop("Train dataset not found at: ", train_path)
  }

  data <- read_csv(train_path, show_col_types = FALSE)

  output_dir <- file.path("outputs", "figures")
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }

  for (var in names(data)) {
    x <- data[[var]]

    p <- if (is.numeric(x)) {
      ggplot(data, aes(x = .data[[var]])) +
        geom_histogram(bins = 30, color = "white", fill = "steelblue") +
        labs(title = paste("Histogram of", var), x = var, y = "Frequency") +
        theme_minimal()
    } else {
      ggplot(data, aes(x = .data[[var]])) +
        geom_bar(fill = "steelblue") +
        labs(title = paste("Frequency of", var), x = var, y = "Count") +
        theme_minimal()
    }

    file_name <- paste0("freq_", var, ".pdf")
    file_path <- file.path(output_dir, file_name)

    ggsave(filename = file_path, plot = p, width = 6, height = 4)
  }

  message("Frequency plots written to: ", output_dir)
}

if (sys.nframe() == 0) {
  main()
}

