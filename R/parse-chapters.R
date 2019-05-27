

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
  if_else(str_detect(.lines, "^`@instructions`.*$"),
          "**Instructions**:",
          .lines)
}

chpt_modify_dataset <- function(.lines) {
  .lines %>%
    str_replace("^load.*?http.*datasets.*/(.*\\.[rR]da).*$", "load(\\1)")
}

chpt_modify_yaml <- function(.lines) {
  .lines %>%
    str_remove("^free_preview: true$")
}

# Parsing MCQ text --------------------------------------------------------

# glue::glue_data("answer({possible_answers}, correct = {correct}, message = {message}))")

# glue::glue("
# question('',
# ")

chpt_extract_mcq_responses <- function(.lines) {
  .lines %>%
    str_flatten("\\n")
  # %>%
  #   str_extract_all("@possible\\_answers.*@")
}

# Conversion to learnr format ---------------------------------------------

lrnr_append_yaml_output <- function(.lines) {
  yaml_end <- str_which(.lines, "^---$")[2]
  yaml_output_lrnr <- c("output: learnr::tutorial",
                        "runtime: shiny_prerendered")

  c(.lines[1:(yaml_end - 1)],
    yaml_output_lrnr,
    .lines[yaml_end:length(.lines)])
}

lrnr_append_code_preamble <- function(.lines) {
  yaml_end <- str_which(.lines, "^---$")[2]
  code_preamble <- c(
    "",
    "```{r setup, include=FALSE}",
    "library(learnr)",
    "knitr::opts_chunk$set(echo = FALSE)",
    "```"
  )

  c(.lines[1:yaml_end],
    code_preamble,
    .lines[(yaml_end + 1):length(.lines)])
}

lrnr_convert_hint <- function(.lines) {
  tibble(Lines = .lines) %>%
    mutate(Sections = chpt_extract_exercise_sections(Lines)) %>%
    mutate(ExerciseTag = chpt_extract_exercise_name(Lines)) %>%
    tidyr::fill("Sections", "ExerciseTag") %>%
    mutate_at("Lines", ~ {
      Lines <- if_else(str_detect(Lines, "^`\\@hint`"),
                       as.character(glue::glue('<div id="{ExerciseTag}-hint">')),
                       Lines)
      if_else(
        !is.na(Sections) &
          Sections == "hint" &
          lead(Sections) != "hint",
        str_c(Lines, "</div>"),
        Lines
      )
    }) %>%
    pull("Lines")
}

lrnr_convert_code_exercises <- function(.lines) {
  tibble(Lines = .lines) %>%
    mutate(Sections = chpt_extract_exercise_sections(Lines)) %>%
    mutate(ExerciseTag = chpt_extract_exercise_name(Lines)) %>%
    group_by("ExerciseTag") %>%
    tidyr::fill("Sections", "ExerciseTag") %>%
    mutate_at("Lines", ~ {
      Lines <- case_when(
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
      Lines %>%
        # TODO: Not really sure what to do about the success messages...
        str_replace("^success\\_msg\\((.*)\\)$", "\\1") %>%
        # For the tab exercises. Will need to check to see how they work.
        str_replace("\\*\\*\\*", "### ")
    }) %>%
    pull("Lines")
}

lrnr_tidy_chapter <- function(.lines) {
  .lines %>%
    chpt_modify_yaml() %>%
    chpt_modify_instruction_name() %>%
    chpt_remove_extraneous_lines() %>%
    chpt_remove_extra_separators() %>%
    chpt_remove_extra_backticks()
}

lrnr_write_tutorial <- function(.lines, .chapter_md) {
  new <- str_c(fs::path_ext_remove(.chapter_md), "-tutorial.Rmd")
  readr::write_lines(.lines, new)

  return(invisible(NULL))
}

dc_chapter_to_lrnr_tutorial <- function(.chapter_md) {
  readr::read_lines(.chapter_md) %>%
    lrnr_convert_hint() %>%
    lrnr_convert_code_exercises() %>%
    lrnr_append_code_preamble() %>%
    lrnr_append_yaml_output() %>%
    lrnr_tidy_chapter() %>%
    lrnr_write_tutorial(.chapter_md = .chapter_md)
}
