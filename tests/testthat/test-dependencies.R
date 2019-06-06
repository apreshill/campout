context("Package dependency extraction")

req_file <- fs::dir_ls(output_dir, regexp = "requirements\\.R$", recurse = TRUE)

test_that("dependencies are extracted", {
    actual_deps <- extract_rpkg_deps(req_file)
    expected_deps <- c(
      "dplyr",
      "tidyr",
      "glue",
      "purrr",
      "stringr"
    )
    expect_identical(actual_deps, expected_deps)
})

