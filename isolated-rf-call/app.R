#rxval: reactive source
#rxfun: reactive conductor
#rxobs: reactive endpoint

library(tidyverse)
library(shiny)

ui <- fluidPage(
  actionButton("action_button_1", "action_button_1"),
  actionButton("action_button_2", "action_button_2"),
  actionButton("action_button_3", "action_button_3"),
)

server <- function(input, output, session) {

  observeEvent(input[["action_button_1"]], {
    print("action_button_1 clicked; invalidating rxfun_1")
  })
  
  rxfun_1 <- reactive({
    input[["action_button_1"]]
    print("running rxfun_1")
  })

  observeEvent(input[["action_button_2"]], {
    print("action_button_2 clicked; running handler which calls rxfun_1")
    rxfun_1()
    print("ending action_button_2 handler")
  })

  observeEvent(input[["action_button_3"]], {
    print("action_button_3 clicked; running handler which calls isolate(rxfun_1)")
    rxfun_1()
    print("ending action_button_3 handler")
  })

}

runApp(shinyApp(ui, server), port = 6969)
