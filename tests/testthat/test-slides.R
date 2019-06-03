context("Extracting, parsing, and modifying the slides")


# chpt_text <-
  # readr::read_lines("tests/testthat/chapter1.md")
  # dc_slides_to_text_doc("tests/testthat/chapter_1_video_1.md")
slide_file <- fs::dir_ls(output_dir, regexp = "chapter_1_video_1\\.md$", recurse = TRUE)
chpt1_slide1 <- readr::read_lines(slide_file)

test_that("projector key is extracted", {
  key <- sld_extract_key(slide_file)

  expect_equal(length(key), 1)
})

test_that("slides (as text) parsed and converted", {
  new <- str_c(fs::path_ext_remove(slide_file), "-tutorial.Rmd")
  converted_slides <- dc_slides_to_text_doc(slide_file)
  expect_type(converted_slides, "character")
  expect_true(any(str_detect(converted_slides, "``` r")))
  expect_true(sum(str_detect(converted_slides, "\\{\\{[:digit:]+\\}\\}")) == 0)

  utils_write_file(converted_slides, new)
  expect_true(fs::file_exists(new))
})
