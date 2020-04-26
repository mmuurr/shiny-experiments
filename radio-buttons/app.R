import::from(magrittr, `%T>%`)
library(tidyverse)
library(shiny)

source("multichoice-input.R")

ui <- fluidPage(
  tags$head(
    tags$script(type = "text/javascript", src = "multichoice-input.js"),
    tags$link(rel = "stylesheet", type = "text/css", href="multichoice-input.css")
  ),
  radioButtons("standard-radio-buttons", label = "Standard", choices = c("\u03b1", "\u03b2", "\u03b3", "\u03b4", "\u03b5"), selected = character(0)),
  netrivia_multichoice_input("alternative-radio-buttons", label = NA, choices = c("\u03b1", "\u03b2", "\u03b3", "\u03b4", "\u03b5"), selected = character(0)),
  verbatimTextOutput("DEBUG")
)

server <- function(input, output, session) {
  output[["DEBUG"]] <- renderPrint({
    print(input[["standard-radio-buttons"]])
    print(input[["alternative-radio-buttons"]])
  })
}

shinyApp(ui, server)


