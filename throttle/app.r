library(tidyverse)
library(shiny)

LGR <- lgr::lgr
LGR$set_threshold("trace")

ui <-
  fluidPage(
    actionButton("btn", "click me")
  )

server <- function(input, output, session) {

  rxval_1 <- reactiveVal(0)
  
  rxobs_1 <- observe({
    LGR$info("rxobs_1: poller incrementing rxval_1")
    isolate(rxval_1(rxval_1() + 1))
    invalidateLater(1 * 1000)
  })

  rxfun_1 <- reactive({
    val <- rxval_1()
    LGR$info("rxfun_1:", "rxval_1()" = val)
    val
  })

  rxfun_2 <- throttle(rxfun_1, 5 * 1000)

  rxobs_2 <- observeEvent(list(rxfun_2(), input$btn), {
    LGR$info("rxobs_2:", "rxfun_2()" = rxfun_2(), "isolate(rxfun_1())" = isolate(rxfun_1()))
  })
  
}

shinyApp(ui, server)
