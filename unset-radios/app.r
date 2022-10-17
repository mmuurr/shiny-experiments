library(tidyverse)
library(shiny)

LGR <- lgr::lgr
LGR$set_threshold("trace")

ui <- fluidPage(
  #uiOutput("outer_ui"),
  radioButtons("radios_1", label = "radios_1", choices = c("foo","bar","baz"), selected = "foo", inline = TRUE)

)

rxval <- function(init, label = NULL) {
  rv <- reactiveVal(init, label)
  rxget <- function() rv()
  rxset <- function(x) rv(x)
  isoget <- function() isolate(rxget())
  list(rxget = rxget, rxset = rxset, isoget = isoget)
}

rv1 <- rxval("bar")
LGR$info("verify rv1", "rv1$isoget()" = rv1$isoget())

LGR$info("before server function")
server <- function(input, output, session) {
  LGR$info("start of server function")
  
  output[["outer_ui"]] <- renderUI({
    LGR$info("renderUI outer_ui")
    #radioButtons("radios_1", label = "radios_1", choices = c("foo","bar","baz"), selected = character(0), inline = TRUE)
    #uiOutput("inner_ui")
  })

  output[["inner_ui"]] <- renderUI({
    LGR$info("renderUI inner_ui")
    radioButtons("radios_1", label = "radios_1", choices = c("foo","bar","baz"), selected = character(0), inline = TRUE)
  })

  o1 <- observeEvent({
    LGR$info("o1(event)", "input[[\"radios_1\"]]" = input[["radios_1"]])
    input[["radios_1"]]
  }, {
    LGR$info("o1(handler) setting rv1")
    rv1$rxset(input[["radios_1"]])  ## set reactiveVal
  }, priority = 200, ignoreInit = TRUE)

  o2 <- observe({
    LGR$info("o2 updating radios_1", "rv1$rxget()" = rv1$rxget())
    updateRadioButtons(session, "radios_1", selected = rv1$rxget())
  }, priority = 100)

  LGR$info("end of server function")
}

shinyApp(ui, server)
