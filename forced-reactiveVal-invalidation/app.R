library(tidyverse)
library(shiny)

CONSTANT_VAL <- 1

forcedReactiveVal <- function(value) {
  val <- reactiveVal(value)
  invalidate_count <- reactiveVal(0)

  ## .force is ignored when value is missing (i.e. a 'get()')
  function(value, .force_invalidate = FALSE) {
    if (missing(value)) {
      invalidate_count()
      val()
    } else {
      did_update_val <- val(value)
      if (did_update_val || isTRUE(.force_invalidate)) invalidate_count(isolate(invalidate_count()) + 1)
      did_update_val
    }
  }
}

anotherForcedReactiveVal <- function(value, label = NULL) {
  this <- list(
    value = force(value),
    label = force(label),
    invalidate_count = reactiveVal(0)
  )

  f <- function(value, .force_invalidate = FALSE) {
    if (missing(value)) {
      this$invalidate_count()
      this$value
    } else {
      do_invalidate <- identical(this$value, value) || isTRUE(.force_invalidate)
      this$value <<- value
      if (do_invalidate) invalidate_count(isolate(invalidate_count() + 1))
      do_invalidate
    }
  }

  structure(
    f,
    class = append("forceReactiveVal", class(this$invalidate_count)),
    label = this$label,
    .impl = attr(this$invalidate_count, ".impl")
  )
}

frv1 <- forcedReactiveVal(CONSTANT_VAL)

ui <- fluidPage(
  actionButton("noforce_action_button", "set frv1; no force"),
  actionButton("force_action_button", "set frv1; force"),
  verbatimTextOutput("frv1_dependency")
)

server <- function(input, output, session) {

  observeEvent(input[["noforce_action_button"]], {
    frv1(CONSTANT_VAL)
  })
  
  observeEvent(input[["force_action_button"]], {
    frv1(CONSTANT_VAL, .force_invalidate = TRUE)
  })

  output[["frv1_dependency"]] <- renderPrint({
    print(frv1())  ## take dependency on frv1, should always return CONSTANT_VAL
    print(lubridate::now())  ## but also print the time, so we can see this changing for the "force" scenario
  })

}

runApp(shinyApp(ui, server), port = 6969)





