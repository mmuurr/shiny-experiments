library(magrittr)
library(tidyverse)
library(shiny)

ui <- fluidPage(
  div("rxval", textOutput("rxval")),
  actionButton("reset_button", "reset")
)
server <- function(input, output, session) {
  rxval <- reactiveVal(0)
  rxval.throttled <- throttle(rxval, 5000)

  observe({
    rxval(isolate(rxval()) + 1)  ## increment
    invalidateLater(1000)
  })

  observeEvent(input[["reset_button"]], rxval.throttled(0))

  output[["rxval"]] <- renderText(rxval())
}

runApp(shinyApp(ui, server), port = 6969)
