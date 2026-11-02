# Exploring Australia v Pakistan ODI scoring with AusPak

## Who this is for

AusPak is for a cricket analyst or fan who wants to compare how
Australia and Pakistan score runs and lose wickets across an ODI
innings. The app helps answer one question: **in which part of an
innings does each side score fastest and lose wickets, and has that
changed over time?**

## Install

``` r

# install.packages("pak")
pak::pak("ETC5523-2026/etc5523-assignment-4-somya090997")
```

## Launch the app

``` r

library(AusPak)
run_app()
```

The app opens in a window or in your browser. Press the stop button in
the R console when you want to close it.

## What The Control Does?

| Control | What it does                                            |
|---------|---------------------------------------------------------|
| Innings | Batting first (1st innings) or chasing (2nd innings)    |
| Measure | Average runs per over, or average wickets lost per over |
| Show by | Three phases of the innings, or every individual over   |
| Years   | Keeps only matches that started in this range           |

The two coloured boxes show how many matches each team contributes to
the current view. Gold is Australia and green is Pakistan throughout the
app. The section “What do the phases mean?” in the sidebar defines the
phases: powerplay is overs 1 to 10, middle is overs 11 to 40, and death
is overs 41 onwards.

## How To Read the Results?

1.  Start with the sentence under “What stands out”. It names the phase
    with the biggest gap between the teams for the current settings.
2.  Compare the gold and green bars within each phase. A taller bar
    means faster scoring, or more wickets if you chose that measure.
3.  Check the match counts under each bar. A gap that rests on a handful
    of matches is weak evidence.
4.  Change the years and see whether the gap holds in other eras.

For example, with Australia batting first across all years, the app
shows Australia scoring faster than Pakistan in the death overs.
Narrowing the years shows how much that gap depends on which matches are
included.

If the chosen settings leave fewer than three matches for either team,
the app shows an amber message in place of the chart. Widen the years or
switch innings to continue.

## Use the function directly

The same summary the app uses is available as
[`phase_summary()`](https://etc5523-2026.github.io/etc5523-assignment-4-somya090997/reference/phase_summary.md):

``` r

library(AusPak)

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
```

Read the `matches` column alongside the averages. Late overs come from
fewer matches because innings end early.

``` r

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

## Limitations

- There are 45 Australia v Pakistan ODIs in the data, so narrow year
  ranges leave few matches.
- Phases are defined by over number only. Playing conditions have
  changed over the years, and rain-shortened matches are still grouped
  by over number.
- Wickets include every dismissal type, including run-outs.
- The app does not account for opponents’ form, pitches or conditions.

Data: ball-by-ball records from [Cricsheet](https://cricsheet.org),
accessed through the cricketdata package.
