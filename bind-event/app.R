library(tidyverse)
library(shiny)

ui <- function(...) {
  fluidPage(
    actionButton("touch_a", "Touch A"),
    actionButton("touch_b", "Touch B"),
    tags$table(
      tags$tr(tags$th("key"), tags$th("val")),
      tags$tr(tags$td("AB"), tags$td(textOutput("ab"))),
      tags$tr(tags$td("A"), tags$td(textOutput("a"))),
      tags$tr(tags$td("B"), tags$td(textOutput("b")))
    )
  )
}

server <- function(input, output, session) {

  ab <- reactiveVal(list(a = 0, b = 0))

  observe({
    print("touch_a handler")
    list(a = ab()$a + 1, b = ab()$b) %>% ab()
  }) %>% bindEvent(input$touch_a)

  observe({
    print("touch_b handler")
    list(a = ab()$a, b = ab()$b + 1) %>% ab()
  }) %>% bindEvent(input$touch_b)
  
  output$ab <- renderText({
    print("output$ab")
    ab() %>%
      jsonlite::toJSON(auto_unbox = TRUE) %>%
      jsonlite::minify()
  })

  cached_a <- reactive({
    print("cached_a")
    ab()$a
  }) %>% bindCache(ab()$a)

  output$a <- renderText({
    print("output$a")
    cached_a()
  })
}

shinyApp(ui, server)
