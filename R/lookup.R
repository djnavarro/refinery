
#' Locate articles matching a pattern
#'
#' @param pattern Regular expression
#' @param collection The collection the article belongs to (default = "posts")
#'
#' @return Character vector of paths
#' @export
article_named <- function(pattern, collection = "posts") {
  collection <- with_underscore(collection)
  list.files(
    path = fs::path(site_root(), collection),
    pattern = pattern,
    include.dirs = TRUE
  )
}


#' Situation report for an article
#'
#' @param dir The folder in which the article is located
#' @param collection The collection the article belongs to (default = "posts")
#'
#' @details Provides a minimal "situation report" for a post, listing the
#' folders associated with the post. Later versions will check renv status, I
#' hope.
#'
#' @return Invisibly returns a list containing the paths
#' @export
#'
article_sitrep <- function(dir, collection = "posts") {

  collection <- with_underscore(collection)
  sitrep <- list(
    site = site_root(),
    post = post_path(dir, collection),
    lockfile = renv_lockfile(dir, collection),
    library = renv_library(dir, collection)
  )

  cli::cli({
    cli::cli_h1("Article paths")
    cli::cli_h2("Site root folder")
    cli::cli_text(sitrep$site)
    cli::cli_h2("Post root folder")
    cli::cli_text(sitrep$post)
    cli::cli_h2("Lockfile path")
    cli::cli_text(sitrep$lockfile)
    cli::cli_h2("Package library")
    cli::cli_text(sitrep$library)
    cli::cli_end()
  })

  return(invisible(sitrep))
}
