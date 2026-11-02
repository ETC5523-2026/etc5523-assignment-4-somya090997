# Average scoring by phase of an innings

Summarises runs and wickets per over for each team, either by phase of
the innings (powerplay, middle overs, death overs) or over by over, for
one innings and a range of years.

## Usage

``` r
phase_summary(overs, innings = 1, years = NULL, by = c("phase", "over"))
```

## Arguments

- overs:

  A data frame of per-over scoring, such as
  [aus_pak_overs](https://etc5523-2026.github.io/etc5523-assignment-4-somya090997/reference/aus_pak_overs.md),
  with columns `match_id`, `date`, `innings`, `batting_team`, `over`,
  `over_runs` and `over_wickets`.

- innings:

  Which innings to summarise: 1 (batting first) or 2 (chasing).

- years:

  Optional vector of two years, `c(first, last)`, to keep only matches
  starting in that range (inclusive). `NULL` keeps all matches.

- by:

  Either `"phase"` (powerplay, overs 1 to 10; middle, 11 to 40; death,
  41 onwards) or `"over"` (one row per over number).

## Value

A data frame with one row per team and phase (or over), with columns
`batting_team`, the grouping column (`phase` or `over`), `matches`
(number of matches contributing), `runs_per_over` and
`wickets_per_over`. It has zero rows if no matches fall in the chosen
range.

## Details

Averages only use overs that were actually bowled, so late overs can
come from fewer matches when innings end early. Phases are defined by
over number, including in matches shortened by rain. Check `matches`
before reading much into a result.

## Examples

``` r
# Average scoring by phase, first innings, all years
phase_summary(aus_pak_overs)
#> # A tibble: 6 × 5
#>   batting_team phase            matches runs_per_over wickets_per_over
#>   <chr>        <fct>              <int>         <dbl>            <dbl>
#> 1 Australia    Powerplay (1-10)      31          5.15            0.106
#> 2 Australia    Middle (11-40)        31          4.89            0.144
#> 3 Australia    Death (41+)           28          7.38            0.358
#> 4 Pakistan     Powerplay (1-10)      14          3.9             0.143
#> 5 Pakistan     Middle (11-40)        14          4.66            0.131
#> 6 Pakistan     Death (41+)           13          5.49            0.395

# Chasing innings in a narrower range of years
phase_summary(aus_pak_overs, innings = 2, years = c(2010, 2020))
#> # A tibble: 6 × 5
#>   batting_team phase            matches runs_per_over wickets_per_over
#>   <chr>        <fct>              <int>         <dbl>            <dbl>
#> 1 Australia    Powerplay (1-10)       9          5.16           0.122 
#> 2 Australia    Middle (11-40)         9          5.06           0.0871
#> 3 Australia    Death (41+)            8          6.59           0.131 
#> 4 Pakistan     Powerplay (1-10)      15          4.58           0.127 
#> 5 Pakistan     Middle (11-40)        15          4.94           0.167 
#> 6 Pakistan     Death (41+)           12          5.89           0.443 

# Over by over instead of by phase
head(phase_summary(aus_pak_overs, by = "over"))
#> # A tibble: 6 × 5
#>   batting_team  over matches runs_per_over wickets_per_over
#>   <chr>        <dbl>   <int>         <dbl>            <dbl>
#> 1 Australia        1      31          4.06           0.194 
#> 2 Australia        2      31          4.52           0.0645
#> 3 Australia        3      31          4.58           0.0645
#> 4 Australia        4      31          5.26           0.0323
#> 5 Australia        5      31          5.58           0.129 
#> 6 Australia        6      31          5.97           0.129 
```
