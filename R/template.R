
#' Create new post from existing template
#'
#' @param template Path to template file
#' @param slug Semantic slug for the post (in-kebab-case)
#' @param date Date for the post (in YYYY-MM-DD)
#' @param collection Collection to contain the post (default = "_posts")
#' @param slug_replace Pattern to be replaced with slug
#' @param date_replace Pattern to be replaced with date
#' @param renv_new Initialise a new R environment?
#' @param open Open the post in RStudio?
#'
#' @return ???
#' @export
#'
use_post_template <- function(
  template,
  slug,
  date = NULL,
  collection = "_posts",
  slug_replace = "INSERT-SLUG-HERE",
  date_replace = "INSERT-DATE-HERE",
  renv_new = TRUE,
  open = interactive()
) {

  if(is.null(date)) {
    date <- lubridate::format_ISO8601(lubridate::today())
  }
  long_slug <- paste(date, slug, sep = "_")

  # relevant folders
  proj_dir <- rprojroot::find_root("_site.yml")
  post_dir <- fs::path(proj_dir, collection, long_slug)

  # file
  post_file <- fs::path(post_dir, "index.Rmd")

  # create post folder
  fs::dir_create(post_dir)

  # write the template, replacing the slug and the date
  lines <- brio::read_lines(template)
  lines <- stringr::str_replace_all(lines, slug_replace, slug)
  lines <- stringr::str_replace_all(lines, date_replace, date)
  brio::write_lines(lines, post_file)

  if(renv_new == TRUE) {renv_new(long_slug, collection)}

  # open the post if requested (and RStudio available)
  if(open == TRUE & rstudioapi::isAvailable()) {
    rstudioapi::navigateToFile(post_file)
  }
}
