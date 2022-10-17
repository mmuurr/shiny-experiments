## rv = reactiveVal
## rvs = reactiveValues (environment)
## rf = reactive (function)
## rfe = eventReactive
## ro = observe
## roe = observeEvent

library(tidyverse)
library(shiny)

library(reactlog)
reactlog_enable()
options(shiny.reactlog = TRUE)

globalRv1 <- reactiveVal(0)

globalRf1 <- reactive({
  print("rf globalRf1")
  globalRv1()  ## rdep
})

globalF <- function() {
  print("f globalF")
  globalRf1()
}

ui <- fluidPage(
  actionButton("button-1", "Button 1"),
  actionButton("button-2", "Increment globalRv1")
)

server <- function(input, output, session) {
  observeEvent(input[["button-2"]], {
    print("roe button-2")
    globalRv1(globalRv1() + 1)
  })
  
  observeEvent(input[["button-1"]], {
    print("roe button-1")
    ## Since this is an observeEvent, everything here in the handling expression is running within an isolate() scope.
    print(globalF())
  })
}

shinyApp(ui, server, options = list(port = 6969))

## > hit button 1
## roe button-1
## f globalF
## rf globalRf1
## 0
## > hit button 1
## roe button-1
## f globalF
## 0
## > hit button 2
## roe button-2
## > hit button 1
## roe button-1
## f globalF
## rf globalRf1
## 1

