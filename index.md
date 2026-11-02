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

## Where the data comes from

Ball-by-ball records from [Cricsheet](https://cricsheet.org), downloaded
with the cricketdata package. The script `data-raw/odi-overs.R` keeps
every men’s ODI in which Australia and Pakistan played each other, drops
super overs, and summarises each innings over by over.

## What is in `aus_pak_overs`

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
