library(tidyverse)
library(shiny)

ui <- fluidPage({
  uiOutput("outer_ui")
})

server <- function(input, output, session) {

  output[["outer_ui"]] <- renderUI({
    print("rendering outer_ui")
    uiOutput("inner_ui")
  })

  output[["inner_ui"]] <- renderUI({
    print("rendering inner_ui")
    numericInput("numeric_input", label = NULL, value = 1)
  })
  
  observe({
    print("updating numeric input")
    updateNumericInput(session, "numeric_input", value = 2)
  }, priority = 999)
}

shinyApp(ui, server)
