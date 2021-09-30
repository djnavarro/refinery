


specify_post <- function(name, collection) {
  collection <- paste0("_", collection)
  fs::path(collection, name)
}


# these return full paths -------------------------------------------------

site_root <- function() {
  rprojroot::find_root("_site.yml")
}

full_post_path <- function(article) {
  fs::path(site_root(), article)
}

full_renv_path <- function(article) {
  fs::path(site_root(), "_renv", article)
}

full_lockfile_path <- function(article) {
  fs::path(full_renv_path(article), "renv.lock")
}

full_library_path <- function(article) {
  renv::paths$library(project = full_renv_path(article))
}

