

site_root <- function() {
  rprojroot::find_root("_site.yml")
}

post_path <- function(dir, collection = "posts", root = site_root()) {
  collection <- with_underscore(collection)
  fs::path(
    root,
    collection,
    dir
  )
}

renv_path <- function(dir, collection = "posts", root = site_root()) {
  collection <- with_underscore(collection)
  fs::path(
    root,
    "_renv",
    collection,
    dir
  )
}

renv_lockfile <- function(dir, collection = "posts") {
  collection <- with_underscore(collection)
  fs::path(renv_path(dir, collection), "renv.lock")
}


renv_library <- function(dir, collection = "posts") {
  collection <- with_underscore(collection)
  renv::paths$library(project = renv_path(dir, collection))
}
