
#' Locate articles matching a pattern
#'
#' @param pattern Regular expression
#' @param collection The collection the article belongs to (default = "posts")
#'
#' @return Character vector of paths
#' @export
article_named <- function(pattern, collection = "posts") {
  list.files(
    path = fs::path(site_root(), paste0("_", collection)),
    pattern = pattern,
    include.dirs = TRUE
  )
}

