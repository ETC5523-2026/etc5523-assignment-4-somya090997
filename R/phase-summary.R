#' Average scoring by phase of an innings
#'
#' Summarises runs and wickets per over for each team, either by phase of
#' the innings (powerplay, middle overs, death overs) or over by over,
#' for one innings and a range of years.
#'
#' @param overs A data frame of per-over scoring, such as [aus_pak_overs],
#'   with columns `match_id`, `date`, `innings`, `batting_team`, `over`,
#'   `over_runs` and `over_wickets`.
#' @param innings Which innings to summarise: 1 (batting first) or 2
#'   (chasing).
#' @param years Optional vector of two years, `c(first, last)`, to keep
#'   only matches starting in that range (inclusive). `NULL` keeps all
#'   matches.
#' @param by Either `"phase"` (powerplay, overs 1 to 10; middle, 11 to 40;
#'   death, 41 onwards) or `"over"` (one row per over number).
#' @return A data frame with one row per team and phase (or over), with
#'   columns `batting_team`, the grouping column (`phase` or `over`),
#'   `matches` (number of matches contributing), `runs_per_over` and
#'   `wickets_per_over`. It has zero rows if no matches fall in the
#'   chosen range.
#' @details Averages only use overs that were actually bowled, so late
#'   overs can come from fewer matches when innings end early. Phases are
#'   defined by over number, including in matches shortened by rain.
#'   Check `matches` before reading much into a result.
#' @importFrom dplyr group_by summarise n_distinct
#' @importFrom rlang .data
#' @export
#' @examples
#' # Average scoring by phase, first innings, all years
#' phase_summary(aus_pak_overs)
#'
#' # Chasing innings in a narrower range of years
#' phase_summary(aus_pak_overs, innings = 2, years = c(2010, 2020))
#'
#' # Over by over instead of by phase
#' head(phase_summary(aus_pak_overs, by = "over"))
phase_summary <- function(overs, innings = 1, years = NULL,
                          by = c("phase", "over")) {
  by <- match.arg(by)

  needed <- c("match_id", "date", "innings", "batting_team", "over",
              "over_runs", "over_wickets")
  absent <- setdiff(needed, names(overs))
  if (length(absent) > 0) {
    stop("`overs` is missing columns: ", paste(absent, collapse = ", "),
         call. = FALSE)
  }
  if (length(innings) != 1 || !innings %in% 1:2) {
    stop("`innings` must be 1 or 2.", call. = FALSE)
  }

  year <- as.integer(format(overs$date, "%Y"))
  if (is.null(years)) years <- range(year, na.rm = TRUE)
  if (length(years) != 2 || anyNA(years) || years[1] > years[2]) {
    stop("`years` must be two years, first no later than last.",
         call. = FALSE)
  }

  # Base subsetting: `innings` is both an argument and a column name
  d <- overs[overs$innings == innings & year >= years[1] & year <= years[2],
             , drop = FALSE]
  d$phase <- cut(d$over, breaks = c(0, 10, 40, Inf),
                 labels = c("Powerplay (1-10)", "Middle (11-40)",
                            "Death (41+)"))
  d$group <- if (by == "phase") d$phase else d$over

  out <- d |>
    group_by(.data$batting_team, .data$group) |>
    summarise(
      matches = n_distinct(.data$match_id),
      runs_per_over = mean(.data$over_runs),
      wickets_per_over = mean(.data$over_wickets),
      .groups = "drop"
    )
  names(out)[names(out) == "group"] <- by
  out
}
