library(tidyverse)
library(shiny)

ui <- fluidPage({
  uiOutput("ui_output")
})

server <- function(input, output, session) {

  output[["ui_output"]] <- renderUI({
    print("rendering ui")
    numericInput("numeric_input", label = NULL, value = 1)
  })
  
  observe({
    print("updating numeric input")
    updateNumericInput(session, "numeric_input", value = 2)
  }, priority = 999)
}


