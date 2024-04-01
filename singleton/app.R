library(tidyverse)
library(shiny)

## ui <- fluidPage(
##   tags$head(
##     singleton(tags$script(src = "foo")),
##     tags$script(src = "foo")
##   ),
##   tags$script(src = "foo")
## )

## ui <- fluidPage(
##   singleton(tags$script(src = "foo")),
##   tags$head(singleton(tags$script(src = "foo")))  
## )

ui <- fluidPage(
  singleton(
    tags$head(
      tags$script(src = "foo")
    )
  ),
  tags$head(
    tags$script(src = "foo"),
    tags$script(src = "bar")
  )
)

server <- function(input, output, session) {

}

app <- shinyApp(ui, server)
runApp(app, port = 6969)
