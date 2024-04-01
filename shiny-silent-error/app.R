library(tidyverse)
library(shiny)

ui <- fluidPage(
  textInput("data_value", "Data value"),
  textInput("error_class", "Error class"),
  actionButton("btn", "click me"),
  textOutput("raw"),
  textOutput("req"),
  textOutput("try_req"),
  textOutput("counter")
)

f <- function() {
  stop("f's error")
}

server <- function(input, output, session) {

  observe({
    shiny:::reactiveStop("boom", "my_class")
    print("can't get here")
  })

  observe({
    try(req(f()))
    print("got here")
  })

  output[["counter"]] <- renderText(input$btn)

  ## observeEvent(input[["btn"]], {
  ##   print("o1")
  ##   input$data_value
  ## })

  ## observeEvent(input[["btn"]], {
  ##   print("o2")
  ##   req(input$data_value)
  ## })

  ## observeEvent(input[["btn"]], {
  ##   print("o3")
  ##   try({
  ##     req(input$data_value)
  ##   })
  ## })

  ## output[["raw"]] <- renderPrint(input$data_value)
  ## output[["req"]] <- renderPrint(req(input$data_value))
  ## output[["try_req"]] <- renderPrint(try(req(input$data_value)))
}

runApp(shinyApp(ui, server))

