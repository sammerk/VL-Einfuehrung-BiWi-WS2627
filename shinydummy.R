library(shiny)
library(bslib)
library(ggplot2)

n_trials <- 30
n_obs <- 28
seed <- 7319

ut_colors <- c(
  karminrot = "#A51E37", mattgold = "#B4A069", anthrazit = "#32414B",
  blau = "#0069AA"
)

ut_theme <- bs_theme(
  version = 5,
  bg = "#FFFFFF",
  fg = ut_colors[["anthrazit"]],
  primary = ut_colors[["karminrot"]],
  secondary = ut_colors[["mattgold"]],
  info = ut_colors[["mattgold"]],
  base_font = "Arial",
  heading_font = font_google("Cinzel", local = FALSE),
  `enable-rounded` = FALSE
)

simulate_betabinom <- function(mu, rho, seed) {
  p <- pmin(pmax(mu / n_trials, 1e-6), 1 - 1e-6)
  # Beta-Parametrisierung mit Mittelwert p und Intraklassen-Korrelation rho
  alpha <- p * (1 - rho) / rho
  beta <- (1 - p) * (1 - rho) / rho
  set.seed(seed)
  prob <- bayestestR::distribution_beta(n_obs, shape1 = alpha, shape2 = beta, random = F)
  y <- bayestestR::distribution_binom(n_obs, size = n_trials, prob = prob, random = F)
  data.frame(id = seq_len(n_obs), y = y)
}

dotplot_group <- function(df, colour) {
  ggplot(df, aes(x = 1, y = y)) +
    geom_dotplot(
      binaxis = "y", stackdir = "center", binwidth = 1,
      dotsize = 0.8, fill = colour, color = colour
    ) +
    scale_y_continuous(limits = c(0, n_trials), breaks = seq(0, n_trials, 5)) +
    labs(x = NULL, y = "Anzahl Erfolge") +
    theme_minimal(base_family = "Arial", base_size = 14) +
    theme(
      axis.text.x = element_blank(),
      axis.ticks.x = element_blank(),
      panel.grid.major.x = element_blank(),
      panel.grid.minor = element_blank(),
      text = element_text(colour = ut_colors[["anthrazit"]])
    )
}

group_css <- function(cls, colour) {
  sprintf(
    ".%1$s .irs--shiny .irs-handle, .%1$s .irs--shiny .irs-handle:hover, .%1$s .irs--shiny .irs-handle:focus, .%1$s .irs--shiny .irs-handle.state_hover, .%1$s .irs--shiny .irs-handle.state_focus, .%1$s .irs--shiny .irs-handle.type_last.state_hover { background: %2$s !important; background-image: none !important; border-color: %2$s !important; box-shadow: none !important; }
     .%1$s .irs--shiny .irs-bar, .%1$s .irs--shiny .irs-bar-edge, .%1$s .irs--shiny .irs-line { background: %2$s !important; border-color: %2$s !important; }",
    cls, colour
  )
}

