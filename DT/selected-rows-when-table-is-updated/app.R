library(rlang)
library(vctrs)
library(magrittr)
library(shiny)


UI <- fluidPage(
  actionButton("randomize_table_button", "Shuffle rows"),
  DT::dataTableOutput("dt"),
  tags$hr(),
  verbatimTextOutput("DEBUG")
)


SERVER <- function(input, output, session) {

  rxexp_mtcars <- reactive({
    input[["randomize_table_button"]]
    mtcars %>% dplyr::sample_frac(1)
  })

  output[["dt"]] <- DT::renderDataTable({
    mtcars %>%
      dplyr::slice(0) %>%
      DT::datatable(
        rownames = FALSE,
        selection = list(mode = "single", target = "row")
      )
  })
  dt_proxy <- DT::dataTableProxy("dt")

  observe({
    DT::replaceData(dt_proxy, rxexp_mtcars(), rownames = FALSE, clearSelection = "none")
    DT::selectRows(dt_proxy, 17)
  })

  output[["DEBUG"]] <- renderPrint({
    input[["dt_rows_selected"]]
  })
}


APP <- shinyApp(UI, SERVER)
