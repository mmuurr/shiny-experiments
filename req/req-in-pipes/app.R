library(tidyverse)
library(shiny)
`%!>%` <- magrittr::`%!>%`

ui <- fluidPage(
  numericInput("row_ix", label = "row ix", value = 1),
  tags$h4("msg 1"), verbatimTextOutput("text_1"),
  tags$h4("msg 2"), verbatimTextOutput("text_2"),
  tags$h4("msg 3"), verbatimTextOutput("text_3")
)

server <- function(input, output, session) {

  output$text_1 <- renderPrint({
    mtcars %>% slice(req(input$row_ix))
  })

  output$text_2 <- renderPrint({
    row_ix <- req(input$row_ix)
    mtcars %>% slice(row_ix)
  })

  output$text_3 <- renderPrint({
    slice(mtcars, req(input$row_ix))
  })

  
}

shinyApp(ui, server)
