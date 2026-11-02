# About the data

``` r

library(AusPak)
```

## Where the data comes from

Ball-by-ball records from [Cricsheet](https://cricsheet.org), downloaded
with the cricketdata package. The script `data-raw/odi-overs.R` keeps
every men’s ODI in which Australia and Pakistan played each other, drops
super overs, and summarises each innings over by over.

## What is in `aus_pak_overs`

``` r

length(unique(aus_pak_overs$match_id))   # number of matches
#> [1] 45
range(aus_pak_overs$date)                # first and last match dates
#> [1] "2003-02-11" "2026-06-04"
str(aus_pak_overs)
#> tibble [4,153 × 10] (S3: tbl_df/tbl/data.frame)
#>  $ match_id    : int [1:4153] 65238 65238 65238 65238 65238 65238 65238 65238 65238 65238 ...
#>  $ date        : Date[1:4153], format: "2003-02-11" "2003-02-11" ...
#>  $ venue       : chr [1:4153] "New Wanderers Stadium, Johannesburg" "New Wanderers Stadium, Johannesburg" "New Wanderers Stadium, Johannesburg" "New Wanderers Stadium, Johannesburg" ...
#>  $ innings     : int [1:4153] 1 1 1 1 1 1 1 1 1 1 ...
#>  $ batting_team: chr [1:4153] "Australia" "Australia" "Australia" "Australia" ...
#>  $ over        : num [1:4153] 1 2 3 4 5 6 7 8 9 10 ...
#>  $ over_runs   : int [1:4153] 7 2 3 3 9 3 8 7 6 4 ...
#>  $ over_wickets: int [1:4153] 0 0 1 0 0 0 0 0 0 0 ...
#>  $ score       : int [1:4153] 7 9 12 15 24 27 35 42 48 52 ...
#>  $ wickets     : int [1:4153] 0 0 1 1 1 1 1 1 1 1 ...
```

| Column             | Meaning                                  |
|--------------------|------------------------------------------|
| `match_id`         | Cricsheet match identifier               |
| `date`             | Date the match started                   |
| `venue`            | Ground                                   |
| `innings`          | 1 (batting first) or 2 (chasing)         |
| `batting_team`     | Team batting in that innings             |
| `over`             | Over number, from 1                      |
| `over_runs`        | Runs in the over, including extras       |
| `over_wickets`     | Wickets in the over, all dismissal types |
| `score`, `wickets` | Running totals at the end of the over    |

## Things to keep in mind

- Rain-shortened matches are still labelled by over number.
- Late overs come from fewer matches, because innings end early.
- Wickets include run-outs and every other dismissal type.
