library(tidyverse)
library(shiny)

ui <- fluidPage(
  selectInput("select_input", label = "select_input", choices = letters[1:3], selected = character(0)),
  radioButtons("radio_buttons", label = "radio_buttons", choices = letters[1:3], selected = character(0), inline = TRUE),
  verbatimTextOutput("debug")
)

server <- function(input, output, session) {
  output$debug <- renderPrint({
    str(input$select_input)
    str(input$radio_buttons)
  })
}

runApp(shinyApp(ui, server))
