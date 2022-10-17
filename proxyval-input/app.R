library(shiny)


proxyval1 <- function(rxfun, ...) {
  safe_rxfun <- purrr::safely(rxfun)
  safe_rxval <- shiny::reactiveVal(NULL)
  obs <- shiny::observe({
    safe_rxval(safe_rxfun())
  }, ...)
  function() {
    val <- safe_rxval()
    if (is.null(val$error)) val$result else stop(val$error)
  }
}
proxyval1_destroy <- function(pv) {
  try(environment(pv)$obs$destroy())
}


ui <- fluidPage(
  actionButton("btn")
)

server <- function(input, output, session) {
  proxyval(function() input$btn)
}
