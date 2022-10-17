library(tidyverse)
library(shiny)

f <- function(x) {
  print(x)
}

ui <- fluidPage(
  actionButton("btn", "click me to raise a (shiny.silent.error,validation,error,condition)"),
  textOutput("btn_counter")
)

server <- function(input, output, session) {
  rv <- reactiveVal(NULL)
  output$btn_counter <- renderText(input$btn)
  observeEvent(input$btn, req(rv()))
}

runApp(shinyApp(ui, server))

