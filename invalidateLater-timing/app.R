library(tidyverse)
library(shiny)

observe({
  print("entering observe")
  invalidateLater(1000)
  Sys.sleep(0.9)
})

ui <- HTML('<HTML></HTML>')

server <- function(input, output, session) {
  ## NOP
}

shinyApp(ui, server)


## it appears that invalidateLater sets a timestamp.
## adding the 0.9 sleep doesn't do anything to the ~1 second intervals in the example above.
## changing 0.9 to 3 changes the intervals to 3 seconds.
## so the period using invalidateLater(x) =
##   max(x, exec_timedelta_after_invalidateLater)
