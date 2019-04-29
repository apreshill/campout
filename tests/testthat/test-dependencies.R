context("Package dependency extraction")

test_that("dependencies are extracted", {
    actual_deps <- extract_rpkg_deps("requirements.R")
    expected_deps <- c("ggplot2", "dplyr", "tidyr", "dagitty", "glue")
    expect_identical(actual_deps, expected_deps)
})
