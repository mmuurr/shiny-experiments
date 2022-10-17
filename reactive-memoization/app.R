library(tidyverse)
library(shiny)
library(futile.logger); flog.threshold("TRACE")

UI <- fluidPage(
  textInput("text-input", NULL, NULL),
  actionButton("action-button-input-01", "c(0,1)"),
  actionButton("action-button-input-10", "c(1,0)"),
  verbatimTextOutput("DEBUG")
)

SERVER <- function(input, output, session) {

  upstream <- reactiveVal(NULL)

  observeEvent(input[["action-button-input-01"]], {
    flog.trace("action-button-input handler")
    upstream(c(0,1))
  })

  observeEvent(input[["action-button-input-10"]], {
    flog.trace("action-button-input handler")
    upstream(c(1,0))
  })

  downstream <- eventReactive(upstream(), {
    flog.trace("downstream eventReactive; upstream = %s", paste0(upstream(), collapse = ","))
    upstream()
  })

  rf1 <- reactive({
    input[["action-button-input-01"]]
    input[["action-button-input-10"]]
    flog.trace("rf1")
    return(iris)
  })

  rf2 <- eventReactive(rf1(), {
    flog.trace("rf2")
    rf1()
  })

  output[["DEBUG"]] <- renderPrint({
    downstream()
    str(rf2())
  })
}

runApp(shinyApp(UI, SERVER), port = 6969)

## Conclusions:
## * Shiny uses `base::identical` to determine if a reactive value should _actually_ be updated when being set.
##   If the new value is idenical to the old value, it's a NOP, which includes not invalidating downstream dependants.
