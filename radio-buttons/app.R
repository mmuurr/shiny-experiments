import::from(magrittr, `%T>%`)
library(tidyverse)
library(shiny)

source("multichoice-input.R")

ui <- fluidPage(
  tags$head(
    tags$script(type = "text/javascript", src = "multichoice-input.js"),
    tags$link(rel = "stylesheet", type = "text/css", href="multichoice-input.css")
  ),
  icon("hand-point-right"), tags$br(),
  radioButtons("standard-radio-buttons", label = "Standard", choices = c("\u03b1", "\u03b2", "\u03b3", "\u03b4", "\u03b5"), selected = character(0)),
  netrivia_multichoice_input("alternative-radio-buttons", label = NA, choices = c("\u03b1", "\u03b2", "\u03b3", "\u03b4", "\u03b5"), selected = character(0)),
  verbatimTextOutput("DEBUG")
)

server <- function(input, output, session) {

  ## session$sendInputMessage(
  ##   "alternative-radio-buttons",
  ##   list(
  ##     set_icon = list(
  ##       html = HTML(as.character(icon("hand-point-right"))),
  ##       ix1 = 4
  ##     ),
  ##     set_pct = c(0, 10, 20, 30, 40),
  ##     set_answer = c("incorrect", "correct", "incorrect", "incorrect", "skip")
  ##   )
  ## )

  session$sendInputMessage(
    "alternative-radio-buttons",
    list(
      set_icon = list(
        html = icon("times") %>%
          htmltools::tagAppendAttributes(style = sprintf("color:%s;", "#FF0008")) %>%
          as.character() %>%
          HTML(),
        ix1 = 4
      )
    )
  )
  
  output[["DEBUG"]] <- renderPrint({
    print(input[["standard-radio-buttons"]])
    print(input[["alternative-radio-buttons"]])
  })
}

shinyApp(ui, server)


