
#' Load the renv library
#'
#' @param name The folder in which the article is located
#' @param collection The collection the article belongs to (default = "posts")
#' @param ... Arguments to be passed to renv::load()
#'
#' @return ???
#' @export
renv_load <- function(name, collection = "posts", ...) {
  post <- specify_post(name, collection)
  renv::load(project = full_renv_path(post), ...)
}


#' Create a snapshot of the R environment for the post
#'
#' @param name The folder in which the article is located
#' @param collection The collection the article belongs to (default = "posts")
#' @param ... Arguments to be passed to renv::snapshot()
#' @param type Type of snapshot to take (defaults to "implicit")
#' @param prompt Prompt user?
#'
#' @return ???
#' @export
renv_snapshot <- function(name, collection = "posts", type = "implicit", prompt = FALSE, ...) {

  post <- specify_post(name, collection)
  old_working_directory <- setwd(full_post_path(post))
  on.exit(setwd(old_working_directory))

  renv::snapshot(
    project = full_post_path(post),
    lockfile = full_lockfile_path(post),
    type = type,
    prompt = prompt,
    ...
  )
}


#' Restore the renv project
#'
#' @param name The folder in which the article is located
#' @param collection The collection the article belongs to (default = "posts")
#' @param clean Remove packages not recorded in the lockfile? (default = FALSE)
#' @param ... Arguments to be passed to renv::restore()
#' @param prompt Prompt user?
#'
#' @return ???
#' @export
renv_restore <- function(name, collection = "posts", clean = FALSE, prompt = FALSE, ...) {
  renv_set_cache() # <- use hack

  post <- specify_post(name, collection)
  renv::restore(
    library = full_library_path(post),
    lockfile = full_lockfile_path(post),
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
#' @param name The folder in which the article is located
#' @param collection The collection the article belongs to (default = "posts")
#'
#' @return ??
#' @export
#'
#' @details Creates the renv library and installs renv, distill and refinery
renv_new <- function(name, collection = "posts") {

  post <- specify_post(name, collection)

  renv_dir <- full_renv_path(post)
  renv_lib <- full_library_path(post)

  current_working_directory <- getwd()
  on.exit(setwd(current_working_directory))

  # create directories (yes, this is redundant)
  if(!fs::dir_exists(renv_dir)) fs::dir_create(renv_dir)
  if(!fs::dir_exists(renv_lib)) fs::dir_create(renv_lib)

  # initialise a bare project
  renv::init(
    project = renv_dir,
    bare = TRUE,
    restart = FALSE
  )

  # remove unneeded proj file and restores working directory
  proj_file <- fs::path(renv_dir, paste0(name, ".Rproj"))
  if(fs::file_exists(proj_file)) fs::file_delete(proj_file)
  setwd(current_working_directory)

  # ensure the minimal set of packages exists in the library
  renv::install(
    packages = c("renv", "distill", "djnavarro/refinery"),
    library = renv_lib
  )
}

#' Delete the renv set up associated with a post
#'
#' @param name The folder in which the article is located
#' @param collection The collection the article belongs to (default = "posts")
#'
#' @return ??
#' @export
renv_delete <- function(name, collection = "posts") {

  post <- specify_post(name, collection)

  renv_dir <- full_renv_path(post)
  lockfile <- full_lockfile_path(post)

  if(fs::file_exists(lockfile)) fs::file_delete(lockfile)
  fs::dir_delete(renv_dir)
}


