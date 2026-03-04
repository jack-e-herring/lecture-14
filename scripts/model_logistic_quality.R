#!/usr/bin/env Rscript

# Load and, if necessary, install required packages
source(file.path("src", "setup_packages.R"))

library(tidyverse)
library(tidymodels)

main <- function(seed = 123) {
  # Assume working directory is the project root
  train_path <- file.path("data", "processed", "train.csv")

  if (!file.exists(train_path)) {
    stop("Train dataset not found at: ", train_path)
  }

  # Read data
  data <- readr::read_csv(train_path, show_col_types = FALSE)

  # Treat quality as a categorical outcome
  data <- data %>%
    mutate(quality = as.factor(quality))

  set.seed(seed)

  # 5-fold cross-validation splits
  folds <- vfold_cv(data, v = 5, strata = quality)

  # Recipe: use all other variables as predictors
  rec <- recipe(quality ~ ., data = data) %>%
    step_zv(all_predictors()) %>%
    step_normalize(all_predictors())

  # Multinomial logistic regression model
  log_mod <- multinom_reg(mode = "classification") %>%
    set_engine("nnet")

  wf <- workflow() %>%
    add_model(log_mod) %>%
    add_recipe(rec)

  # 5-fold CV assessment
  metrics <- metric_set(accuracy, kap)

  res <- fit_resamples(
    wf,
    resamples = folds,
    metrics = metrics,
    control = control_resamples(save_pred = TRUE)
  )

  summary_metrics <- collect_metrics(res)
  print(summary_metrics)
}

if (sys.nframe() == 0) {
  main()
}

