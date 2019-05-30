
# Generic slide parsers ---------------------------------------------------

sld_extract_key <- function(.file_path) {
  readr::read_lines(.file_path) %>%
      head(4) %>%
      str_subset("^key: .*") %>%
      str_remove("key: ")
}

sld_remove_extraneous_lines <- function(.lines) {
  removed <- .lines %>%
    str_remove("^(key|type):.*$") %>%
    str_remove("^`+yaml.*$") %>%
    str_remove("^`\\@.*`.*$") %>%
    str_remove("^name: .*$")

  c(head(removed, 3),
    tail(removed, -3) %>%
      str_remove("^title: .*$"))
}

# Backticks that are surrounded by empty lines
sld_remove_extra_backticks <- function(.lines) {
  if_else(
    grepl("^$", lag(.lines)) & grepl("^$", lead(.lines)) &
      grepl("^```$", .lines, perl = TRUE),
    "",
    .lines
  )
}

# DataCamp slide item reveals
sld_remove_dc_reveals <- function(.lines) {
  .lines %>%
    str_remove("\\{\\{\\w\\}\\}")
}

sld_modify_image_path <- function(.lines) {
  .lines %>%
    str_replace("http.*(datasets)/.*/(.*\\..*\\))$", "\\1/\\2")
}

sld_modify_r_chunks <- function(.lines) {
  .lines %>%
    str_replace("^```\\{r\\}.*$", "``` r")
}

sld_insert_yaml_end <- function(.lines) {
  append(.lines, "---", after = 3)
}

# Parsers for conversion to text document ---------------------------------

sld_headers_to_three <- function(.lines) {
  .lines %>%
    str_replace("^## ", "### ")
}

# Separators that are surrounded by empty lines
sld_remove_extra_separators <- function(.lines) {
  if_else(
    grepl("^$", lag(.lines)) &
      grepl("^---$", .lines),
    "",
    .lines
  )
}

# Parsers for conversion to xaringan slides -------------------------------

# TODO: Conversion to xaringan two columns
sld_xaringan_two_columns <- function(.lines) {

}

# TODO: Conversion to xaringan two by two slide
sld_xaringan_two_by_two <- function(.lines) {

}

# TODO: Conversion to xaringan two rows
sld_xaringan_two_rows <- function(.lines) {

}

# Converting slides to various formats ------------------------------------

# TODO: Insert video link.
dc_slides_video_link <- function(.lines) {

}

# TODO: Convert to xaringan slides
dc_slides_to_xaringan <- function(.lines) {

}

dc_slides_to_text_doc <- function(.slide_md) {
  readr::read_lines(.slide_md) %>%
    sld_modify_r_chunks() %>%
    sld_modify_image_path() %>%
    sld_headers_to_three() %>%
    sld_remove_extra_separators() %>%
    sld_remove_extraneous_lines() %>%
    sld_remove_extra_backticks() %>%
    sld_insert_yaml_end() %>%
    sld_remove_dc_reveals() %>%
    util_remove_repeated_empty_lines()
}
