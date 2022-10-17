library(tidyverse)
library(shiny)
library(futile.logger); flog.threshold("TRACE")

UI <- fluidPage(
  actionButton("action-button-input", "press me"),
  verbatimTextOutput("DEBUG")
)

SERVER <- function(input, output, session) {

  foo.reactive <- reactive({
    flog.trace("reactive: foo.reactive")
    flog.debug("action-button-input: %s", input[["action-button-input"]])
    input[["action-button-input"]] * 2
  })

  observe({
    flog.trace("observe: foo.observe")
    flog.debug("action-button-input: %s", input[["action-button-input"]])
    input[["action-button-input"]]
  })
  
  output$DEBUG <- renderPrint({
  })
}

runApp(shinyApp(UI, SERVER))
