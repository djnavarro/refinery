

#' Locate the renv project environment for a distill article
#'
#' @param dir The folder in which the article is located
#' @param collection The collection the article belongs to (default = "_posts")
#'
#' @return Character string with the path
#' @export
renv_path <- function(dir, collection = "_posts") {
  fs::path(
    rprojroot::find_root("_site.yml"),
    "_refinery",
    collection,
    dir
  )
}

post_path <- function(dir, collection = "_posts") {
  fs::path(
    rprojroot::find_root("_site.yml"),
    collection,
    dir
  )
}

#' Locate the renv lockfile associated with a distill article
#'
#' @param dir The folder in which the article is located
#' @param collection The collection the article belongs to (default = "_posts")
#'
#' @return Character string with the path
#' @export
renv_lockfile <- function(dir, collection = "_posts") {
  fs::path(renv_path(dir, collection), "renv.lock")
}

#' Use the R environment associated with a distill article
#'
#' @param dir The folder in which the article is located
#' @param collection The collection the article belongs to (default = "_posts")
#'
#' @return Invisibly returns the renv project directory
#' @export
renv_use <- function(dir, collection = "_posts") {
  renv::uses(lockfile = renv_lockfile(dir, collection))
}



#' Create a snapshot of the R environment for the post
#'
#' @param dir The folder in which the article is located
#' @param collection The collection the article belongs to (default = "_posts")
#' @param ... Arguments to be passed to renv::snapshot()
#'
#' @return ???
#' @export
renv_snapshot <- function(dir, collection = "_posts", ...) {
  renv::snapshot(
    project = post_path(dir, collection),
    lockfile = renv_lockfile(dir, collection),
    ...
  )
}

#' Restore the renv project
#'
#' @param dir The folder in which the article is located
#' @param collection The collection the article belongs to (default = "_posts")
#' @param ... Arguments to be passed to renv::restore()
#'
#' @return ???
#' @export
renv_restore <- function(dir, collection = "_posts", ...) {
  renv::restore(
    project = post_path(dir, collection),
    lockfile = renv_lockfile(dir, collection),
    ...
  )
}

