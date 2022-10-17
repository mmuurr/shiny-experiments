library(tibble)
library(shiny)

ui <- fluidPage(
  plotOutput("tblplot", click = "tblplot_click", dblclick = "tblplot_dblclick", brush = brushOpts("tblplot_brush", resetOnNew = TRUE)),
  actionButton("refresh_plot", "Refresh plot"),
  verbatimTextOutput("counts")
)

server <- function(input, output, session) {

  f_tbl <- function() tibble(x = rnorm(100), y = rnorm(100))

  output$tblplot <- renderPlot({
    input$refresh_plot
    plot(f_tbl())
  })
  
  invalidate_counts <- reactiveValues(
    brush = 0,
    click = 0,
    dblclick = 0
  )

  observe({
    input$tblplot_click
    isolate(invalidate_counts$click <- invalidate_counts$click + 1)
  })
  observe({
    input$tblplot_dblclick
    isolate(invalidate_counts$dblclick <- invalidate_counts$dblclick + 1)
  })
  observe({
    input$tblplot_brush
    isolate(invalidate_counts$brush <- invalidate_counts$brush + 1)
  })

  output$counts <- renderPrint({
    reactiveValuesToList(invalidate_counts)
  })
}

shinyApp(ui, server)
