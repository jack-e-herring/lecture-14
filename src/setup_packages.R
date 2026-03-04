#!/usr/bin/env Rscript

# Helper to install and load a vector of packages
install_and_load <- function(pkgs) {
  for (pkg in pkgs) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
      install.packages(pkg, repos = "https://cloud.r-project.org")
    }
    suppressPackageStartupMessages(library(pkg, character.only = TRUE))
  }
}

# Packages needed for modelling script(s)
required_pkgs <- c("tidyverse", "tidymodels")

install_and_load(required_pkgs)

