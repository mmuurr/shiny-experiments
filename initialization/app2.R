import::from("rlang", `%||%`, `%|%`)
library(tidyverse)
library(shiny)

print("creating rv1")
global_rv1 <- reactiveVal(0)

print("creating oe1")
global_oe1 <- observeEvent({
  print("in oe1 eventExpr")
  global_rv1()
  TRUE
}, {
  print("in oe1 handlerExpr")
}, ignoreInit = TRUE)

print("creating oe2")
global_oe2 <- observeEvent({
  print("in oe2 eventExpr")
  global_rv1()
  TRUE
}, {
  print("in oe2 handlerExpr")
}, ignoreInit = FALSE)

ui <- fluidPage(
  actionButton("global", "global"),
  actionButton("session", "session")
)

server <- function(input, output, session) {

  print("creating rv2")
  session_rv2 <- reactiveVal(0)

  print("creating oe3")
  session_oe3 <- observeEvent({
    print("in oe3 eventExpr")
    global_rv1()
    TRUE
  }, {
    print("in oe3 handlerExpr")
  }, ignoreInit = TRUE)
  
  print("creating oe4")
  session_oe4 <- observeEvent({
    print("in oe4 eventExpr")
    global_rv1()
    TRUE
  }, {
    print("in oe4 handlerExpr")
  }, ignoreInit = FALSE)

  print("creating oe5")
  session_oe5 <- observeEvent({
    print("in oe5 eventExpr")
    session_rv2()
    TRUE
  }, {
    print("in oe5 handlerExpr")
  }, ignoreInit = TRUE)
  
  print("creating oe6")
  session_oe6 <- observeEvent({
    print("in oe6 eventExpr")
    session_rv2()
    TRUE
  }, {
    print("in oe6 handlerExpr")
  }, ignoreInit = FALSE)

  observeEvent(input$global, {
    global_rv1(input$global)
  })
  observeEvent(input$session, {
    session_rv2(input$session)
  })
}

runApp(shinyApp(ui, server))
