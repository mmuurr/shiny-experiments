## Can one modal replace another?

library(tidyverse)
library(shiny)

modal_1 <- modalDialog(
  title = "Modal 1",
  footer = tags$div(
    actionButton("modal_1_dismiss", "Dismiss"),
    actionButton("modal_1_confirm", "Confirm")
  ),
  easyClose = TRUE
)

modal_2 <- modalDialog(
  title = "Modal 2",
  footer = tags$div(
    actionButton("modal_2_dismiss", "Dismiss")
  ),
  easyClose = TRUE
)

ui <- fluidPage(
  actionButton("main", "Click me")
)

server <- function(input, output, session) {

  observeEvent(input[["main"]], {
    showModal(modal_1)
  })

  observeEvent(input[["modal_1_dismiss"]], removeModal())
  observeEvent(input[["modal_2_dismiss"]], removeModal())

  observeEvent(input[["modal_1_confirm"]], {
    showModal(modal_2)
  })
  
}

app <- shinyApp(ui, server)
