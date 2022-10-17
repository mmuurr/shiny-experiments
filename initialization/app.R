import::from("rlang", `%||%`, `%|%`)
library(tidyverse)
library(shiny)

rv1 <- reactiveVal(1)

print("creating global observe o1")
o1 <- observe({
  print(sprintf("in global observe o1, rv1() = %s", rv1()))
})
print("done creating global observe o1")


ui <- fluidPage(
  actionButton("the_action_button", "click me")
)

server <- function(input, output, session) {

  print("creating session reactiveVal rv2")
  rv2 <- reactiveVal(2)
  print("done creating session reactiveVal rv2")
  
  print("creating session observe o2")
  o2 <- observe({
    print(sprintf("in session observe o2, input$the_action_button = %s", input$the_action_button %||% "NULL"))
    rv1(input$the_action_button)
  })
  print("done creating session observe o2")

  print("creating session observeEvent o3 (ignoreInit = FALSE)")
  o3 <- observeEvent(rv2(), {
    print("in session observeEvent o3, rv2() = %s", rv2())
  }, ignoreInit = FALSE)
  print("done creating session observeEvent o3 (ignoreInit = FALSE)")

  print("creating session observeEvent o4 (ignoreInit = TRUE)")
  o4 <- observeEvent(rv1(), {
    print("in session observeEvent o4, rv1() = %s", rv1())
  }, ignoreInit = TRUE)
  print("done creating session observeEvent o4 (ignoreInit = TRUE)")
  
}

runApp(shinyApp(ui, server))
