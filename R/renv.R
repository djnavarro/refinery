

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
#' @param type Type of snapshot to take (defaults to "implicit")
#' @param prompt Prompt user?
#'
#' @return ???
#' @export
renv_snapshot <- function(dir, collection = "_posts", type = "implicit", prompt = FALSE, ...) {
  renv::snapshot(
    project = post_path(dir, collection),
    lockfile = renv_lockfile(dir, collection),
    type = type,
    prompt = prompt,
    ...
  )
}


#' Restore the renv project
#'
#' @param dir The folder in which the article is located
#' @param collection The collection the article belongs to (default = "_posts")
#' @param clean Remove packages not recorded in the lockfile? (default = FALSE)
#' @param ... Arguments to be passed to renv::restore()
#' @param prompt Prompt user?
#'
#' @return ???
#' @export
renv_restore <- function(dir, collection = "_posts", clean = FALSE, prompt = FALSE, ...) {
  renv::restore(
    library = renv_library(dir, collection),
    lockfile = renv_lockfile(dir, collection),
    prompt = prompt,
    clean = clean,
    ...
  )
}


#' Create a minimal R environment for a post
#'
#' @param dir The folder in which the article is located
#' @param collection The collection the article belongs to (default = "_posts")
#'
#' @return ??
#' @export
#'
#' @details Creates the renv library and installs renv, distill and refinery
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
}

#' Delete the renv set up associated with a post
#'
#' @param dir The folder in which the article is located
#' @param collection The collection the article belongs to (default = "_posts")
#'
#' @return ??
#' @export
renv_delete <- function(dir, collection = "_posts") {
  renvdir <- renv_path(dir, collection)
  lockfile <- renv_lockfile(dir, collection)
  if(fs::file_exists(lockfile)) fs::file_delete(lockfile)
  fs::dir_delete(renvdir)
}


# helpers -----------------------------------------------------------------

site_root <- function() {
  rprojroot::find_root("_site.yml")
}

renv_path <- function(dir, collection = "_posts", root = site_root()) {
  fs::path(
    root,
    "_renv",
    collection,
    dir
  )
}

post_path <- function(dir, collection = "_posts", root = site_root()) {
  fs::path(
    root,
    collection,
    dir
  )
}

renv_lockfile <- function(dir, collection = "_posts") {
  fs::path(renv_path(dir, collection), "renv.lock")
}


renv_library <- function(dir, collection = "_posts") {
  renv::paths$library(project = renv_path(dir, collection))
}


