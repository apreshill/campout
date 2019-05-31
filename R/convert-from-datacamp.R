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
  function(dc_path = ".", lrnr_pkg_path,
           author_name = "Default") {
    # TODO: Check if working dir is a repo
    # TODO: Check if any uncommitted files are present
    # TODO: Check that the necessary files exist
    # TODO: Check if a "original materials" git branch exists

    # options(usethis.quiet = TRUE)

    if (is.null(cur_path)) {
      cur_path = getwd()
    }
    #
    # # For accidental sourcing... -_-
    # stop()
    #
    # # Checking if project is under git and if changes are not committed
    if (!in_repository(cur_path))
      stop("Please make that the files are under Git version control.")
    if (length(status(cur_path)$unstaged) != 0)
      stop("Please make sure to commit changes before running.")
    #
    # # Listing all files -------------------------------------------------------

    ## needs to check to see if there are dashes in the folder name

    pkgname <- basename(cur_path)
    if (grepl("-", pkgname)) {
      if (is.null(rename)) {
        pkgname <- gsub("-", "", pkgname)
      } else {
        pkgname <- rename
      }

      new_path <- strsplit(cur_path, "/")[[1]]
      new_path <- new_path[-length(new_path)]
      # new_path <- new_path[-1]
      new_path <- paste(new_path, collapse = .Platform$file.sep)
      new_path <- file.path(new_path, pkgname)
      file.rename(cur_path, new_path)
      cur_path <- new_path
    }
    pkgname <- paste(pkgname, ".Rproj", sep = "")

    all_files <-
      dir_ls(cur_path,
             recurse = TRUE,
             type = "file",
             all = TRUE)
    proj_name <- str_subset(all_files, "\\.Rproj$")



    #### No RPoject, which would seem to be default??
    if (length(proj_name) == 0) {
      tmp <- paste(pkgname, ".Rproj", sep = "")
      proj_name = file.path(cur_path, tmp)
    }
    # # Create as package -------------------------------------------------------


    create_package(path_dir(proj_name))
    if (has_data) {
      use_data_raw(open = F) ### will need to be done within right directory
    }

    chapters <- str_subset(all_files, "chapter.\\.md")

    ### Gets chapter names
    chapters_name <- path_ext_remove(path_file(chapters))

    ## creates demo files
    sapply(chapters_name,
           use_tutorial,
           open = F,
           title = "Demo")

    ## Overwrites demo files
    new_chapter_path <-
      file.path(cur_path, "inst/tutorials/", path_file(chapters)) %>%
      str_replace("\\.md", ".Rmd")
    file_move(chapters, new_chapter_path)

    ### will need to be done within right directory
    use_build_ignore("slides")
    use_tidy_versions()
    use_github(overwrite = T)
    use_ccby_license(name = author_name)
    use_blank_slate()
  }

# # Update datasets into data -----------------------------------------------
# Or move dataset folder into inst tutorial
#
# datasets <- all_files %>%
#     str_subset("\\.(rda|rds)$")
# file_delete(datasets)
#
# # Move images -------------------------------------------------------------
#
# images <- str_subset(all_files, "datasets/.*\\.png$")
# file_move(images, here("inst/tutorials/images"))
#
