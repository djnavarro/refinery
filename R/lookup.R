
#' Locate articles matching a pattern
#'
#' @param pattern Regular expression
#' @param collection The collection the article belongs to (default = "_posts")
#'
#' @return Character vector of paths
#' @export
article_locate <- function(pattern, collection = "_posts") {
  list.files(
    path = fs::path(site_root(), collection),
    pattern = pattern,
    include.dirs = TRUE
  )
}


#' Situation report for an article
#'
#' @param dir The folder in which the article is located
#' @param collection The collection the article belongs to (default = "_posts")
#'
#' @details Provides a minimal "situation report" for a post, listing the
#' folders associated with the post. Later versions will check renv status, I
#' hope.
#'
#' @return Invisibly returns a list containing the paths
#' @export
#'
article_sitrep <- function(dir, collection = "_posts") {

  sitrep <- list(
    site = site_root(),
    post = post_path(dir, collection),
    lockfile = renv_lockfile(dir, collection),
    library = renv_library(dir, collection)
  )

  cli::cli({
    cli::cli_text("site folder: ", sitrep$site)
    cli::cli_text("post folder: ", sitrep$post)
    cli::cli_text("lockfile:    ", sitrep$lockfile)
    cli::cli_text("library:     ", sitrep$library)
  })

  return(invisible(sitrep))
}
