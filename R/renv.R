

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
  wd <- setwd(post_path(dir, collection))
  on.exit(setwd(wd))
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
  renv_set_cache() # <- use hack
  renv::restore(
    library = renv_library(dir, collection),
    lockfile = renv_lockfile(dir, collection),
    prompt = prompt,
    clean = clean,
    ...
  )
}

# temporary hack!
renv_set_cache <- function() {
  Sys.setenv(
    RENV_PATHS_CACHE = normalizePath("~/.local/share/renv/cache/")
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

  wd <- getwd()
  on.exit(setwd(wd))

  # create directories (yes, this is redundant)
  if(!fs::dir_exists(renv_dir)) fs::dir_create(renv_dir)
  if(!fs::dir_exists(renv_lib)) fs::dir_create(renv_lib)

  # initialise a bare project
  renv::init(
    project = renv_dir,
    bare = TRUE,
    restart = FALSE
  )

  # remove unneded proj file and restores working directory
  proj_file <- fs::path(renv_dir, paste0(dir, ".Rproj"))
  if(fs::file_exists(proj_file)) fs::file_delete(proj_file)
  setwd(wd)

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


