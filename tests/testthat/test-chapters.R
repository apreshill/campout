context("Extracting, parsing, and modifying chapter text")

chapter1_file <- fs::dir_ls(fs::path(output_dir, "dc-course"),
                            regexp = "chapter1\\.md$", recurse = TRUE)
chapter2_file <- fs::dir_ls(fs::path(output_dir, "dc-course"),
                            regexp = "chapter2\\.md$", recurse = TRUE)
chapter1 <- readr::read_lines(chapter1_file)
slide_files <- fs::dir_ls(fs::path(output_dir, "dc-course"),
                          regexp = "chapter.*video.*\\.md$", recurse = TRUE)

test_that("creating an exercise tag from the chapter text", {
  exercise_name <- chapter1 %>%
    chpt_extract_exercise_name() %>%
    na.omit() %>%
    as.character()

  # Should be 9 lessons/exercises
  expect_equal(length(exercise_name), 9)
  expect_equal(exercise_name[1:2],
               c("introduction-to-cohort-studies", "what-makes-it-a-cohort"))
})

test_that("extracting the exercise type from the exercise yaml", {
  exercise_type <- chapter1 %>%
    chpt_extract_exercise_type() %>%
    na.omit() %>%
    as.character()

  # Should be 14 exercise types (since there are a few tabbed exercises)
  expect_equal(length(exercise_type), 14)
  expect_equal(exercise_type[1:2],
               c("VideoExercise", "MultipleChoiceExercise"))
})

test_that("extracting the sections within the exercise", {
  exercise_sections <- chapter1 %>%
    chpt_extract_exercise_sections() %>%
    na.omit() %>%
    as.character()

  # There are multiple sections in each exercise. Should be 46
  expect_equal(length(exercise_sections), 46)
  expect_equal(exercise_sections[1:2],
               c("projector_key", "possible_answers"))
})


test_that("hint is converted to learnr style", {
  hint_conversion <- chapter1 %>%
    chpt_exercise_to_list() %>%
    lrnr_convert_hint() %>%
    chpt_exercise_to_vector()

  expect_equal(sum(str_detect(hint_conversion, "```\\{r .*-hint-1")), 9)
  expect_equal(sum(str_detect(hint_conversion, "`@hint`")), 0)
})

test_that("code exercises are converted to learnr style", {
  code_ex_conversion <- chapter1 %>%
    chpt_exercise_to_list() %>%
    lrnr_convert_code_exercises() %>%
    chpt_exercise_to_vector()

  # Setup code chunks
  expect_equal(sum(str_detect(code_ex_conversion, "```\\{r .*-setup\\}")), 6)

  # Sample code chunks
  expect_equal(sum(
    str_detect(
      code_ex_conversion,
      "```\\{r .*, exercise=TRUE, exercise\\.setup='.*-setup'\\}"
    )
  ), 7)

  # Solution code chunks
  expect_equal(sum(str_detect(code_ex_conversion, "```\\{r .*-hint-2.*\\}")), 7)

  # Submission correction tests code chunks
  expect_equal(sum(str_detect(code_ex_conversion, "```\\{r .*-check.*\\}")), 9)
})

test_that("dashed separators are replaced with empty string", {
  with_separators <- c(letters, "", "---", letters, "", "---", "", letters, "", "---", "")
  actual_without_seps <- chpt_remove_extra_separators(with_separators)
  expected_without_seps <- c(letters, "", "---", letters, "", "", "", letters, "", "", "")

  expect_identical(actual_without_seps, expected_without_seps)
})

test_that("code backticks are replaced with empty string", {
  with_backticks <- c(letters, "```", "", letters, "", "```",
                       letters, "", "```", "", letters, "", "```", "")
  actual_without_backticks <- chpt_remove_extra_backticks(with_backticks)
  expected_without_backticks <- c(letters, "```", "", letters, "", "```",
                                  letters, "", "", "", letters, "", "", "")

  expect_identical(actual_without_backticks, expected_without_backticks)
})

test_that("MCQ are added", {
  with_mcq <- chapter1 %>%
    chpt_exercise_to_list() %>%
    lrnr_convert_mcq_exercises() %>%
    chpt_exercise_to_vector()

  num_responses <- with_mcq %>%
    str_detect("answer\\(") %>%
    sum()
  expect_equal(num_responses, 8)

  num_questions <- with_mcq %>%
    str_detect("question\\(") %>%
    sum()
  expect_equal(num_questions, 2)
})

test_that("projector key is extracted and slides inserted", {
  key <- chpt_extract_projector_key(chapter1)
  expect_equal(length(key), 3)

  added_slide_as_text <- chapter1 %>%
    chpt_insert_slides_text(slide_files)

  number_child_chunks <- added_slide_as_text %>%
    str_detect("r, child=") %>%
    sum()

  expect_equal(number_child_chunks, 3)
})

test_that("chapter is converted to tutorial", {
  # Chapter 1
  new <- str_c(fs::path_ext_remove(chapter1_file), "-tutorial.Rmd")
  converted_chpt <- dc_chapter_to_lrnr_tutorial(chapter1_file)
  expect_type(converted_chpt, "character")

  utils_write_file(converted_chpt, new)
  expect_true(fs::file_exists(new))

  # Chapter 2
  new <- str_c(fs::path_ext_remove(chapter2_file), "-tutorial.Rmd")
  converted_chpt <- dc_chapter_to_lrnr_tutorial(chapter2_file)
  expect_type(converted_chpt, "character")

  utils_write_file(converted_chpt, new)
  expect_true(fs::file_exists(new))
})
