#' datacamp_to_learnr
#'
#'
#' @export
datacamp_to_learnr <- function(cur_path=NULL, rename=NULL, author_name="Default", has_data=T) {
  # TODO: Check if working dir is a repo
  # TODO: Check if any uncommitted files are present
  # TODO: Check that the necessary files exist
  # TODO: Check if a "original materials" git branch exists

options(usethis.quiet = TRUE)

if(is.null(cur_path)){
  cur_path=getwd()
}
#
# # For accidental sourcing... -_-
# stop()
#
# # Checking if project is under git and if changes are not committed
if (!in_repository(cur_path))
    stop("Please make that the files are under Git version control.")
if (length(status(cur_path)$unstaged)!=0)
    stop("Please make sure to commit changes before running.")
#
# # Listing all files -------------------------------------------------------

## needs to check to see if there are dashes in the folder name

pkgname <- basename(cur_path)
if(grepl("-", pkgname)){
  if(is.null(rename)){
    pkgname <- gsub("-", "", pkgname)
  } else {
    pkgname <- rename
  }

  new_path <- strsplit(cur_path, "/")[[1]]
  new_path <- new_path[-length(new_path)]
  # new_path <- new_path[-1]
  new_path <- paste(new_path, collapse=.Platform$file.sep)
  new_path <- file.path(new_path, pkgname)
  file.rename(cur_path, new_path)
  cur_path <- new_path
}
setwd(cur_path)
pkgname <- paste(pkgname, ".Rproj", sep="")

all_files <- dir_ls(cur_path, recurse = TRUE, type = "file", all = TRUE)
proj_name <- str_subset(all_files, "\\.Rproj$")



#### No RPoject, which would seem to be default??
if(length(proj_name)==0){
  tmp <- paste(pkgname, ".Rproj", sep="")
  proj_name = file.path(cur_path, tmp)
}
# # Create as package -------------------------------------------------------


create_package(path_dir(proj_name))
if(has_data){
  use_data_raw(open=F)
}

chapters <- str_subset(all_files, "chapter.\\.md")

new_chapter_path <- file.path(cur_path, "inst/tutorials/", path_file(chapters)) %>%
    str_replace("\\.md", ".Rmd")

if(!dir_exists(path_dir(new_chapter_path)[1])){
  dir_create(path_dir(new_chapter_path)[1])
}

file_move(chapters, new_chapter_path)


use_build_ignore("slides")
use_tidy_versions()
use_github_links(overwrite=T)
use_mit_license(name=author_name)
use_blank_slate()
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
