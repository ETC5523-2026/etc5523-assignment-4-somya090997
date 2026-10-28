# data-raw/odi-overs.R
# Builds the per-over Australia v Pakistan ODI dataset shipped with the package.
# Source: Cricsheet (https://cricsheet.org), downloaded via the cricketdata package.
library(dplyr)
options(timeout = 300)

teams <- c("Australia", "Pakistan")

balls <- cricketdata::fetch_cricsheet(
  type = "bbb", gender = "male", competition = "odis"
)

aus_pak_overs <- balls |>
  filter(
    batting_team %in% teams, bowling_team %in% teams,
    innings %in% 1:2                       # drops super overs
  ) |>
  mutate(
    date = as.Date(start_date),
    total_runs = runs_off_bat + extras,
    over = floor(ball) + 1L,
    # cricketdata stores unused character fields as "", not NA
    is_wicket = !is.na(player_dismissed) & trimws(player_dismissed) != ""
  ) |>
  group_by(match_id, date, venue, innings, batting_team, over) |>
  summarise(over_runs = sum(total_runs),
            over_wickets = sum(is_wicket),
            .groups = "drop") |>
  group_by(match_id, innings) |>
  arrange(over, .by_group = TRUE) |>
  mutate(score = cumsum(over_runs), wickets = cumsum(over_wickets)) |>
  ungroup()

n_distinct(aus_pak_overs$match_id)         # how many matches?
format(object.size(aus_pak_overs), units = "MB")

usethis::use_data(aus_pak_overs, overwrite = TRUE, compress = "xz")



