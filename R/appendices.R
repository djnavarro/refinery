
#' Inserts the default refinery appendix
#'
#' @param name The folder in which the article is located
#' @param collection The collection the article belongs to (default = "posts")
#' @param repo_spec Repository specification, formatted as "user/repo_name"
#'
#' @return A shiny.tag object
#' @export
insert_appendix <- function(repo_spec, name, collection = "posts") {

  appendices <- paste(
    markdown_appendix(
      name = "Last updated",
      content = insert_timestamp()
    ),
    " ",
    markdown_appendix(
      name = "Details",
      content = paste(
        insert_source(repo_spec, name, collection),
        insert_lockfile(repo_spec, name, collection),
        sep = ", "
      )
    ),
    sep = "\n"
  )
  knitr::asis_output(appendices)
}


markdown_appendix <- function(name, content) {
  paste(
    paste("##", name, "{.appendix}"),
    " ",
    content,
    sep = "\n"
  )
}

markdown_link <- function(text, path) {
  paste0("[", text, "](", path, ")")
}

#' Records a time stamp to the R markdown output
#'
#' @param tzone Character vector specifying the time zone
#'
#' @return A "shiny.tag" object
#' @export
insert_timestamp <- function(tzone = Sys.timezone()) {
  time <- lubridate::now(tzone = tzone)
  stamp <- as.character(time, tz = tzone, usetz = TRUE)
  return(stamp)
}

#' Inserts a link to the lock file
#'
#' @param name The folder in which the article is located
#' @param collection The collection the article belongs to (default = "posts")
#' @param repo_spec Repository specification, formatted as "user/repo_name"
#' @param branch Name of the branch to look at
#' @param host Host URL
#' @param text Text to display in the link
#'
#' @return A "shiny.tag" object
#' @export
insert_lockfile <- function(repo_spec, name, collection = "posts",
                            branch = "master", host = "https://github.com",
                            text = "R environment") {

  collection <- paste0("_", collection)

  path <- paste(
    host, repo_spec, "tree", branch, "_renv", collection, name,
    "renv.lock", sep = "/"
  )
  return(markdown_link(text, path))
}

#' Inserts a link to the source code
#'
#' @param name The folder in which the article is located
#' @param collection The collection the article belongs to (default = "posts")
#' @param repo_spec Repository specification, formatted as "user/repo_name"
#' @param branch Name of the branch to look at
#' @param host Host URL
#' @param text Text to display in the link
#'
#' @return A "shiny.tag" object
#' @export
insert_source <- function(repo_spec, name, collection = "posts",
                          branch = "master", host = "https://github.com",
                          text = "source code") {
  path <- paste(
    host, repo_spec, "tree", branch, paste0("_", collection),
    name, "index.Rmd", sep = "/"
  )
  return(markdown_link(text, path))
}



#' Setup redirections for netlify deployment
#'
#' @param slug The slug for the post
#' @param date The date for the post
#' @param collection The collection (default = "posts")
#' @param publish The publish directory (default = "_site")
#'
#' @return ???
#' @export
insert_netlify_redirect <- function(slug, date, collection = "posts", publish = "_site") {

  # TODO: should ensure that _redirects is an included file in _site.yml or
  # else distill will not copy it to the output directory

  elegant_url <- paste0("/", slug)
  verbose_url <- paste0("/", collection, "/", date, "_", slug)
  redirection <- paste(elegant_url, verbose_url)

  blogroot <- rprojroot::find_root("_site.yml")
  redirect_file <- fs::path(blogroot, "_redirects")
  redirect_file_public <- fs::path(blogroot, publish, "_redirects")

  content <- brio::read_lines(redirect_file)
  if(!any(content == redirection)) {
    content <- c(content, redirection)
    brio::write_lines(content, redirect_file)
    fs::file_copy(
      path = redirect_file,
      new_path = redirect_file_public,
      overwrite = TRUE
    )
  }
}


