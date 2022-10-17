import::from("rlang", `%||%`, `%|%`)
library(tidyverse)
library(shiny)

global_rv <- reactiveVal(0)

print("creating global_o")
global_o <- observe({
  print("in global_o")
  print(global_rv())
})

print("creating global_oe")
global_oe <- observeEvent({
  print("in global_oe eventExpr")
  global_rv()
  TRUE
}, {
  print("in global_oe handlerExpr")
})

ui <- fluidPage()

server <- function(input, output, session) {

  print("creating session_o")
  session_o <- observe({
    print("in session_o")
    print(global_rv())
  })

  print("creating session_oe")
  session_oe <- observeEvent({
    print("in session_oe eventExpr")
    global_rv()
    TRUE
  }, {
    print("in session_oe handlerExpr")
  })
}

runApp(shinyApp(ui, server))
