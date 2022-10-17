library(tidyverse)
library(shiny)

LGR <- lgr::lgr
LGR$set_threshold("trace")

UI <- fluidPage(
  textOutput("text_output")
)

SERVER <- function(input, output, session) {

  LGR$trace("starting SERVER function")
  
  o1 <- observe({
    LGR$trace("o1")
  })

  ## no
  o2 <- observeEvent(NULL, {
    LGR$trace("o2")
  }, ignoreNULL = TRUE, ignoreInit = TRUE)

  ## no
  o3 <- observeEvent(NULL, {
    LGR$trace("o3")
  }, ignoreNULL = TRUE, ignoreInit = FALSE)

  ## no
  o4 <- observeEvent(NULL, {
    LGR$trace("o4")
  }, ignoreNULL = FALSE, ignoreInit = TRUE)

  ## yes
  o5 <- observeEvent(NULL, {
    LGR$trace("o5")
  }, ignoreNULL = FALSE, ignoreInit = FALSE)

  ## no
  o6 <- observeEvent(list(NULL), {
    LGR$trace("o6")
  }, ignoreNULL = TRUE, ignoreInit = TRUE)

  ## yes
  o7 <- observeEvent(list(NULL), {
    LGR$trace("o7")
  }, ignoreNULL = TRUE, ignoreInit = FALSE)

  ## no
  o8 <- observeEvent(list(NULL), {
    LGR$trace("o8")
  }, ignoreNULL = FALSE, ignoreInit = TRUE)

  ## yes
  o9 <- observeEvent(list(NULL), {
    LGR$trace("o9")
  }, ignoreNULL = FALSE, ignoreInit = FALSE)

  output[["no_output"]] <- renderText({
    LGR$trace("no_output")
  })

  output[["text_output"]] <- renderText({
    LGR$trace("text_output")
  })

  LGR$trace("ending SERVER function")
}

runApp(shinyApp(UI, SERVER), port = 6969)
