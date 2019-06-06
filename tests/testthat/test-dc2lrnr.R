context("Convert a DC repo into a learnr package")

dc_repo <- fs::path(output_dir, "dc-course")
lrnr_pkg_name <- "acd.course"
lrnr_pkg <- fs::path(output_dir, lrnr_pkg_name)

test_that("DataCamp repo is converted to a package", {
  datacamp_to_learnr_pkg(dc_repo, lrnr_pkg, "TEST RUN")
  expect_true(fs::dir_exists(lrnr_pkg))
})
