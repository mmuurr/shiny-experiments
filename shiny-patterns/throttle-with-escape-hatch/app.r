library(magrittr)
library(tidyverse)
library(shiny)
source("invalidator.r")

LGR <- lgr::lgr
LGR$set_threshold("trace")

POLL_INTERVAL_SEC <- 1
THROTTLE_DELAY_SEC <- NA

counter <- accumulator(0)

poller <- observe({
  LGR$trace("running poller (i.e. rxval0-updater)")
  counter$add(1)
  invalidateLater(POLL_INTERVAL_SEC * 1000)
})

rxfun1 <- reactive({
  LGR$trace("running rxfun1")
  counter$rxget() * 10
})
rxfun1.throttler <- throttler(rxfun1, THROTTLE_DELAY_SEC * 1000)

rxfun2 <- reactive({
  LGR$trace("running rxfun2")
  rxfun1.throttler$rxget(TRUE) * 10
})

UI <- fluidPage(
  div("rxfun1", textOutput("rxfun1")),
  div("rxfun2", textOutput("rxfun2")),
  div(actionButton("invalidate_button", "invalidate"))
)

SERVER <- function(input, output, session) {
  output[["rxfun1"]] <- renderText(rxfun1())
  output[["rxfun2"]] <- renderText(rxfun2())
  observeEvent(input[["invalidate_button"]], rxfun1.throttler$invalidate())
}


  
runApp(shinyApp(UI, SERVER), port = 6969)
