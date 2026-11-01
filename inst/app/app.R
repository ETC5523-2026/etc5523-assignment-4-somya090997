library(shiny)
library(bslib)
library(ggplot2)
library(AusPak)

aus_col <- "#C58A00"
pak_col <- "#007A53"
ink     <- "#142B3A"
chrome  <- "#26414B"
page_bg <- "#FBF6EA"

team_colours <- c("Australia" = aus_col, "Pakistan" = pak_col)
min_matches  <- 3   # fewer matches than this is too thin to report
year_range   <- range(as.integer(format(aus_pak_overs$date, "%Y")))

# Plot theme adapted from the ETC5523 workshop's theme_broadcast()
theme_app <- function(base_size = 14) {
  theme_minimal(base_size = base_size) +
    theme(
      panel.grid.minor = element_blank(),
      panel.grid.major.x = element_blank(),
      panel.grid.major.y = element_line(colour = "#E3EAEF", linewidth = 0.4),
      text = element_text(colour = ink),
      axis.text = element_text(colour = "#344955"),
      axis.title = element_text(colour = "#344955"),
      legend.position = "top",
      legend.title = element_blank(),
      legend.text = element_text(size = base_size),
      plot.title.position = "plot",
      plot.caption = element_text(colour = "#526773", hjust = 0)
    )
}

