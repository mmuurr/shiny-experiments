library(tidyverse)
library(shiny)

flush <- shiny:::flushReact
rxval <- reactiveVal(0)

rxexp_1 <- reactive({
  print("rxexp_1")
  rxval()  ## rxdep
  TRUE
})

rxexp_2 <- reactive({
  print("rxexp_2")
  rxexp_1()
})

observe({
  print("observer")
  print(rxexp_2())
})

flush()