ui <- page_fillable(
  tags$head(tags$style(HTML(paste(
    group_css("grp-a", ut_colors[["karminrot"]]),
    group_css("grp-b", ut_colors[["mattgold"]]),
    ".irs-min, .irs-max, .irs-single, .irs-from, .irs-to { display: none !important; }
     .shiny-input-container { margin-bottom: 0.25rem; }
     .irs--shiny { height: 24px !important; margin-top: -4px; }
     .irs--shiny .irs-line, .irs--shiny .irs-bar, .irs--shiny .irs-bar-edge { top: 8px !important; }
     .irs--shiny .irs-handle { top: 1px !important; }
     .app-grid { flex: 1 1 auto; min-height: 0; display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); grid-template-rows: auto auto minmax(0, 1fr); gap: var(--bs-gutter-x, 1.5rem); padding: 0 var(--bs-gutter-x, 1.5rem) var(--bs-gutter-x, 1.5rem); }
     .app-grid > .card { margin-bottom: 0; min-height: 0; }
     .app-grid .card-body { min-height: 0; }
     .app-grid .shiny-plot-output, .app-grid .html-fill-item { height: 100% !important; min-height: 0; }
     .c-sl-a   { grid-column: 1;          grid-row: 1; }
     .c-sl-b   { grid-column: 2;          grid-row: 1; }
     .c-btn    { grid-column: 1 / span 2; grid-row: 2; }
     .c-plot-a { grid-column: 3;          grid-row: 1 / span 3; }
     .c-plot-b { grid-column: 4;          grid-row: 1 / span 3; }
     @media (max-width: 800px) {
       body.bslib-page-fill { height: auto !important; min-height: 100dvh; overflow-y: auto !important; }
       .app-grid { flex: none; grid-template-columns: repeat(2, minmax(0, 1fr)); grid-template-rows: none; grid-auto-rows: auto; }
       .c-sl-a   { grid-column: 1 / span 2; grid-row: 1; }
       .c-sl-b   { grid-column: 1 / span 2; grid-row: 2; }
       .c-plot-a { grid-column: 1;          grid-row: 3; height: 340px; }
       .c-plot-b { grid-column: 2;          grid-row: 3; height: 340px; }
       .c-btn    { grid-column: 1 / span 2; grid-row: 4; }
       #send { width: 100%; }
     }"
  )))),
  tags$h2(
    "Schätzung: Leistungsunterschiede durch Lehrkraftqualität",
    class = "mt-3",
    style = sprintf(
      "font-family: 'Cinzel', serif; font-weight: 600; font-variant-caps: small-caps; color: %s;",
      ut_colors[["karminrot"]]
    )
  ),
  tags$p(
    "Stellen Sie sich vor, zwei gleich starke Klassen werden 6 Wochen lang zum selben Thema von zwei sehr unterschiedlich starken Lehrkräften unterrichtet. ",
    tags$span(
      "Die Lehrkraft in Klasse A",
      style = sprintf("color: %s; font-weight: bold;", ut_colors[["karminrot"]])
    ),
    " ist sehr beliebt, erfahren, und fachlich wie didaktisch sehr kompetent. ",
    tags$span(
      "Die Lehrkraft in Klasse B",
      style = sprintf("color: %s; font-weight: bold;", ut_colors[["mattgold"]])
    ),
    " ist eher unbeliebt, hat wenig Erfahrung und ist fachlich wie didaktisch wenig kompetent. Nach 6 Wochen schreiben die Schüler:innen beider Klassen dieselbe Klassenarbeit, in der es maximal 30 Punkte zu erzielen gibt. Stellen Sie mit den Slidern ein, welche Ergebnisse Sie erwarten und senden Sie Ihre Einschätzung ab."
  ),

  tags$div(
    class = "app-grid",
    card(
      class = "grp-a c-sl-a",
      card_header(
        tags$span("Klasse A", style = sprintf("color: %s;", ut_colors[["karminrot"]]))
      ),
      sliderInput(
        "mu1", "Durchschnitt",
        min = 0, max = n_trials, value = n_trials / 2, step = 0.5, ticks = FALSE
      ),
      sliderInput(
        "rho1", "Heterogenität",
        min = 0.000001, max = 0.1, value = (0.000001 + 0.1) / 2, step = 0.0001, ticks = FALSE
      )
    ),
    card(
      class = "grp-b c-sl-b",
      card_header(
        tags$span("Klasse B", style = sprintf("color: %s;", ut_colors[["mattgold"]]))
      ),
      sliderInput(
        "mu2", "Durchschnitt",
        min = 0, max = n_trials, value = n_trials / 2, step = 0.5, ticks = FALSE
      ),
      sliderInput(
        "rho2", "Heterogenität",
        min = 0.000001, max = 0.1, value = (0.000001 + 0.1) / 2, step = 0.0001, ticks = FALSE
      )
    ),
    card(
      class = "c-btn",
      card_body(
        actionButton(
          "send", "Einschätzung abschicken",
          icon = icon("paper-plane"),
          class = "btn-primary",
          style = sprintf("background-color: %1$s; border-color: %1$s;", ut_colors[["karminrot"]])
        )
      )
    ),
    card(
      class = "c-plot-a",
      card_header(tags$span("Klasse A", style = sprintf("color: %s;", ut_colors[["karminrot"]]))),
      plotOutput("dot1", height = "100%")
    ),
    card(
      class = "c-plot-b",
      card_header(tags$span("Klasse B", style = sprintf("color: %s;", ut_colors[["mattgold"]]))),
      plotOutput("dot2", height = "100%")
    )
  )
)

server <- function(input, output, session) {
  current_seed <- reactiveVal(seed)
  observeEvent(input$resim, current_seed(sample.int(10000, 1)))

  started <- reactiveVal(FALSE)
  observeEvent(
    list(input$mu1, input$rho1, input$mu2, input$rho2),
    started(TRUE),
    ignoreInit = TRUE
  )

  sim1 <- reactive(simulate_betabinom(input$mu1, input$rho1, current_seed()))
  sim2 <- reactive(simulate_betabinom(input$mu2, input$rho2, current_seed()))

  output$dot1 <- renderPlot({
    if (!started()) return(ggplot() + theme_void())
    dotplot_group(sim1(), ut_colors[["karminrot"]])
  })
  output$dot2 <- renderPlot({
    if (!started()) return(ggplot() + theme_void())
    dotplot_group(sim2(), ut_colors[["mattgold"]])
  })
}


shinyApp(ui, server)
