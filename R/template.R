
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

  if(is.null(date)) {
    date <- lubridate::format_ISO8601(lubridate::today())
  }
  name <- paste(date, slug, sep = "_")
  post <- specify_post(name, collection)

  post_dir <- full_post_path(post)
  post_file <- fs::path(post_dir, "index.Rmd")

  # create post folder
  fs::dir_create(post_dir)

  # write the template, replacing the slug and the date
  lines <- brio::read_lines(template)
  lines <- gsub(pattern = slug_replace, replacement = slug, x = lines)
  lines <- gsub(pattern = date_replace, replacement = date, x = lines)
  brio::write_lines(lines, post_file)

  if(renv_new == TRUE) {renv_new(name, collection)}

  # open the post if requested (and RStudio available)
  if(open == TRUE & rstudioapi::isAvailable()) {
    rstudioapi::navigateToFile(post_file)
  }
}




