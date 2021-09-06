

#' Locate the renv project environment for a distill article
#'
#' @param dir The folder in which the article is located
#' @param collection The collection the article belongs to (default = "_posts")
#'
#' @return Character string with the path
#' @export
#' @details By default, renv will either create the project library in the same
#' folder as the post (if you're using renv::init), or else it will store the
#' library in a temporary directory (if you're using renv::use with default
#' parameters). The former causes problems with distill because the distill will
#' recursively search the renv project library looking for posts, and it does
#' sometimes find some! This is undesirable because it can break the blog.
#' The latter is a very good default for users who just want to share a
#' reproducible script (which was the motivation for renv::use) but it's
#' inelegant if you wan to manage the R environments within your blog because
#' the libraries aren't included within your blog. To address this, the
#' refinery package places the renv.lock file in the post folder but moves the
#' renv library into a separate top level "_renv" directory that distill won't
#' look at when searching for posts
renv_path <- function(dir, collection = "_posts") {
  fs::path(
    rprojroot::find_root("_site.yml"),
    "_renv",
    collection,
    dir
  )
}

#' Locate a distill article
#'
#' @param dir The folder in which the article is located
#' @param collection The collection the article belongs to (default = "_posts")
#'
#' @return Character string with the path
#' @export
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
#' @details The renv.lock file is stored in the post folder
renv_lockfile <- function(dir, collection = "_posts") {
  fs::path(post_path(dir, collection), "renv.lock")
}

#' Use the R environment associated with a distill article
#'
#' @param dir The folder in which the article is located
#' @param collection The collection the article belongs to (default = "_posts")
#' @param ... Arguments to be passed to renv::use()
#'
#' @return ???
#' @export
renv_use <- function(dir, collection = "_posts", ...) {
  renv::use(
    lockfile = renv_lockfile(dir, collection),
    library = renv_library(dir, collection),
    ...
  )
}

#' Locate the library for the post
#'
#' @param dir The folder in which the article is located
#' @param collection The collection the article belongs to (default = "_posts")
#'
#' @return path
#' @export
renv_library <- function(dir, collection = "_posts") {
  renv::paths$library(project = renv_path(dir, collection))
}


#' Load the renv library
#'
#' @param dir The folder in which the article is located
#' @param collection The collection the article belongs to (default = "_posts")
#' @param ... Arguments to be passed to renv::load()
#'
#' @return ???
#' @export
renv_load <- function(dir, collection = "_posts", ...) {
  renv::load(project = renv_path(dir, collection), ...)
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
    prompt = FALSE,
    ...
  )
}

#' Restore the renv project
#'
#' @param dir The folder in which the article is located
#' @param collection The collection the article belongs to (default = "_posts")
#' @param clean Remove packages not recorded in the lockfile? (default = FALSE)
#' @param ... Arguments to be passed to renv::restore()
#'
#' @return ???
#' @export
renv_restore <- function(dir, collection = "_posts", clean = FALSE, ...) {
  renv::restore(
    library = renv_library(dir, collection),
    lockfile = renv_lockfile(dir, collection),
    prompt = FALSE,
    ...
  )
}



#' Create the renv setup
#'
#' @param dir The folder in which the article is located
#' @param collection The collection the article belongs to (default = "_posts")
#'
#' @return ??
#' @export
#'
#' @details Note that this is not quite equivalent to renv::init
renv_new <- function(dir, collection = "_posts") {

  renv_dir <- renv_path(dir, collection)
  renv_lib <- renv_library(dir, collection)

  # create directories (yes, this is redundant)
  if(!fs::dir_exists(renv_dir)) fs::dir_create(renv_dir)
  if(!fs::dir_exists(renv_lib)) fs::dir_create(renv_lib)

  # ensure the minimal set of packages exists in the library
  renv::install(
    packages = c("renv", "distill", "djnavarro/refinery"),
    library = renv_library(dir, collection)
  )

  # analyse the post folder and create lockfile
  renv_snapshot(dir, collection)

  # use the lockfile to populate the library
  renv_restore(dir, collection)
}


