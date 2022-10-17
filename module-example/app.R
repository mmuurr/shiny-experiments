library(rlang)
library(vctrs)
library(magrittr)
library(tidyverse)
library(shiny)


counter_button_ui <- function(id, label) {
  ns <- NS(id)
  tagList(
    tags$div(
      actionButton(ns("button"), label = label),
      textOutput(ns("thecount")),
      textOutput(ns("themsg"))
    )
  )
}

counter_button_server <- function(id, app_reactives) {
  force(app_reactives)  ## TODO: test this
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    count <- reactiveVal(0)
    observeEvent(input[["button"]], {
      count(count() + 1)
    })
    output[["thecount"]] <- renderText(count())
    output[["themsg"]] <- renderText(app_reactives$msg())
    list(count = count)
  })
}

app_ui <- fluidPage(
  textInput("msg", "what's the message", "initial msg"),
  wellPanel(counter_button_ui("1", "button 1")),
  "Module 1 count:", textOutput("mod_1_count"),
  wellPanel(counter_button_ui("2", "button 2")),
  "Module 2 count:", textOutput("mod_2_count")
)

app_server <- function(input, output, session) {

  ## msg <- reactiveVal(NULL)
  ## observe({
  ##   print("running")
  ##   msg(as.character(lubridate::now()))
  ##   invalidateLater(5 * 1000)
  ## })

  msg <- reactive(input[["msg"]])
  
  mod_1 <- counter_button_server("1", list(msg = msg))
  mod_2 <- counter_button_server("2", list(msg = msg))

  output[["mod_1_count"]] <- renderText(mod_1$count())
  output[["mod_2_count"]] <- renderText(mod_2$count())
  
}

runApp(shinyApp(app_ui, app_server))

