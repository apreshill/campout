

# Mostly generic string wranglers -----------------------------------------

chpt_extract_exercise_type <- function(.lines) {
  .lines %>%
    str_extract("^type: .*$") %>%
    str_remove("type: ") %>%
    str_trim()
}

chpt_extract_exercise_sections <- function(.lines) {
  .lines %>%
    # Don't want to include this in the sections
    str_remove("^`@instructions`.*$") %>%
    str_extract("`\\@.*`.*$") %>%
    str_remove_all("(^`)|(\\@)|(`$)") %>%
    str_trim()
}

chpt_extract_exercise_name <- function(.lines) {
  .lines %>%
    str_extract("## .*$") %>%
    str_remove("## ") %>%
    str_remove_all(",|\\?|\\!|\\.|\\:|\\;") %>%
    str_to_lower() %>%
    str_replace_all(" ", "-")
}

chpt_remove_extraneous_lines <- function(.lines) {
  .lines %>%
    str_remove("^(key|xp|lang|skills):.*$") %>%
    str_remove("^type: .*$") %>%
    str_remove("^`+yaml.*$") %>%
    str_remove("^`\\@.*`.*$")
}

# Separators that are surrounded by empty lines
chpt_remove_extra_separators <- function(.lines) {
  if_else(
    grepl("^$", lag(.lines)) & grepl("^$", lead(.lines)) &
      grepl("^---$", .lines),
    "",
    .lines
  )
}

# Backticks that are surrounded by empty lines
chpt_remove_extra_backticks <- function(.lines) {
  if_else(
    grepl("^$", lag(.lines)) & grepl("^$", lead(.lines)) &
      grepl("^```$", .lines, perl = TRUE),
    "",
    .lines
  )
}

chpt_modify_instruction_name <- function(.lines) {
  pattern <- "^`@instructions`.*$"
  instruction_locations <- str_which(.lines, pattern) + 1

  if (length(instruction_locations) != 0)
    .lines <- R.utils::insert(.lines, instruction_locations, "")

  .lines %>%
    str_replace(pattern, "**Instructions**:")
}

chpt_modify_dataset_path <- function(.lines) {
  .lines %>%
    str_replace("^load.*?http.*(datasets)/.*/(.*\\.[rR]da).*$", "load('\\1/\\2')") %>%
    str_replace("readRDS.*?http.*(datasets)/.*/(.*\\.[rR]ds).*$", "readRDS('\\1/\\2')")
}

chpt_modify_yaml <- function(.lines) {
  .lines %>%
    str_remove("^free_preview: true$")
}

chpt_prep_exercise_text <- function(.lines) {
  tibble(Lines = .lines) %>%
    mutate(
      Sections = chpt_extract_exercise_sections(Lines),
      ExerciseName = chpt_extract_exercise_name(Lines),
      ExerciseType = chpt_extract_exercise_type(Lines)
    ) %>%
    tidyr::fill("Sections", "ExerciseName", "ExerciseType") %>%
    mutate(ExerciseTag = str_c(ExerciseName, "-", ExerciseType))
}

# Parsing MCQ text --------------------------------------------------------

chpt_extract_mcq_text <- function(.lines) {
  .lines %>%
    chpt_prep_exercise_text() %>%
    mutate(
      MCQResponses = if_else(
        ExerciseType == "MultipleChoiceExercise" &
          Sections == "possible_answers",
        Lines,
        NA_character_
      ) %>%
        str_extract("^- .*$") %>%
        str_remove("^- "),
      MCQAnswerCheck = if_else(
        ExerciseType == "MultipleChoiceExercise" &
          Sections == "sct",
        Lines,
        NA_character_
      ),
      MCQCorrectResponse = MCQAnswerCheck %>%
        str_extract("^.*check_mc\\(.*$") %>%
        str_replace("^.*check_mc\\(([1-9]),.*$", "\\1"),
      MCQMessages = MCQAnswerCheck %>%
        str_extract("^msg.*$") %>%
        str_remove('^msg.* \\"') %>%
        str_remove('\\"')
    )

}

chpt_extract_mcq_responses <- function(.lines) {
  .lines %>%
    chpt_extract_mcq_text() %>%
    pull("MCQResponses") %>%
    stringi::stri_remove_empty_na()
}

chpt_extract_mcq_answer <- function(.lines) {
  .lines %>%
    chpt_extract_mcq_text() %>%
    pull("MCQCorrectResponse") %>%
    stringi::stri_remove_empty_na()
}

chpt_extract_mcq_messages <- function(.lines) {
  .lines %>%
    chpt_extract_mcq_text() %>%
    pull("MCQMessages") %>%
    stringi::stri_remove_empty_na()
}

chpt_remove_mcq_text <- function(.lines) {
  .lines %>%
    chpt_prep_exercise_text() %>%
    filter(
        !(ExerciseType == "MultipleChoiceExercise" &
          Sections %in% c("pre_exercise_code", "possible_answers", "sct") &
          !is.na(Sections)),
      ) %>%
    pull("Lines")
}

# Convert exercises to list and back --------------------------------------

chpt_exercise_to_list <- function(.lines) {
  .lines %>%
    str_flatten("\n") %>%
    str_split("\\n---\\n") %>%
    unlist() %>%
    purrr::map(str_split, pattern = "\n") %>%
    unlist(recursive = FALSE)
}

chpt_exercise_to_vector <- function(.lines) {
  .lines %>%
    unlist()
}

# Conversion to learnr format ---------------------------------------------

lrnr_append_yaml_output <- function(.lines_list) {
  yaml_output_lrnr <- c("output: learnr::tutorial",
                        "runtime: shiny_prerendered",
                        "---")

  .lines_list[[1]] <- append(.lines_list[[1]], yaml_output_lrnr)
  .lines_list
}

