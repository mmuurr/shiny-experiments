library(tidyverse)
library(shiny)
library(futile.logger); flog.threshold("TRACE")

UI <- fluidPage(
  actionButton("action-button-input", "press me"),
  verbatimTextOutput("DEBUG")
)

SERVER <- function(input, output, session) {

  rv1 <- reactiveVal(-100)
  rv2 <- reactiveVal(0)

  set_rv1 <- function(x) rv1(x)
  increment_rv2 <- function() rv2(isolate(rv2() + 1))

  ## get <- reactive({
  ##   increment_rv2()
  ##   input_val <- input[["action-button-input"]]  ## rdep
  ##   set_rv1(input_val)  ## sets rv1
  ##   rv1()  ## rdep
  ## })

  get <- eventReactive(list(
    input[["action-button-input"]],
    NULL #rv1()
  ), {
    increment_rv2()
    input_val <- input[["action-button-input"]]
    set_rv1(input_val)
    rv1()
  })

  output$DEBUG <- renderPrint({
    print(sprintf("action button = %s", input[["action-button-input"]]))
    print(sprintf("get = %s", isolate(get())))
    print(sprintf("rv2 = %s", rv2()))
  })
}

runApp(shinyApp(UI, SERVER))


## conclusion: you actually need to 'call' the reactive function or reactive val.
