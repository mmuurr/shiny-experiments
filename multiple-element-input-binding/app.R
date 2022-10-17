library(tidyverse)
library(shiny)

tempf <- function(question_ix) {
  tags$div(class = "input-group risio-test-input", `data-risio-question-ix` = question_ix, `data-input-id` = "test-input",
    tags$input(type = "text", class = "form-control"),
    tags$div(class = "input-group-btn",
      tags$button(type = "button", class = "btn btn-default dropdown-toggle", `data-toggle` = "dropdown",
        tags$span("Val 1"),
        tags$span(class = "caret")
      ),
      tags$ul(class = "dropdown-menu dropdown-menu-right",
        tags$li("Val 1"),
        tags$li("Val 2"),
        tags$li("Val 3")
      )
    )
  )
}

myInput <- function() {
  tagList(
    singleton(tags$head(
      tags$script(src = "element.js")
    )),
    tempf(6),
    tempf(9)
  )
}

ui <- fluidPage(
  myInput(),
  verbatimTextOutput("DEBUG")
)

server <- function(input, output, session) {
  output[["DEBUG"]] <- renderPrint({
    str(input[["test-input"]])
  })
}

shinyApp(ui, server, options = list(port = 6969))
