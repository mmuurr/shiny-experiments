library(rlang)
library(vctrs)
library(magrittr)
library(shiny)

library(reactlog)
reactlog_enable()

LGR <- lgr::get_logger_glue("app")
LGR$set_threshold("trace")

shiny::registerInputHandler("risio.livegame.hostRoundMultInputBinding", function(data, ...) {
  tryCatch({
    LGR$debug("handling risio.livegame.hostRoundMultInputBinding input {capture.output(str(data))}")
    return(list(data = NULL))
    obj <- jsonlite::fromJSON(data, simplifyDataFrame = FALSE, simplifyMatrix = FALSE)
    retval <- list(
      client_datetime = lubridate::as_datetime(obj$jsnow * 1e3),
      server_datetime = lubridate::now(),
      data =
        if (is.null(obj$data)) {
          NULL
        } else {
          host_round_mult_input__val(obj$playerMults, obj$hostMults)
        }
    )
    str(retval)
    retval
  }, error = function(e) NULL)
}, force = TRUE)

## shiny::registerInputHandler("risio.livegame.hostRoundMultInputBinding", function(data, ...) {
##   LGR$trace("returning a zero-arg function")
##   function() {
##     LGR$debug("handling risio.livegame.hostRoundMultInputBinding input {capture.output(str(data))}")
##     obj <- jsonlite::fromJSON(data, simplifyDataFrame = FALSE, simplifyMatrix = FALSE)
##     retval <- list(
##       client_datetime = lubridate::as_datetime(obj$jsnow * 1e3),
##       server_datetime = lubridate::now(),
##       data =
##         if (is.null(obj$data)) {
##           NULL
##         } else {
##           host_round_mult_input__val(obj$playerMults, obj$hostMults)
##         }
##     )
##     str(retval)
##     retval
##   }
## }, force = TRUE)

host_round_mult_input__val <- function(player_mults, host_mults, .safe = TRUE) {
  checkmate::assert_numeric(player_mults)
  checkmate::assert_numeric(host_mults)
  checkmate::assert_true(length(player_mults) == length(host_mults))
  round_labels <- sprintf("R%d", seq_along(host_mults))
  list(
    player_mults  = player_mults,
    host_mults    = host_mults,
    round_labels  = round_labels,
    round_count   = length(round_labels)
  )
}

## host_round_mult_input__row <- function(round_label, player_mult, host_mult) {
##   withTags(tr(
##     td(round_label),
##     td(player_mult),
##     td(input(type = "number", class = "form-control", min = "1", step = "1", value = tidyr::replace_na(host_mult, "")))
##   ))
## }

host_round_mult_input__update <- function(session, input_id, val) {
  msg <-
    with(val, list(
      roundCount = round_count,
      roundLabels = I(round_labels),
      playerMults = I(player_mults),
      hostMults = I(host_mults)
    )) %>% jsonlite::toJSON(auto_unbox = TRUE, na = "null", null = "null")
  session$sendInputMessage(input_id, msg)
}

host_round_mult_input <- function(input_id) {
  tagList(

    singleton(tags$head(
      tags$script(src = "host-round-mult.js")
    )),

    withTags(
      div(id = input_id, class = "risio-livegame-host-mult-input form-group",
        table(class = "table table-hover",
          tr(th(), th("Player Mult"), th("Host Mult"))
        )
      )
    )
  )
}


UI <-
  fluidPage(
    fluidRow(
      column(12,
        actionButton("show_modal_button", label = "Show modal")
      )
    ),
    fluidRow(
      column(6,
        actionButton("update_foo1", label = "Update"),
        host_round_mult_input("foo1")
      ),
      column(6,
        actionButton("update_foo2", label = "Update"),
        host_round_mult_input("foo2")
      )
    )
  )


lgr_error_handler <- function(e) try(LGR$error(conditionMessage(e)))


SERVER <- function(input, output, session) {
  LGR$info("starting session", token = session$token)

  ## observeEvent(input[["foo1"]], {
  ##   LGR$debug("foo1 INIT observer")
  ##   if (isTRUE(input[["foo1"]] == "INIT"))
  ##     host_round_mult_input__update(session, "foo1", host_round_mult_input__val(1:2, 2:1))
  ## }, ignoreInit = FALSE, ignoreNULL = TRUE)

  ## observeEvent(input[["foo1"]], {
  ##   LGR$debug("foo1 input observer {capture.output(str(input[['foo1']]))}")
  ## }, ignoreInit = TRUE, ignoreNULL = TRUE)

  ## observeEvent(input[["foo1__ready"]], {
  ##   LGR$debug("foo1__ready")
  ##   host_round_mult_input__update(session, "foo1", foo1_val())
  ## }, ignoreInit = FALSE, ignoreNULL = TRUE)

  ## observe({
  ##   try(str(input[["host_round_mult_1"]]))
  ## })

  
  observeEvent(input[["show_modal_button"]], {
    tryCatch({
      LGR$debug("showing modal")
      showModal(
        modalDialog(
          host_round_mult_input("host_round_mult_1")
        )
      )

      observeEvent(
        tryCatch({
          LGR$debug("host_round_mult_1 eventExpr")
          input[["host_round_mult_1"]]
        }, error = lgr_error_handler),
        tryCatch({
          LGR$debug("host_round_mult_1 updater")
          if (is.null(input[["host_round_mult_1"]]$data)) {
            host_round_mult_input__update(session, "host_round_mult_1", host_round_mult_input__val(1:5, runif(5)))
          } else {
            LGR$warn("host_round_mult_1 updater ... shouldn't get here")
          }
        },
        error = function(e) {
          LGR$error(conditionMessage(e))
        }),
        ignoreInit = TRUE, ignoreNULL = TRUE, once = TRUE, label = "table updater")
    }, error = function(e) {
      LGR$error(conditionMessage(e))
    })
  }, ignoreInit = TRUE, ignoreNULL = TRUE, label = "show modal button handler")

  ## observe({
  ##   print("TIMER")
  ##   invalidateLater(1000)
  ## })

  ## observeEvent(input[["host_round_mult_1"]], {
  ##   LGR$debug("updating host_round_mult_1")
  ##   host_round_mult_input__update(session, "host_round_mult_1", host_round_mult_input__vals(1:3, c(1, NA, 3)))
  ## }, ignoreInit = TRUE, ignoreNULL = FALSE)

}


shinyApp(UI, SERVER)
