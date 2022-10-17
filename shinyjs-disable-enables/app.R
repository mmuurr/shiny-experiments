library(tidyverse)
library(shiny)

ui <- fluidPage(
  shinyjs::useShinyjs(debug = TRUE),
  uiOutput("ui_output")
)

server <- function(input, output, session) {

  output[["ui_output"]] <- renderUI({
    print("rendering ui")
    tags$div(
      actionButton("click_me_button", label = "click me"),
      uiOutput("nested_ui_output")
    )
  })

  output[["nested_ui_output"]] <- renderUI({
    print("rendering nested ui")
    uiOutput("level_3_ui")
  })

  output[["level_3_ui"]] <- renderUI({
    actionButton("observe_me_button", label = "observe me")
  })
  
  observe({
    print(input[["click_me_button"]])
    shinyjs::disable("observe_me_button")
  })
}

shinyApp(ui, server)
