library(tidyverse)
library(shiny)

ui <- fluidPage(
  actionButton("click_me_button", "click me"),
  textOutput("button_count_text_output")
)

rv1 <- reactiveVal(NULL)
req_rv1 <- function() req(rv1())

server <- function(input, output, session) {
  output[["button_count_text_output"]] <- renderText(input[["click_me_button"]])

  oe1 <- observeEvent({
    print("oe1 eventExpr part 1")
    rv1()
  }, {
    print("oe1 handlerExpr part 1")
  })

  oe2 <- observeEvent(TRUE, {
    print("oe2 handlerExpr part 1")
    req(TRUE)
    print("oe2 handlerExpr part 2")
    stop("oe2 non-shiny stop()")
    print("oe2 handlerExpr part 3")
  })
}

shinyApp(ui, server)
