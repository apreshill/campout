
extract_rpkg_deps <- function(.req_file) {
    # TODO: Deal with versions?
    .req_file %>%
        readr::read_lines() %>%
        str_subset("install") %>%
        str_extract('\".*\"') %>%
        str_remove_all('"') %>%
        str_remove(',.*$')
}

add_deps_imports <- function(.deps) {
    purrr::walk(.deps, usethis::use_package)
}
