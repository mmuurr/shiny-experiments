library(shiny)

ui <-
  fluidPage(
    actionButton("btn", "click me")
  )

server <-
  function(input, output, session) {

    ## expected: TRUE
    ## observed: TRUE
    observeEvent({
      input[["btn"]]
    }, {
      print("button")
    }, ignoreNULL = TRUE)

    ## expected: FALSE
    ## observed: FALSE
    observeEvent({
      input[["btn"]]
      NULL
    }, {
      print("button; NULL")
    }, ignoreNULL = TRUE)

    ## expected: TRUE
    ## observed: TRUE
    observeEvent({
      list(input[["btn"]])
    }, {
      print("list(button)")
    }, ignoreNULL = TRUE)
    
    ## expected: TRUE
    ## observed: TRUE
    observeEvent({
      list(input[["btn"]], NULL)
    }, {
      print("list(button, NULL)")
    }, ignoreNULL = TRUE)

    ## expected: TRUE
    ## observed: TRUE
    observeEvent({
      list(NULL, input[["btn"]])
    }, {
      print("list(NULL, button)")
    }, ignoreNULL = TRUE)
    
  }

runApp(shinyApp(ui, server), port = 6969)
