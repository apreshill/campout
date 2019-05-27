context("Extracting, parsing, and modifying chapter text")

chapter1 <- readr::read_lines("chapter1.md")

test_that("creating an exercise tag from the chapter text", {
  exercise_name <- chapter1 %>%
    extract_exercise_name() %>%
    na.omit() %>%
    as.character()

  # Should be 9 lessons/exercises
  expect_equal(length(exercise_name), 9)
  expect_equal(exercise_name[1:2],
               c("introduction-to-cohort-studies", "what-makes-it-a-cohort"))
})

test_that("extracting the exercise type from the exercise yaml", {
  exercise_type <- chapter1 %>%
    extract_exercise_type() %>%
    na.omit() %>%
    as.character()

  # Should be 14 exercise types (since there are a few tabbed exercises)
  expect_equal(length(exercise_type), 14)
  expect_equal(exercise_type[1:2],
               c("VideoExercise", "MultipleChoiceExercise"))
})

test_that("extracting the sections within the exercise", {
  exercise_sections <- chapter1 %>%
    extract_exercise_sections() %>%
    na.omit() %>%
    as.character()

  # There are multiple sections in each exercise. Should be 46
  expect_equal(length(exercise_sections), 46)
  expect_equal(exercise_sections[1:2],
               c("projector_key", "possible_answers"))
})


test_that("hint is converted to learnr style", {
  hint_conversion <- chapter1 %>%
    lrnr_convert_hint()

  expect_equal(sum(str_detect(hint_conversion, "div id.*hint")), 9)
  expect_equal(sum(str_detect(hint_conversion, "</div>")), 9)
  expect_equal(sum(str_detect(hint_conversion, "`@hint`")), 0)
})

# readr::read_lines("data-raw/chapter1.md") %>%
#   lrnr_convert_code_exercises() %>%
#   View()

test_that("code exercises are converted to learnr style", {
  code_ex_conversion <- chapter1 %>%
    lrnr_convert_code_exercises()

  # Setup code chunks
  expect_equal(sum(str_detect(code_ex_conversion, "```\\{r .*-setup\\}")), 6)

  # Sample code chunks
  expect_equal(sum(
    str_detect(
      code_ex_conversion,
      "```\\{r .*, exercise=TRUE, exercise\\.setup='.*-setup'\\}"
    )
  ), 9)

  # Solution code chunks
  expect_equal(sum(str_detect(code_ex_conversion, "```\\{r .*-solution\\}")), 7)

  # Submission correction tests code chunks
  expect_equal(sum(str_detect(code_ex_conversion, "```\\{r .*-check\\}")), 9)
})

test_that("dashed separators are replaced with empty string", {
  with_separators <- c(letters, "", "---", letters, "", "---", "", letters, "", "---", "")
  actual_without_seps <- remove_extra_separators(with_separators)
  expected_without_seps <- c(letters, "", "---", letters, "", "", "", letters, "", "", "")

  expect_identical(actual_without_seps, expected_without_seps)
})

test_that("code backticks are replaced with empty string", {
  with_backticks <- c(letters, "```", "", letters, "", "```",
                       letters, "", "```", "", letters, "", "```", "")
  actual_without_backticks <- remove_extra_backticks(with_backticks)
  expected_without_backticks <- c(letters, "```", "", letters, "", "```",
                                  letters, "", "", "", letters, "", "", "")

  expect_identical(actual_without_backticks, expected_without_backticks)
})
