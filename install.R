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
  "pbdZMQ" = "0.3-13",
  "IRkernel" = "1.3.2",         # required for jupyter R kernel
  "knitr" = "1.49",
  "rmarkdown" = "2.29",
  "mvtnorm" = "1.3-3"
)

install_packages_with_versions(packages)

IRkernel::installspec(prefix='${CONDA_DIR}')
