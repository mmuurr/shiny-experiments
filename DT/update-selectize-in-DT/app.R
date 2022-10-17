library(rlang)
library(vctrs)
library(magrittr)
library(tidyverse)
library(shiny)

## vectorized
f_geo_select_input_id <- function(partial_id) {
  sprintf("select_input_%s", partial_id)
}

geo_consensus_row_config <- list(
  "top_tube_length_mm" = tibble::lst(
    geo_id = "top_tube_length_mm",
    shiny_input_id = f_geo_select_input_id(geo_id),
    label = "Top tube length (mm)"
  ),
  "seat_tube_length_mm" = tibble::lst(
    geo_id = "seat_tube_length_mm",
    shiny_input_id = f_geo_select_input_id(geo_id),
    label = "Seat tube length (mm)"
  )
)

geo_consensus_initial_tbl <- tibble::tibble(
  geo_id =
    map_chr(geo_consensus_row_config, list("geo_id")) %>%
    set_attr("dt_colopts", list(visible = FALSE)) %>%
    set_attr("dt_escape", TRUE),
  label =
    map_chr(geo_consensus_row_config, list("label")) %>%
    set_attr("dt_colopts", list(title = "Geometry element", sortable = FALSE)) %>%
    set_attr("dt_escape", TRUE),
  select_input_html =
    map_chr(geo_consensus_row_config, function(x) {
      HTML(as.character(selectizeInput(x$shiny_input_id, "", choices = c("foo","bar","baz"), options = list(create = TRUE))))
    }) %>%
    set_attr("dt_colopts", list(title = "Common values", sortable = FALSE)) %>%
    set_attr("dt_escape", FALSE)
)

geo_consensus_initial_dt <-
  geo_consensus_initial_tbl %>% {
    DT::datatable(
      data = .,
      options = list(
        columns = unname(map(., attr, "dt_colopts")),
        paging = FALSE,
        preDrawCallback = DT::JS("function(settings) {
          console.log('predraw');
          Shiny.unbindAll(this.api().table().node());
        }"),
        drawCallback = DT::JS("function(settings) {
          console.log('draw');
          Shiny.initializeInputs(this.api().table().node());
          Shiny.bindAll(this.api().table().node());
        }"),
        NULL
      ),
      rownames = FALSE,
      escape = map_lgl(., attr, "dt_escape"),  ## TODO: make more robust; this fails if attribute is missing or is non-logical
      selection = "none",
      filter = "none",
      style = "bootstrap",
      class = "table-condensed"
    )
  }

geo_consensus_initial_table <-
  tags$table(class = "table table-condensed",
    tags$thead(
      tags$th("Geometry element"),
      tags$th("Common values")
    ),
    tags$tbody(
      map(geo_consensus_row_config, function(row_config) {
        tags$tr(
          tags$td(row_config$label),
          tags$td(style = "line-height:0;margin-bottom:0px",
            HTML(as.character(selectizeInput(row_config$shiny_input_id, "", choices = character(0), options = list(create = TRUE))))
          )
        )
      }) %>% tagList()
    )
  )
    


UI <-
  fluidPage(
    tags$div(style = "display:none;", selectizeInput("_META_SELECTIZE_INPUT", NULL, NULL, options = list(create = TRUE))),
    wellPanel(
      fluidRow(
        column(4, actionButton("choices_lower_button", label = "Set lower choices")),
        column(4, actionButton("choices_upper_button", label = "Set upper choices")),
        column(4, verbatimTextOutput("selected_choices"))
      )
    ),
    wellPanel(
      DT::DTOutput("geo_dt")
      #geo_consensus_initial_table
    )
  )


SERVER <- function(input, output, session) {

  rxval_geo_consensus_choices <- reactiveVal(map(geo_consensus_row_config, ~NULL))

  output[["geo_dt"]] <- DT::renderDT(geo_consensus_initial_dt)
  geo_dt_proxy <- DT::dataTableProxy("geo_dt")
  outputOptions(output, "geo_dt", suspendWhenHidden = FALSE)

  observeEvent(input[["choices_lower_button"]], {
    print("lower")
    rxval_geo_consensus_choices(list(
      "top_tube_length_mm" = letters[1:3],
      "seat_tube_length_mm" = letters[4:7]
    ))
  })
  observeEvent(input[["choices_upper_button"]], {
    print("upper")
    rxval_geo_consensus_choices(list(
      "top_tube_length_mm" = LETTERS[1:3],
      "seat_tube_length_mm" = LETTERS[4:7]
    ))
  })

  observe({
    walk(geo_consensus_row_config, function(row_config) {
      choices <- rxval_geo_consensus_choices()[[row_config$geo_id]]
      if (is.null(choices)) return()
      updateSelectizeInput(session, row_config$shiny_input_id, choices = choices)
    })
  })

  output[["selected_choices"]] <- renderPrint({
    walk(geo_consensus_row_config, function(row_config) {
      print(input[[row_config$shiny_input_id]])
    })
  })

}


shinyApp(UI, SERVER)
