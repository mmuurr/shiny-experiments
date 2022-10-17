library(tidyverse)
library(shiny)
library(reactlog)

ui <- fluidPage(
  actionButton("action_button", "action button 1"),
  radioButtons("radio_buttons", "on or off", choices = c("on", "off")),
  verbatimTextOutput("time")
)

server <- function(input, output, session) {

  surrogate <- eventReactive({
    input$action_button
    NULL
  }, {
    lubridate::now()
  })
  
  output$time <- eventReactive({
    input$action_button
    NULL
    TRUE
  }, {
    print("foo")
    lubridate::now()
  })
}

runApp(shinyApp(ui, server), port = 6969)
