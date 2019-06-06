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
#' # Run if your DC course is in the working directory
#' datacamp_to_learnr_pkg(lrnr_pkg_path = Temp)
#' # Run if your course is somewhere else
#' datacamp_to_learnr_pkg("~/Documents/data-camp-course/",
#'                        lrnr_pkg_path = Temp)
#' }
datacamp_to_learnr_pkg <-
  function(dc_path = ".", lrnr_pkg_path,
           author_name = "YOUR NAME") {

    old <- options(stringsAsFactors = FALSE)
    options(usethis.quiet = TRUE)
    on.exit(options(old), add = TRUE)

    if (!in_repository(dc_path))
      rlang::abort("Please make that the files are under Git version control.")
    if (length(status(dc_path)$unstaged) != 0)
      rlang::abort("Please make sure to commit changes before converting the course.")

    pkgname <- fs::path_file(lrnr_pkg_path)
    if (str_detect(pkgname, "( |-|_)"))
      rlang::abort("The name of the new learnr package shouldn't have any spaces, dashes, or underscores")

    # Create learnr package
    usethis::create_package(lrnr_pkg_path, open = FALSE)
    print("here?")

    chapter_files <- fs::dir_ls(
      path = dc_path,
      regexp = "chapter[1-9]\\.md",
      recurse = TRUE
    )
    new_tutorial_name <- fs::path_ext_remove(fs::path_file(chapter_files))
    new_tutorial_title <- new_tutorial_name %>%
      str_replace("(chapter)", "\\1 ") %>%
      str_to_title()

    req_file <- fs::dir_ls(dc_path, regexp = "requirements\\.R$")
    dependencies <- extract_rpkg_deps(req_file)

    withr::with_dir(lrnr_pkg_path, {
      purrr::walk2(new_tutorial_name,
                   new_tutorial_title,
                   usethis::use_tutorial,
                   open = FALSE)
      # Not sure about setting GitHub right away.
      # usethis::use_github()
      usethis::use_ccby_license(name = author_name)
      usethis::use_blank_slate()
      add_deps_imports(dependencies)
      usethis::use_tidy_versions()
    })
    print("here later?")

    converted_chapter_files <-
      purrr::map(chapter_files, dc_chapter_to_lrnr_tutorial)
    new_tutorial_path <-
      fs::dir_ls(lrnr_pkg_path, regexp = "chapter[1-9]", recurse = TRUE)
    purrr::walk2(converted_chapter_files,
                 new_tutorial_path,
                 ~ readr::write_lines(.x, .y))

    copy_datasets_dir_to_lrnr(dc_path, lrnr_pkg_path)

    copy_slides_dir_to_lrnr(dc_path, lrnr_pkg_path)

  }

copy_slides_dir_to_lrnr <- function(.dc_path, .lrnr_pkg_path) {
  dc_slides_dir <- fs::path(.dc_path, "slides")
  lrnr_slides_dir <- fs::path(.lrnr_pkg_path, "inst", "tutorials", "slides")
  fs::dir_copy(dc_slides_dir, lrnr_slides_dir)
}

copy_datasets_dir_to_lrnr <- function(.dc_path, .lrnr_pkg_path) {
  dc_dataset_dir <- fs::path(.dc_path, "datasets")
  lrnr_dataset_dir <- fs::path(.lrnr_pkg_path, "inst", "tutorials", "datasets")
  fs::dir_copy(dc_dataset_dir, lrnr_dataset_dir)
}

