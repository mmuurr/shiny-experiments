 # f, rv, rvs, o, oe, rf, re

library(tidyverse)
library(shiny)

rv <- reactiveVal(lubridate::origin)

f1 <- function() {
  print("in f1")
  print(sprintf("current rv() = %s", isolate(rv())))
  rv(lubridate::now())
  print(sprintf("new rv() = %s", isolate(rv())))
  re1()
  re2()
}

re1 <- eventReactive(rv(), {
  print("in re1")
}, ignoreNULL = TRUE, ignoreInit = TRUE)

re2 <- eventReactive(rv(), {
  print("in re2")
}, ignoreNULL = TRUE, ignoreInit = FALSE)

ui <- fluidPage(actionButton("action_button_1", label = "click me"))

server <- function(input, output, session) {
  observeEvent(input[["action_button_1"]], {
    f1()
  })
}

shinyApp(ui, server, options = list(port = 6969))
