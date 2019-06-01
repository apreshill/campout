#' Convert your DataCamp material into learnr tutorials.
#'
#' Then you can use the function [learnr::run_tutorial()] to run the tutorials
#' interactively.
#'
#' @param dc_path Path to the DataCamp material.
#' @param lrnr_pkg_path Path to the new learnr package.
#' @param author_name Name of author.
#'
#' @return Creates a new package containing the material as a [learnr::tutorial()].
#' @export
#'
#' @examples
#' \dontrun{
#' Temp <- tempdir()
#' datacamp_to_learnr_pkg(lrnr_pkg_path = Temp)
#' }
datacamp_to_learnr_pkg <-
  function(dc_path = ".", lrnr_pkg_path = ".",
           author_name = "Default") {
    # TODO: Check if working dir is a repo
    # TODO: Check if any uncommitted files are present
    # TODO: Check that the necessary files exist
    # TODO: Check if a "original materials" git branch exists

    # options(usethis.quiet = TRUE)

    if (is.null(dc_path)) {
      dc_path = getwd()
    }
    #
    # # For accidental sourcing... -_-
    # stop()
    #
    # # Checking if project is under git and if changes are not committed
    if (!in_repository(dc_path))
      stop("Please make that the files are under Git version control.")
    if (length(status(dc_path)$unstaged) != 0)
      stop("Please make sure to commit changes before running.")
    #
    # # Listing all files -------------------------------------------------------


    pkgname <- basename(lrnr_pkg_path)
    pkgname <- paste(pkgname, ".Rproj", sep = "")

    all_files <-
      fs::dir_ls(dc_path,
             recurse = TRUE,
             type = "file",
             all = TRUE)



    # # Create as package -------------------------------------------------------
    ### this will fail if there are dashes, in the name, could provide an earlier error
    usethis::create_package(lrnr_pkg_path)

    chapters <- str_subset(all_files, "chapter.\\.md")

    ### Gets chapter names
    chapters_name <- fs::path_ext_remove(fs::path_file(chapters))


    ## creates demo files
    withr::with_dir(lrnr_pkg_path, {
      sapply(chapters_name,
             usethis::use_tutorial,
             open = F,
             title = "Demo")
    } )


    ## Overwrites demo files
    new_chapter_path <-
      file.path(lrnr_pkg_path, "inst/tutorials/", fs::path_file(chapters)) %>%
      str_replace("\\.md", ".Rmd")
    fs::file_move(chapters, new_chapter_path)

    withr::with_dir(lrnr_pkg_path, {
      usethis::use_build_ignore("slides")
      usethis::use_tidy_versions()
      usethis::use_github()
      usethis::use_ccby_license(name = author_name)
      usethis::use_blank_slate()
    })
  }

dc_to_lrnr_copy_converted_chpts <- function(.dc_path, .lrnr_pkg_path) {
  chapter_files <- fs::dir_ls(path = .dc_path, regexp = "chapter[1-9]\\.md")
  new_tutorial_name <- fs::path_ext_remove(basename(chapter_files))
  converted_chapter_files <- purrr::map(chapter_files, dc_chapter_to_lrnr_tutorial)

  withr::with_dir(.lrnr_pkg_path, {
    usethis::use_tutorial(new_tutorial_name, open = FALSE)
    new_tutorial_path <- fs::dir_ls(".", regexp = "chapter[1-9]", recurse = TRUE)
  })

  purrr::walk2(converted_chapter_files, new_tutorial_path,
               ~ readr::write_lines(.x, .y))
  return(invisible(NULL))
}

dc_to_lrnr_copy_slides_dir <- function(.dc_path, .lrnr_pkg_path) {
  dc_slides_dir <- fs::path(.dc_path, "slides")
  lrnr_slides_dir <- fs::path(.lrnr_pkg_path, "inst", "tutorials", "slides")
  fs::dir_copy(dc_slides_dir, lrnr_slides_dir)
}

dc_to_lrnr_copy_datasets_dir <- function(.dc_path, .lrnr_pkg_path) {
  dc_dataset_dir <- fs::path(.dc_path, "datasets")
  lrnr_dataset_dir <- fs::path(.lrnr_pkg_path, "inst", "tutorials", "datasets")
  fs::dir_copy(dc_dataset_dir, lrnr_dataset_dir)
}

