library(rlang)
library(vctrs)
library(magrittr)
library(tidyverse)
library(shiny)

UI <-
  fluidPage(
    selectInput("outer_select_input", label = "outer_select_input", choices = c("foo","bar","baz"), selectize = FALSE),
    selectizeInput("outer_selectize_input", label = "outer_selectize_input", choices = c("foo","bar","baz"), options = list(create = TRUE)),
    DT::dataTableOutput("the_datatable"),
    verbatimTextOutput("DEBUG")
  )

SERVER <-
  function(input, output, session) {

    output[["the_datatable"]] <- DT::renderDataTable({
      tbl <- tibble::tibble(
        row_name = "row 1",
        input_element = as.character(selectizeInput("inner_selectize_input", label = "inner_selectize_input", choices = c("foo","bar","baz"), options = list(create = TRUE)))
      )
      DT::datatable(
        tbl,
        escape = 0,
        selection = "none",
        options = list(
          preDrawCallback = DT::JS("function(settings) {
            Shiny.unbindAll(this.api().table().node());
          }"),
          drawCallback = DT::JS("function(settings) {
            Shiny.initializeInputs(this.api().table().node());
            Shiny.bindAll(this.api().table().node());
          }")
        )
      )
    })

    output[["DEBUG"]] <- renderPrint({
      cat("outer_select_input\n")
      str(input[["outer_select_input"]])
      cat("outer_selectize_input\n")
      str(input[["outer_selectize_input"]])
      cat("inner_selectize_input\n")
      str(input[["inner_selectize_input"]])
    })
  }

runApp(shinyApp(UI, SERVER))
