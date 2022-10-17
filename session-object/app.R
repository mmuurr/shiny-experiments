library(tidyverse)
library(shiny)

ui <- fluidPage(
  verbatimTextOutput("session-output")
)

server <- function(input, output, session) {
  output[["session-output"]] <- renderPrint({
    str(session)
    reactiveValuesToList(session$clientData)
  })
}

shinyApp(ui, server)

## session$.now() : current time in milliseconds (from epoch)
## session$
