#!/usr/bin/Rscript

# Function to install R packages
install_packages_with_versions <- function(packages) {
  available <- available.packages()
  to_install <- names(packages)[!(names(packages) %in% rownames(installed.packages()))]

  if (length(to_install) > 0) {
    install.packages(to_install, available = available,
                     versions = packages[to_install],
                     dependencies = TRUE)
  } else {
    cat("All packages are already installed.\n")
  }
}

# List of packages to ensure are installed
required_packages <- c("remotes", "devtools")

# Check and install required packages
new_packages <- required_packages[!sapply(required_packages, requireNamespace, quietly = TRUE)]
if (length(new_packages) > 0) {
  install.packages(new_packages)
}

packages = list(
  "GGally" = "2.2.1",
  "IRkernel" = "1.3.2",         # required for jupyter R kernel
  "ISLR" = "1.4",
  "knitr" = "1.49",
  "LiblineaR" = "2.10-24",
  "ModelMetrics" = "1.2.2.2",
  "caret" = "7.0-1",
  "class" = "7.3-23",
  "dplyr" = "1.1.4",
  "dummies" = "1.5.6",
  "ggplot2" = "3.5.1",
  "glmnet" = "4.1-8",
  "gridExtra" = "2.3",
  "mclust" = "6.1.1",
  "pbdZMQ" = "0.3-13",
  "plyr" = "1.8.9",
  "rmarkdown" = "2.29",
  "sandwich" = "3.1-1",
  "tidyverse" = "2.0.0",
  "mvtnorm" = "1.3-3"
)

install_packages_with_versions(packages)

IRkernel::installspec(prefix='${CONDA_DIR}')
