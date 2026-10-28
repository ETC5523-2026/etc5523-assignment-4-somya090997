#' Launch the Australia v Pakistan scoring explorer
#'
#' Opens the Shiny app included in the package. It lets you compare how
#' Australia and Pakistan score and lose wickets across the phases of an
#' ODI innings, using the [aus_pak_overs] data.
#'
#' @param ... Further arguments passed to [shiny::runApp()], for example
#'   `launch.browser = FALSE`.
#' @return Called for its side effect of starting the app. It returns
#'   nothing useful.
#' @importFrom shiny runApp
#' @importFrom bslib bs_theme
#' @importFrom ggplot2 ggplot
#' @export
#' @examples
#' if (interactive()) {
#'   run_app()
#' }
run_app <- function(...) {
  app_dir <- system.file("app", package = "AusPak")
  if (app_dir == "") {
    stop("Could not find the app. Try reinstalling `AusPak`.", call. = FALSE)
  }
  shiny::runApp(app_dir, ...)
}

