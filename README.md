
<!-- README.md is generated from README.Rmd. Please edit that file -->

# AusPak

AusPak helps a cricket analyst or fan explore how Australia and Pakistan
score runs and lose wickets across the phases of a men’s One Day
International (ODI) innings. It ships per-over scoring data for the 45
Australia v Pakistan ODIs in the Cricsheet archive, a function that
summarises scoring by phase of the innings, and a Shiny app for
exploring the results.

**Question the app answers:** in which part of an ODI innings does each
side score fastest and lose wickets, and has that changed over time?

Documentation website:
<https://etc5523-2026.github.io/etc5523-assignment-4-somya090997/>

## Installation

``` r
# install.packages("pak")
pak::pak("ETC5523-2026/etc5523-assignment-4-somya090997")
```

## Launch the app

``` r
library(AusPak)
run_app()
```

The app lets you choose the innings (batting first or chasing), a
measure (runs or wickets per over), whether to view phases or individual
overs, and a range of years. A second tab explains the fields and how to
read the results.

## Example

`phase_summary()` returns the average runs and wickets per over by phase
for each team. Here, for the chasing innings in matches from 2010 to
2020:

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
fewer matches because innings end early, so differences built on a
handful of matches are weak evidence.

## What is in the package

| Component | What it does |
|----|----|
| `aus_pak_overs` | Per-over runs and wickets for each innings of each match, with running totals |
| `phase_summary()` | Average runs and wickets per over by team and phase (or by over), for an innings and range of years |
| `run_app()` | Launches the Shiny app |

The data is built by `data-raw/odi-overs.R`, which downloads the ODI
archive and keeps Australia v Pakistan matches. Phases are overs 1 to 10
(powerplay), 11 to 40 (middle) and 41 onwards (death). Wickets include
all dismissal types, including run-outs.

## Data source

Ball-by-ball data from [Cricsheet](https://cricsheet.org), downloaded
with the [cricketdata](https://pkg.robjhyndman.com/cricketdata/)
package. Cricsheet data is shared under an open-data licence; see the
Cricsheet site for its current terms.

The plot styling and the per-over summarising approach are adapted from
an ETC5523 workshop.

## Generative AI declaration

**Generative AI declaration:** I used Claude (Anthropic) to help plan
the package structure, explain and draft code (the `data-raw` script,
`phase_summary()`, the Shiny app and this README), and diagnose errors
(a GitHub credentials error and a `fetch_cricsheet()` error). I ran and
checked the generated code and revised it.