app_css <- paste0("
  .hero { background:
            linear-gradient(90deg, ", aus_col, " 50%, ", pak_col, " 50%) bottom / 100% 8px no-repeat,
            #10252E;
          color: #FFFFFF; padding: 1.6rem 1.8rem 2rem 1.8rem; border-radius: 14px;
          margin-bottom: 1.1rem; }
  .hero h1 { font-weight: 800; font-size: 1.7rem; margin: 0 0 .35rem 0; }
  .hero p  { margin: 0; font-size: 1.05rem; opacity: .95; }
  .hero .tag { display:inline-block; background: rgba(255,255,255,.16);
               border-radius: 999px; padding: .15rem .75rem; font-size: .85rem;
               margin-bottom: .6rem; letter-spacing: .02em; }
  .vb-aus { background: ", aus_col, " !important; color: ", ink, " !important; }
  .vb-pak { background: ", pak_col, " !important; color: #FFFFFF !important; }
  .vb-aus .value-box-title, .vb-pak .value-box-title { font-size: .95rem; font-weight: 600; }
  .vb-aus .value-box-value, .vb-pak .value-box-value { font-size: 2rem; font-weight: 800; }
  .card { background: #FFFFFF; border: 0; box-shadow: 0 2px 10px rgba(20,43,58,.08); border-radius: 14px; }
  .bslib-sidebar-layout > .sidebar { background: #FFFFFF; }
  .takeaway { background: #F1F6F9; border-left: 5px solid ", chrome, "; border-radius: 6px;
              padding: .8rem 1rem; margin-bottom: 1rem; font-size: 1.05rem; }
  .shiny-output-error-validation { color:#8A4B00; background:#FFF6E5;
              border-left:5px solid ", aus_col, "; border-radius:6px; padding:1.1rem;
              font-size:1.1rem; }
  .guide h5 { margin-top: 1.3rem; color: ", chrome, "; font-weight: 700; }
  table.table { font-size: 1rem; }
  .glossary summary { font-weight: 700; cursor: pointer; color: ", chrome, "; margin-bottom: .5rem; }
  .glossary dt { font-weight: 700; margin-top: .6rem; font-size: .95rem; }
  .glossary dd { margin: 0; font-size: .9rem; color: #344955; }
  .glossary-note { font-size: .82rem; color: #526773; margin-top: .8rem; }
")

ui <- page_sidebar(
  title = NULL,
  fillable = FALSE,
  theme = bs_theme(
    version = 5, bg = page_bg, fg = ink, primary = chrome,
    base_font = font_collection("Inter", "Segoe UI", "Helvetica Neue",
                                "Arial", "sans-serif")
  ),
  tags$head(
    # Inter loads when online; the font stack above is the fallback
    tags$link(rel = "stylesheet",
              href = "https://fonts.googleapis.com/css2?family=Inter:wght@400;600;800&display=swap"),
    tags$style(HTML(app_css))
  ),

  sidebar = sidebar(
    width = 320,
    h5("Explore", style = "font-weight:800;"),
    radioButtons("innings", "Innings",
                 choices = c("Batting first (1st innings)" = 1, "Chasing (2nd innings)" = 2)),
    radioButtons("measure", "Measure",
                 choices = c("Runs per over" = "runs_per_over",
                             "Wickets lost per over" = "wickets_per_over")),
    radioButtons("by", "Show by",
                 choices = c("Phase of innings" = "phase", "Each over" = "over")),
    sliderInput("years", "Years", min = year_range[1], max = year_range[2],
                value = year_range, step = 1, sep = ""),

    hr(),
    tags$details(
      class = "glossary", open = "open",
      tags$summary("What do the phases mean?"),
      tags$dl(
        tags$dt("Powerplay (overs 1-10)"),
        tags$dd("The opening overs. Fielding restrictions apply, so batters can score
                 quickly, and the new ball can also bring early wickets."),
        tags$dt("Middle (overs 11-40)"),
        tags$dd("The longest stretch. Restrictions ease, and teams usually build the
                 innings steadily and try to keep wickets in hand."),
        tags$dt("Death (overs 41-50)"),
        tags$dd("The closing overs. Batters usually attack, so runs come faster, and
                 wickets can fall as they take risks.")
      ),
      p(class = "glossary-note",
        "The app sorts overs into these bands by over number only. Rules have changed
         over the years, and rain-shortened matches are still grouped by over number.")
    )
  ),

  div(class = "hero",
      div(class = "tag", "For cricket analysts and fans"),
      h1("Australia v Pakistan ODIs"),
      p("In which part of an innings does each side score fastest and lose wickets,
       and has that changed over time?")
  ),

  layout_columns(
    fill = FALSE,
    value_box(title = "Australia: matches in view",
              value = textOutput("n_aus"), class = "vb-aus"),
    value_box(title = "Pakistan: matches in view",
              value = textOutput("n_pak"), class = "vb-pak")
  ),

  navset_card_tab(
    nav_panel("Explore",
              uiOutput("takeaway"),
              plotOutput("plot", height = 400),
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
                  p("Taller bars or higher lines mean faster scoring or more wickets lost. Compare the
          gold (Australia) and green (Pakistan) bars within a phase to see who is stronger
          there, then change the years to see whether the gap holds in other eras. The
          sentence above the chart names the largest gap for the current settings. Always
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

  # Matches in view for each team (innings and years only)
  counts <- reactive({
    d <- aus_pak_overs
    yr <- as.integer(format(d$date, "%Y"))
    d <- d[d$innings == as.integer(input$innings) &
             yr >= input$years[1] & yr <= input$years[2], , drop = FALSE]
    tapply(d$match_id, d$batting_team, function(x) length(unique(x)))
  })
  count_for <- function(team) {
    x <- counts()
    if (team %in% names(x) && !is.na(x[[team]])) x[[team]] else 0
  }
  output$n_aus <- renderText(count_for("Australia"))
  output$n_pak <- renderText(count_for("Pakistan"))

  output$takeaway <- renderUI({
    req(input$by == "phase")
    d <- usable()
    req(length(unique(d$batting_team)) == 2)
    d$value <- d[[input$measure]]
    a <- d[d$batting_team == "Australia", c("phase", "value")]
    p <- d[d$batting_team == "Pakistan",  c("phase", "value")]
    m <- merge(a, p, by = "phase", suffixes = c("_aus", "_pak"))
    req(nrow(m) > 0)
    m$gap <- m$value_aus - m$value_pak
    top <- m[which.max(abs(m$gap)), , drop = FALSE]
    unit <- if (input$measure == "runs_per_over") "runs per over" else "wickets lost per over"
    div(class = "takeaway",
        strong("What stands out: "),
        sprintf("the biggest gap is in the %s. Australia %.2f vs Pakistan %.2f %s.",
                tolower(as.character(top$phase)), top$value_aus, top$value_pak, unit)
    )
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
    ylab <- if (input$measure == "runs_per_over") "Average runs per over" else "Average wickets lost per over"

    if (input$by == "phase") {
      d$label <- paste0(sprintf("%.2f", d$value), "\n", d$matches, " matches")
      ggplot(d, aes(phase, value, fill = batting_team)) +
        geom_col(position = position_dodge(width = 0.8), width = 0.7) +
        geom_text(aes(label = label),
                  position = position_dodge(width = 0.8), vjust = -0.35,
                  lineheight = 0.95, size = 3.9, colour = "#344955") +
        scale_fill_manual(values = team_colours) +
        scale_y_continuous(expand = expansion(mult = c(0, 0.25))) +
        labs(x = NULL, y = ylab) +
        theme_app()
    } else {
      ggplot(d, aes(over, value, colour = batting_team)) +
        geom_line(linewidth = 1.2) +
        scale_colour_manual(values = team_colours) +
        labs(x = "Over", y = ylab,
             caption = paste("Overs bowled in fewer than", min_matches, "matches are hidden.")) +
        theme_app()
    }
  }, alt = "Chart comparing Australia and Pakistan scoring or wickets by phase or over of an ODI innings")

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
  }, striped = TRUE, hover = TRUE, width = "100%")
}

shinyApp(ui, server)
