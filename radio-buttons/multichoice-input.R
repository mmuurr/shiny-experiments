require(shiny)

netrivia_multichoice_input <- function(input_id, label, choices = NULL, selected = NULL, choice_names = NULL, choice_values = NULL) {
  icon_red_hex_string <- "#FF0008"
  icon_blue_hex_string <- "#0077FF"
  icon_black_hex_string <- "#404040"
  
  args <- shiny:::normalizeChoicesArgs(choices, choice_names, choice_values)
  selected <- if (is.null(selected)) args$choiceValues[[1]] else as.character(selected)
  if(length(selected) > 1) stop("`selected` must of length 1")

  ## div.form-group.shiny-input-container.multichoice-input-container
  ##   div.radio-choice-group
  ##     div.radio-choice-container (one per choice)
  ##       span.radio-choice-icon
  ##       div.radio-choice-tile
  ##         input.radio-choice-tile-input
  ##         div.radio-choice-tile-fill
  ##         div.radio-choice-tile-border
  ##         div.radio-choice-tile-label
  ##       div.radio-choice-pct
  
  radio_choice_containers <- mapply(args$choiceValues, args$choiceNames, seq_along(args), FUN = function(value, name, ix) {
    choice_id <- sprintf("%s-choice-%d", input_id, ix)

    radio_choice_icon <- tags$span(class = "radio-choice-icon")  ## initially empty

    radio_choice_tile_input <- tags$input(id = choice_id, type = "radio", class = "radio-choice-tile-input", name = input_id, value = value)
    if(value %in% selected) radio_choice_tile_input <- htmltools::tagAppendAttributes(radio_choice_tile_input, checked = NA)  ## NA for present, NULL for absent
    
    radio_choice_tile <- tags$div(
      class = "radio-choice-tile",
      radio_choice_tile_input,
      tags$div(class = "radio-choice-tile-fill", style = "width:0%;"),  ## set width initially to 0%
      tags$div(class = "radio-choice-tile-border"),
      tags$div(class = "radio-choice-tile-label", name)
    )

    radio_choice_pct <- tags$div(class = "radio-choice-pct")  ## initially empty

    radio_choice_container <- tags$div(
      class = "radio-choice-container",
      radio_choice_icon,
      radio_choice_tile,
      radio_choice_pct
    )
  }, SIMPLIFY = FALSE, USE.NAMES = FALSE)

  tags$div(
    id = input_id,
    class = "form-group shiny-input-container multichoice-input-container",
    tags$div(
      class = "radio-choice-group",
      radio_choice_containers
    )
  )
}
