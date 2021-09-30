
#' Create new article from existing template
#'
#' @param template Path to template file
#' @param slug Semantic slug for the article (in-kebab-case)
#' @param date Date for the article (in YYYY-MM-DD)
#' @param collection Collection to contain the article (default = "posts")
#' @param slug_replace Pattern to be replaced with slug
#' @param date_replace Pattern to be replaced with date
#' @param renv_new Initialise a new R environment?
#' @param open Open the article in RStudio?
#'
#' @return ???
#' @export
#'
use_article_template <- function(
  template,
  slug,
  date = NULL,
  collection = "posts",
  slug_replace = "INSERT-SLUG-HERE",
  date_replace = "INSERT-DATE-HERE",
  renv_new = TRUE,
  open = interactive()
) {

  collection <- with_underscore(collection)

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
  lines <- gsub(pattern = slug, replacement = slug_replace, x = lines)
  lines <- gsub(pattern = date, replacement = date_replace, x = lines)
  brio::write_lines(lines, post_file)

  if(renv_new == TRUE) {renv_new(long_slug, collection)}

  # open the post if requested (and RStudio available)
  if(open == TRUE & rstudioapi::isAvailable()) {
    rstudioapi::navigateToFile(post_file)
  }
}




