# Australia v Pakistan men's ODI scoring, over by over

Runs and wickets in each over of every men's One Day International
between Australia and Pakistan in the Cricsheet archive, with running
totals for each innings.

## Usage

``` r
aus_pak_overs
```

## Format

A data frame with 4,153 rows and 10 columns:

- match_id:

  Cricsheet match identifier

- date:

  Date the match started

- venue:

  Ground where the match was played

- innings:

  Innings number (1 or 2); super overs are excluded

- batting_team:

  Team batting in that innings

- over:

  Over number, starting at 1

- over_runs:

  Runs scored in the over, including extras

- over_wickets:

  Wickets in the over, all dismissal types including run-outs

- score:

  Cumulative runs at the end of the over

- wickets:

  Cumulative wickets at the end of the over

## Source

Ball-by-ball data from Cricsheet, <https://cricsheet.org>, downloaded
with the cricketdata package. Cricsheet data is shared under an
open-data licence, so check its current wording on the site and keep
this credit in the README too.

## Details

Matches shortened by rain have fewer overs, and an innings that ends
early (all out or chase completed) stops at its final over. Match
results are not included.
