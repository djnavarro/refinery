

site_root <- function() {
  rprojroot::find_root("_site.yml")
}

post_path <- function(dir, collection = "_posts", root = site_root()) {
  fs::path(
    root,
    collection,
    dir
  )
}

renv_path <- function(dir, collection = "_posts", root = site_root()) {
  fs::path(
    root,
    "_renv",
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