lrnr_append_todo_list <- function(.lines_list) {
  todo_list <- c(
    "",
    "<!-- TODO: Deal with `@sct` tags, they aren't supported. -->",
    "<!-- TODO: Check that video content has been added. -->",
    "<!-- TODO: Fix MCQ exercises, parsing isn't developed for it yet. -->",
    "<!-- TODO: Check that Tab or Bullet Exercises were converted properly. -->",
    "<!-- TODO: Decide what to do with pre-exercise code from MCQ, they aren't supported. -->",
    "<!-- TODO: Decide what to do with `success_msg`, these aren't supported. -->",
    ""
  )

  .lines_list[[2]] <- append(.lines_list[[2]], todo_list, after = 1)
  .lines_list
}

lrnr_append_code_preamble <- function(.lines_list) {
  code_preamble <- c(
    "",
    "```{r setup, include=FALSE}",
    "library(learnr)",
    "knitr::opts_chunk$set(echo = FALSE)",
    "```"
  )

  .lines_list[[2]] <- append(.lines_list[[2]], code_preamble, after = 1)
  .lines_list
}

lrnr_convert_mcq_exercises <- function(.lines_list) {
  purrr::map(
    .lines_list,
    ~ {
      mcq_responses <- tibble(
        responses = chpt_extract_mcq_responses(.x),
        messages = chpt_extract_mcq_messages(.x),
        correct_response = seq_along(length(responses)) == chpt_extract_mcq_answer(.x),
        converted = as.character(
          glue::glue(
            '  answer("{responses}", correct = {correct_response}, message = {messages}),',
          )
        )
      ) %>%
        pull("converted")

      exercise_tag <- str_c(
        chpt_extract_exercise_name(.x) %>%
          stringi::stri_remove_empty_na(),
        "-",
        chpt_extract_exercise_type(.x) %>%
          stringi::stri_remove_empty_na()
      )

      mcq_chunk <- ""
      if (length(mcq_responses) > 0) {
        mcq_chunk <- c(
          '',
          as.character(glue::glue(
            '```{{r {exercise_tag}-mcq, echo=FALSE}}'
          )),
          '# TODO: Add the question below in the quotation marks',
          'question("",',
          mcq_responses,
          '  allow_retry = TRUE',
          ')',
          '```',
          ''
        )
      }

      mcq_locations <- str_which(.x, "^`@possible\\_answers`$")

      if (length(mcq_locations) > 1) {
        warning("There are more than one MCQ in this exercise ",
                "(is it a Tab or Bullet exercise?). Leaving MCQ text as is.")
        .lines <- .x
      } else {
        .lines <- .x %>%
          chpt_remove_mcq_text() %>%
          append(mcq_chunk)
      }

      .lines
    }
  )
}

lrnr_convert_hint <- function(.lines_list) {
  purrr::map(
    .lines_list,
    ~ {
      .x %>%
        chpt_prep_exercise_text() %>%
        mutate_at("Lines", ~ {
          case_when(
            str_detect(Lines, "^`\\@hint`") ~ as.character(glue::glue('<div id="{ExerciseTag}-hint">')),
            !is.na(Sections) &
              Sections == "hint" &
              (lead(Sections) != "hint" |
                 grepl("^```\\{r .*", lead(Lines))) ~ str_c(Lines, "</div>"),
            TRUE ~ Lines
          )
        }) %>%
        pull("Lines")
    })
}

lrnr_convert_code_exercises <- function(.lines_list) {
  purrr::map(
    .lines_list,
    ~ {
      .x %>%
        # TODO: Not sure how to figure out about the tab/bullets...
        chpt_prep_exercise_text() %>%
        mutate_at("Lines", ~ {
          case_when(
            !str_detect(Lines, "```\\{r") ~ Lines,
            Sections == "pre_exercise_code" ~ as.character(glue::glue("```{{r {ExerciseTag}-setup}}")),
            Sections == "sample_code" ~ as.character(
              glue::glue(
                "```{{r {ExerciseTag}, exercise=TRUE, exercise.setup='{ExerciseTag}-setup'}}"
              )
            ),
            Sections == "solution" ~ as.character(glue::glue("```{{r {ExerciseTag}-solution}}")),
            Sections == "sct" ~ as.character(glue::glue("```{{r {ExerciseTag}-check}}")),
            TRUE ~ Lines
          )
        }) %>%
        pull("Lines") %>%
        # TODO: Not really sure what to do about the success messages...
        str_replace("^success\\_msg\\((.*)\\)$", "\\1") %>%
        # For the tab exercises. Will need to check to see how they work.
        str_replace("\\*\\*\\*", "### ") %>%
        str_replace("TabExercise-setup", "NormalExercise-setup")
    })
}

lrnr_tidy_chapter <- function(.lines_list) {
  purrr::map(
    .lines_list,
    ~ .x %>%
      chpt_modify_yaml() %>%
      chpt_modify_instruction_name() %>%
      chpt_remove_extraneous_lines() %>%
      chpt_remove_extra_separators() %>%
      chpt_remove_extra_backticks()
  )
}

lrnr_write_tutorial <- function(.lines, .output_path) {
  readr::write_lines(.lines, .output_path)
  return(invisible(NULL))
}

dc_chapter_to_lrnr_tutorial <- function(.chapter_md) {
  readr::read_lines(.chapter_md) %>%
    chpt_exercise_to_list() %>%
    lrnr_convert_mcq_exercises() %>%
    lrnr_convert_code_exercises() %>%
    lrnr_convert_hint() %>%
    lrnr_append_yaml_output() %>%
    lrnr_append_code_preamble() %>%
    lrnr_append_todo_list() %>%
    lrnr_tidy_chapter() %>%
    chpt_exercise_to_vector()
}
