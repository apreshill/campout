
extract_rpkg_deps <- function(.file) {
    # TODO: Deal with versions?
    .file %>%
        readr::read_lines() %>%
        str_subset("install") %>%
        str_extract('\".*\"') %>%
        str_remove_all('"') %>%
        str_remove(',.*$')
}

add_deps_desc <- function(.deps) {
    purrr::walk(dependencies, usethis::use_package)
}

deps_to_desc <- function(.file) {
    deps <- .file %>%
        extract_rpkg_deps()

    # TODO: Check if DESCRIPTION file exists.
    add_deps_desc(deps)

    # TODO: Use something like withr instead of here?
    fs::file_delete(here::here("requirements.R"))

    return(invisible(NULL))
}

