library(tidyverse)
library(shiny)

ui <- fluidPage(
  actionButton("increment-button", "increment"),
  verbatimTextOutput("DEBUG")
)

rv1 <- reactiveVal(0)
set_rv <- function(rv, x) {
  rv(x)
}

rvs2 <- reactiveValues(
  x = 0,
  y = 1
)
set_rvs <- function(rv, val) {
  assign(deparse(substitute(rv)), val)
}
set_rvs2 <- function(rvs, var, val) {
  rvs[[var]] <- val
}

server <- function(input, output, session) {

  observe({
    set_rv(rv1, input[["increment-button"]])
    set_rvs(rvs2$x, input[["increment-button"]] + 10)
    set_rvs2(rvs2, "y", input[["increment-button"]] + 10)
  })

  output[["DEBUG"]] <- renderPrint({
    cat(sprintf("rv1() = %s\n", rv1()))
    cat(sprintf("rvs2$x = %s\n", rvs2$x))
    cat(sprintf("rvs2$y = %s\n", rvs2$y))
  })
}

shinyApp(ui, server)
