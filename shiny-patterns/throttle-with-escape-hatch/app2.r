library(magrittr)
library(tidyverse)
library(shiny)
source("invalidator.r")

LGR <- lgr::lgr
LGR$set_threshold("trace")

POLL_INTERVAL_SEC <- 1
THROTTLE_DELAY_SEC <- 10

rxval <- reactiveVal(NULL)

poller <- observe({
  rxval(Sys.time())
  invalidateLater(POLL_INTERVAL_SEC * 1000 * 2)
})

rxval.throttled <- throttle(rxval, THROTTLE_DELAY_SEC * 1000)

rxfun <- reactive(rxval())

UI <- fluidPage(
  div("rxval", textOutput("rxval")),
  div("rxval.throttled", textOutput("rxval.throttled")),
  div(actionButton("btn", "click me"))
)

SERVER <- function(input, output, session) {
  output[["rxval"]] <- renderText(rxval())
  output[["rxval.throttled"]] <- renderText(rxval.throttled())
  observeEvent(input[["btn"]], rxval.throttled("foo"))
}

runApp(shinyApp(UI, SERVER), port = 6969)
