
util_remove_repeated_empty_lines <- function(.lines) {
  rle(.lines)$values
}

utils_write_file <- function(.lines, .output_path) {
  readr::write_lines(.lines, .output_path)
  return(invisible(NULL))
}
