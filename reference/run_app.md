# Launch the Australia v Pakistan scoring explorer

Opens the Shiny app included in the package. It lets you compare how
Australia and Pakistan score and lose wickets across the phases of an
ODI innings, using the
[aus_pak_overs](https://etc5523-2026.github.io/etc5523-assignment-4-somya090997/reference/aus_pak_overs.md)
data.

## Usage

``` r
run_app(...)
```

## Arguments

- ...:

  Further arguments passed to
  [`shiny::runApp()`](https://rdrr.io/pkg/shiny/man/runApp.html), for
  example `launch.browser = FALSE`.

## Value

Called for its side effect of starting the app. It returns nothing
useful.

## Examples

``` r
if (interactive()) {
  run_app()
}
```
