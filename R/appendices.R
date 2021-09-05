

#' Records a time stamp to the R markdown output
#'
#' @param tzone Character vector specifying the time zone
#'
#' @return A "shiny.tag" object
#' @export
record_timestamp <- function(tzone = Sys.timezone()) {
  time <- lubridate::now(tzone = tzone)
  stamp <- as.character(time, tz = tzone, usetz = TRUE)
  return(htmltools::span(stamp))
}

#' Records a link to the lock file
#'
#' @param dir The folder in which the article is located
#' @param collection The collection the article belongs to (default = "_posts")
#' @param repo_spec Repository specification, formatted as "user/repo_name"
#' @param branch Name of the branch to look at
#' @param host Host URL
#' @param text Text to display in the link
#'
#' @return A "shiny.tag" object
#' @export
record_lockfile <- function(repo_spec, dir, collection = "_posts",
                            branch = "master", host = "https://github.com",
                            text = "R environment") {
  path <- paste(
    host, repo_spec, "tree", branch, "_refinery", collection, dir,
    "renv.lock", sep = "/"
  )
  return(htmltools::a(href = path, text))
}


#' Records a link to the source code
#'
#' @param dir The folder in which the article is located
#' @param collection The collection the article belongs to (default = "_posts")
#' @param repo_spec Repository specification, formatted as "user/repo_name"
#' @param branch Name of the branch to look at
#' @param host Host URL
#' @param text Text to display in the link
#'
#' @return A "shiny.tag" object
#' @export
record_source <- function(repo_spec, dir, collection = "_posts",
                            branch = "master", host = "https://github.com",
                            text = "R environment") {
  path <- paste(
    host, repo_spec, "tree", branch, collection, dir, sep = "/"
  )
  return(htmltools::a(href = path, text))
}
