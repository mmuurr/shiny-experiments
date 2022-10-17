library(tidyverse)
library(shiny)

throttle_safely <- function(r, millis, priority = 100, domain = shiny::getDefaultReactiveDomain()) {
  throttled_r <- shiny::throttle(purrr::safely(r), millis, priority, domain)
  function() {
    res <- throttled_r()
    if (is.null(res$error)) res$result else stop(res$error)
  }
}

proxyval1 <- function(rxfun, ...) {  
  stopifnot(isTRUE(shiny::is.reactive(rxfun)))
  rv <- reactiveVal(NULL)
  shiny::observe(rv(rxfun()))
  rv
}

proxyval2 <- function(rxfun, ...) {  
  stopifnot(isTRUE(shiny::is.reactive(rxfun)))
  safe_rxfun <- purrr::safely(rxfun)
  safe_res <- shiny::reactiveVal(NULL)
  shiny::observe({
    safe_res(safe_rxfun())
  }, ...)
  function() {
    res <- safe_res()
    if (is.null(res$error)) res$result else stop(res$error)
  }
}

ui <- fluidPage(
  textOutput("txt"),
  actionButton("btn", "click me")
)

server <- function(input, output, session) {

  btn_x_10 <- reactive({
    val <- input$btn * 10
    if (runif(1) < 0.1) stop("boom")
    val
  }) %>% throttle(2000)

  #proxy_btn_x_10 <- proxyval2(btn_x_10)
  
  output$txt <- renderText({
    sprintf("%s %s", Sys.time(), btn_x_10())
  })
}

runApp(shinyApp(ui, server), port = 6969)



