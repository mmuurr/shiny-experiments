## Glossary:
## * f: standard function
## * rv: reactiveVal
## * rvs: reactiveValues
## * rf: reactive (function)
## * rfe: eventReactive
## * ro: observe
## * roe: observeEvent

library(tidyverse)
library(shiny)

print("global start")


global_rv0 <- reactiveVal(NULL)

global_ro_action_button_1 <- observe({
  print("global_ro_action_button_1")
})

global_ro_rv0 <- observe({
  global_rv0()
  print("global_rv0")
})

ui <- fluidPage(
  actionButton("action_button_1", label = "action_button_1"),
  numericInput("numeric_input_2", label = "numeric_input_2", value = 0),
  numericInput("numeric_input_3", label = "numeric_input_3", value = NA_real_),
  numericInput("numeric_input_4", label = "numeric_input_4", value = NULL),
  radioButtons("radio_buttons_5", label = "radio_buttons_5", choices = c("a", "b", "c"), inline = TRUE, selected = NA),
  textInput("text_input_6", label = "text_input_6", value = NULL),
  verbatimTextOutput("debug")
)


server <- function(input, output, session) {

  print("server start")

  observe({
    print("session observe(action_button_1)")
    input[["action_button_1"]]
  })

  observeEvent(input[["action_button_1"]], {
    print("session observeEvent(action_button_1)")
  })

  observe({
    print("session observe(numeric_input_2)")
    input[["numeric_input_2"]]
  })

  observeEvent(input[["numeric_input_2"]], {
    print("session observeEvent(numeric_input_2)")
  })

  observe({
    print("session observe(numeric_input_3)")
    input[["numeric_input_3"]]
  })

  observeEvent(input[["numeric_input_3"]], {
    print("session observeEvent(numeric_input_3)")
  })

  observe({
    print("session observe(numeric_input_4)")
    input[["numeric_input_4"]]
  })
  
  observeEvent(input[["numeric_input_4"]], {
    print("session observeEvent(numeric_input_4)")
  })

  observe({
    print("session observe(radio_buttons_5)")
    input[["radio_buttons_5"]]
  })
  
  observeEvent(input[["radio_buttons_5"]], {
    print("session observeEvent(radio_buttons_5)")
  })

  output[["debug"]] <- renderPrint({
    str(input[["action_button_1"]])
    str(input[["numeric_input_2"]])
    str(input[["numeric_input_3"]])
    str(input[["numeric_input_4"]])
    str(input[["radio_buttons_5"]])
    str(input[["text_input_6"]])
  })


  print("server end")
}


shinyApp(ui, server)


## Findings
## * It appears `numericInput` cannot send a NULL value. Even when initialized with NULL, it sends NA (logical!).
## * 
