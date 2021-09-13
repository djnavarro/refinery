
#' Returns articles matching a pattern
#'
#' @param pattern Regular expression
#' @param collection Folder to look in
#'
#' @return Character vector of paths
#' @export
articles_matching <- function(pattern, collection = "_posts") {
  list.files(
    path = fs::path(site_root(), collection),
    pattern = pattern,
    include.dirs = TRUE
  )
}
