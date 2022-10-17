box::use(r/core[...])
box::use(magrittr[`%>%`])
box::use(shiny[...])

lock_input <- function(input_id, locked = FALSE, ...) {
  tagList(
    tags$span(
      class = "form-group shiny-input-container lock-icon-input",
      icon("lock", class = "data-lock-icon"),
      icon("unlock", class = "data-unlock-icon")
    )
  )
}
                              
