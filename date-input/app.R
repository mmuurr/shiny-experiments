library(rlang)
library(vctrs)
library(magrittr)
library(tidyverse)
library(shiny)

UI <-
  fluidPage(
    fluidRow(
      dateInput("date_input_a", "initialized with NA", value = as.Date(NA))
    ),
    fluidRow(
      dateInput("date_input_b", "initialized with NULL", value = NULL)
    )
  )

SERVER <- function(input, output, session) {}

APP <- shinyApp(UI, SERVER)

runApp(APP, port = 6969)
