library(shiny)
library(bslib)
library(ggplot2)
library(AusPak)

team_colours <- c("Australia" = "#C58A00", "Pakistan" = "#008000")
min_matches  <- 3   # fewer matches than this is too thin to report
year_range   <- range(as.integer(format(aus_pak_overs$date, "%Y")))

# Plot theme adapted from the ETC5523 workshop's theme_broadcast()
theme_app <- function(base_size = 14) {
  theme_minimal(base_size = base_size) +
    theme(
      panel.grid.minor = element_blank(),
      panel.grid.major.x = element_blank(),
      text = element_text(colour = "#142B3A"),
      axis.text = element_text(colour = "#344955"),
      legend.position = "top",
      legend.title = element_blank(),
      plot.title.position = "plot",
      plot.caption = element_text(colour = "#526773", hjust = 0)
    )
}

ui <- page_sidebar(
  title = "Australia v Pakistan ODIs: where do the runs and wickets come?",
  theme = bs_theme(
    version = 5, bg = "#FFFFFF", fg = "#142B3A", primary = "#0072B2",
    base_font = font_collection("Segoe UI", "Helvetica Neue", "Arial", "sans-serif")
  ),
  tags$head(tags$style(HTML("
    .question-box { background:#F1F6F9; border-left:4px solid #0072B2;
                    padding:.75rem 1rem; margin-bottom:1rem; border-radius:4px; }
    .shiny-output-error-validation { color:#8A4B00; background:#FFF6E5;
                    border-left:4px solid #C58A00; padding:1rem; font-size:1.05rem; }
    .guide h5 { margin-top:1.25rem; color:#0072B2; }
  "))),
  sidebar = sidebar(
    width = 320,
    radioButtons("innings", "Innings",
                 choices = c("Batting first (1st innings)" = 1, "Chasing (2nd innings)" = 2)),
    radioButtons("measure", "Measure",
                 choices = c("Runs per over" = "runs_per_over",
                             "Wickets lost per over" = "wickets_per_over")),
    radioButtons("by", "Show by",
                 choices = c("Phase of innings" = "phase", "Each over" = "over")),
    sliderInput("years", "Years", min = year_range[1], max = year_range[2],
                value = year_range, step = 1, sep = "")
  ),
  div(class = "question-box",
      strong("Who it is for: "), "a cricket analyst or fan comparing Australia and Pakistan.",
      br(),
      strong("Question: "), "In which part of an ODI innings does each side score fastest
    and lose wickets, and has that changed over time?"
  ),
  navset_card_tab(
    nav_panel("Explore",
              plotOutput("plot", height = 380),
              tableOutput("table")
    ),
    nav_panel("How to use and read this",
              div(class = "guide",
                  h5("The controls"),
                  tags$ul(
                    tags$li(strong("Innings: "), "batting first (1st innings) or chasing (2nd innings)."),
                    tags$li(strong("Measure: "), "average runs scored or wickets lost per over."),
                    tags$li(strong("Show by: "), "three phases (a summary) or every over (more detail, noisier)."),
                    tags$li(strong("Years: "), "only matches starting in this range are included.")
                  ),
                  h5("The fields"),
                  tags$ul(
                    tags$li(strong("Phase: "), "Powerplay is overs 1 to 10, Middle 11 to 40, Death 41 onwards."),
                    tags$li(strong("Matches: "), "how many matches contribute to that figure."),
                    tags$li(strong("Runs per over: "), "mean runs per over, including extras."),
                    tags$li(strong("Wickets per over: "), "mean wickets per over, counting every dismissal type including run-outs.")
                  ),
                  h5("How to read the results"),
                  p("Taller bars or higher lines mean faster scoring or more wickets. Compare the
          gold (Australia) and blue (Pakistan) bars within a phase to see who is stronger
          there, then change the years to see whether the gap holds in other eras. Always
          check the match counts: a difference built on a handful of matches is weak evidence."),
                  h5("Limits"),
                  p("There are only 45 Australia v Pakistan ODIs in the data, so ranges narrow quickly.
          Overs in rain-shortened matches are still labelled by over number, and late overs
          come from fewer matches because innings end early. The app does not account for
          opponents' form, pitches or conditions."),
                  p(em("Data: Cricsheet (cricsheet.org), via the cricketdata package."))
              )
    )
  )
)

server <- function(input, output, session) {

  results <- reactive({
    phase_summary(aus_pak_overs, innings = as.integer(input$innings),
                  years = input$years, by = input$by)
  })

  # Drop rows built from too few matches
  usable <- reactive({
    d <- results()
    d[d$matches >= min_matches, , drop = FALSE]
  })

  output$plot <- renderPlot({
    d <- usable()
    validate(need(
      length(unique(d$batting_team)) == 2,
      paste0("Not enough matches to compare both teams. Each team needs at least ",
             min_matches, " matches in the chosen innings and years. ",
             "Try widening the year range or switching innings.")
    ))

    d$value <- d[[input$measure]]
    ylab <- if (input$measure == "runs_per_over") "Average runs per over" else "Average wickets per over"

    if (input$by == "phase") {
      ggplot(d, aes(phase, value, fill = batting_team)) +
        geom_col(position = position_dodge(width = 0.8), width = 0.7) +
        geom_text(aes(label = paste(matches, "matches")),
                  position = position_dodge(width = 0.8), vjust = -0.5,
                  size = 3.8, colour = "#344955") +
        scale_fill_manual(values = team_colours) +
        scale_y_continuous(expand = expansion(mult = c(0, 0.15))) +
        labs(x = NULL, y = ylab) +
        theme_app()
    } else {
      ggplot(d, aes(over, value, colour = batting_team)) +
        geom_line(linewidth = 1) +
        scale_colour_manual(values = team_colours) +
        labs(x = "Over", y = ylab,
             caption = paste("Overs bowled in fewer than", min_matches, "matches are hidden.")) +
        theme_app()
    }
  })

  output$table <- renderTable({
    req(input$by == "phase")
    d <- usable()
    req(length(unique(d$batting_team)) == 2)
    data.frame(
      Team = d$batting_team,
      Phase = as.character(d$phase),
      Matches = d$matches,
      `Runs per over` = round(d$runs_per_over, 2),
      `Wickets per over` = round(d$wickets_per_over, 3),
      check.names = FALSE
    )
  })
}

shinyApp(ui, server)
