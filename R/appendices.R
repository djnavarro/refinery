

#' Writes a time stamp to the R markdown output
#'
#' @param tzone Character vector specifying the time zone
#'
#' @return A "shiny.tag" object
#' @export
timestamp <- function(tzone = Sys.timezone()) {
  time <- lubridate::now(tzone = tzone)
  stamp <- as.character(time, tz = tzone, usetz = TRUE)
  return(htmltools::p(stamp))
}

