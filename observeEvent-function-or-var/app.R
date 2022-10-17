library(tidyverse)
library(shiny)
library(futile.logger); flog.threshold("TRACE")

UI <- fluidPage(
  actionButton("action-button-input", "press me"),
  verbatimTextOutput("DEBUG")
)

SERVER <- function(input, output, session) {

  rv <- reactiveVal(0)

  ## this does _not_ work:
  observeEvent(rv, {
    flog.info("oe1: %s", rv())
  })

  ## this works:
  observeEvent(rv(), {
    flog.info("oe2: %s", rv())
  })

  observeEvent(input[["action-button-input"]], {
    rv(rv() + 1)
  })
  
  output$DEBUG <- renderPrint({
  })
}

runApp(shinyApp(UI, SERVER)
)

## conclusion: you actually need to 'call' the reactive function or reactive val.
