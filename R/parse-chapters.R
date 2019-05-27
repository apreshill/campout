

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

lrnr_convert_hint <- function(.lines) {
  tibble(Lines = .lines) %>%
    mutate_at("Sections", ~extract_exercise_sections(Lines)) %>%
    mutate_at("ExerciseTag", ~extract_exercise_name(Lines)) %>%
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
    mutate_at("Sections", ~extract_exercise_sections(Lines)) %>%
    mutate_at("ExerciseTag", ~extract_exercise_name(Lines)) %>%
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

lrnr_tidy_document <- function(.lines) {
#     mutate(
#         LinesModified = LinesModified %>%
#             str_remove("^(key|xp|lang|skills):.*$") %>%
#             str_remove("^type: .*$") %>%
#             str_remove("^`+yaml.*$") %>%
#             str_remove("^`\\@.*`.*$"),
#         # Replace instructions tag with bold "instructions" text
#         Lines = if_else(
#             str_detect(Lines, "^`@instructions`.*$"),
#             "**Instructions**:",
#             Lines
#         ),
#     ) %>%
#     mutate(
#         LinesModified = if_else(
#                 grepl("^$", lag(LinesModified)) & grepl("^$", lead(LinesModified)) &
#                     grepl("^---$", LinesModified),
#                 "",
#                 LinesModified
#         ),
#         # TODO: Fix this, it doesn't work for some reason
#         LinesModified = if_else(
#                 grepl("^$", lag(LinesModified)) & grepl("^$", lead(LinesModified)) &
#                     grepl("^```$", LinesModified, perl = TRUE),
#                 "",
#                 LinesModified
#         )
#     ) %>%
#     # pull(LinesModified)
#     View()
}

#     lrnr_convert_hint() %>%
#     lrnr_convert_code_exercises() %>%
