

#' Locate the R environment for a distill article
#'
#' @param dir The folder in which the article is located
#' @param collection The collection the article belongs to (default = "_posts")
#'
#' @return Character string with the path
#' @export
renv_locate <- function(dir, collection = "_posts") {
  fs::path(
    rprojroot::find_root("_site.yml"),
    "_refinery",
    collection,
    dir
  )
}

#' Activate the R environment associated with a distll article
#'
#' @param dir The folder in which the article is located
#' @param collection The collection the article belongs to (default = "_posts")
#'
#' @return Invisibly returns the renv project directory
#' @export
renv_activate <- function(dir, collection = "_posts") {
  renv::activate(project = refinery_locate(dir, collection))
}
