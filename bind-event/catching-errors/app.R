library(rlang)
library(vctrs)
library(magrittr)
library(tidyverse)
library(shiny)

TRYLOG <- function(expr, error_val = NULL, finally = NULL) {
  tryCatch(
    expr,
    error = function(e) {
      print(sprintf("error: %s", conditionMessage(e)))
      error_val
    },
    finally = finally
  )
}



UI <-
  fluidPage(
    actionButton("btn_1", "Button 1")
  )

SERVER <- function(input, output, session) {

  observe({
    TRYLOG(stop("handler"))
  }) %>%
    bindEvent(TRYLOG({
      input$btn_1
      stop("event")
    }), ignoreNULL = FALSE, ignoreInit = TRUE)
  
}

shinyApp(UI, SERVER)


