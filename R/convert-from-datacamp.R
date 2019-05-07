
datacamp_to_learnr <- function(.repo) {
  # TODO: Check if working dir is a repo
  # TODO: Check if any uncommitted files are present
  # TODO: Check that the necessary files exist
  # TODO: Check if a "original materials" git branch exists

# options(usethis.quiet = TRUE)
#
# # For accidental sourcing... -_-
# stop()
#
# # Checking if project is under git and if changes are not committed
# if (git2r::in_repository())
#     stop("Please make that the files are under Git version control.")
# if (!is.null(git2r::status()$unstaged))
#     stop("Please make sure to commit changes before running.")
#
# # Listing all files -------------------------------------------------------
#
# all_files <- dir_ls(here(), recursive = TRUE, type = "file", all = TRUE)
# proj_name <- str_subset(all_files, "\\.Rproj$")
#
# # Create as package -------------------------------------------------------
#
# create_package(path_dir(proj_name))
# use_data_raw()

# chapters <- str_subset(all_files, "chapter.\\.md")

# new_chapter_path <- here("inst/tutorials", path_file(chapters)) %>%
#     str_replace("\\.md", ".Rmd")
#
# file_move(chapters, new_chapter_path)
#

# use_build_ignore("slides")
# use_tidy_versions()
# use_github_links()
# use_mit_license()
# use_blank_slate()
}

#
#
#
# tibble(Lines = read_lines(chapters[1])) %>%
#     mutate(
#         # Replace instructions tag with bold "instructions" text
#         Lines = if_else(
#             str_detect(Lines, "^`@instructions`.*$"),
#             "**Instructions**:",
#             Lines
#         ),
#         # Create a tag to indicate which lesson each section is part of
#         LessonTag = Lines %>%
#             str_extract("## .*$") %>%
#             str_remove("## ") %>%
#             str_remove_all(",|\\?|\\!|\\.|\\:|\\;") %>%
#             str_to_lower() %>%
#             str_replace_all(" ", "-"),
#         ExerciseType = str_extract(Lines, "^type: .*$") %>%
#             str_remove("type: ") %>%
#             str_trim(),
#         ExerciseSections = str_extract(Lines, "`\\@.*`.*$") %>%
#             str_remove_all("(^`)|(\\@)|(`$)") %>%
#             str_trim()
#     ) %>%
#     fill(LessonTag) %>%
#     group_by(LessonTag) %>%
#     fill(ExerciseType, ExerciseSections) %>%
#     mutate(
#         LinesModified = LinesModified %>%
#             str_remove("^(key|xp|lang|skills):.*$") %>%
#             str_remove("^type: .*$") %>%
#             str_remove("^`+yaml.*$") %>%
#             str_remove("^`\\@.*`.*$")
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
#
# # Update datasets into data -----------------------------------------------
# Or move datasets into inst
#
# datasets <- all_files %>%
#     str_subset("\\.(rda|rds)$")
# file_delete(datasets)
#
# wrangling_file <- str_subset(all_files, "wrangle\\.R$")
# wrangling_file %>%
#     read_lines() %>%
#     str_replace("^save*?\\((.*), file = .*$", "use_data(\\1, overwrite = TRUE)") %>%
#     write_lines(path = wrangling_file)
# file_move(wrangling_file, here("data-raw"))
# source(here("data-raw/wrangle.R"))
#
# # TODO: Export all datasets? Or is that done automatically?
#
# # Move images -------------------------------------------------------------
#
lrnr_move_images <- function(.repo) {
# images <- str_subset(all_files, "datasets/.*\\.png$")
# file_move(images, here("inst/tutorials/images"))
}
#
# # Adding other package additions ------------------------------------------
#
