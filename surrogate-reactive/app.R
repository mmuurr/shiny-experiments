library(tidyverse)
library(shiny)
library(reactlog)
options(shiny.reactlog = TRUE)

ui <- fluidPage(
  actionButton("action_button", "action button 1"),
  radioButtons("radio_buttons", "on or off", choices = c("on", "off")),
  verbatimTextOutput("time")
)

server <- function(input, output, session) {

  surrogate <- eventReactive({
    print("surrogate event expr")
    if(input$radio_buttons == "off") {  ## take dependency
      NULL
    } else {
      input$action_button  ## take dependency
      TRUE
    }
  }, {
    print("surrogate handler expr")
    lubridate::now()  ## return a new value to break any memoization
  })

  thetime <- eventReactive({
    print("thetime event expr (start)")
    tryCatch({
      print(sprintf("thetime event expr (surrogate() returns %s)", surrogate()))  ## take dependency
    }, error = function(e) {
      print(conditionMessage(e))
    })
    print("thetime event expr (about to return TRUE)")
    TRUE
  }, {
    print("thetime handler expr")
    lubridate::now()
  })

  output$time <- renderText(thetime())
}

shinyApp(ui, server)
