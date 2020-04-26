library(tidyverse)
library(shiny)
library(shinyjs)

timer <- (function() {
  reactiveValues(
    state = "off",
    is_expired = FALSE,
    reset_seconds = 15,
    remaining_seconds = 15
  )
})()


js_code <- '

  shinyjs.start_js_timer_3 = function(params) {
    console.log("starting timer: " + params);
    question_timer.start({
      startValues: {seconds: params.n_seconds},
      countdown: true,
      precision: "secondTenths"
    });
  }
  shinyjs.pause_js_timer_3 = function() {
    question_timer.pause();
  }
  shinyjs.stop_js_timer_3 = function() {
    question_timer.stop();
  }
  shinyjs.reset_js_timer_3 = function() {
    question_timer.reset();
  }
  shinyjs.init = function() {
    question_timer = new easytimer.Timer();
    question_timer.addEventListener("secondTenthsUpdated", function(e) {
      $("#question_timer_display").html(question_timer.getTimeValues().seconds + "." + question_timer.getTimeValues().secondTenths);
    });
    question_timer.addEventListener("targetAchieved", function(e) {
      // NOP  
    });
  }
'

ui <- fluidPage(
  singleton(tags$head(
    tags$script(type = "text/javascript", src = "easytimer.min.js"),
    useShinyjs(),
    extendShinyjs(text = js_code, functions = c("start_js_timer_1"))
  )),
  actionButton("start-stop-button", label = "Start", icon = icon("play")),
  actionButton("reset-button", label = "Reset", icon = icon("sync")),
  textInput("timer-text-input", label = "Time (in seconds)", value = "15"),
  tags$hr(),
  actionButton("start-js-timer-3", label = "Start JS Timer", icon = icon("play")),
  tags$div(id = "question_timer_display", height = "10rem"),
  tags$hr(),
  verbatimTextOutput("DEBUG")
)


server <- function(input, output, session) {

  observeEvent(input[["start-js-timer-3"]], {
    shinyjs::js$start_js_timer_3(n_seconds = 15)
  })
  
  observeEvent(input[["reset-button"]], {
    if(timer$state == "on") {
      showModal(modalDialog("First stop the timer before resetting it.", easyClose = TRUE))
      return()
    }

    tryCatch({
      reset_seconds <- as.numeric(input[["timer-text-input"]])
      checkmate::assertNumber(reset_seconds, lower = 1, finite = TRUE)
      timer$reset_seconds <- reset_seconds
      timer$remaining_seconds <- reset_seconds
      timer$is_expired <- FALSE
    }, error = function(e) {
      showModal(modalDialog(conditionMessage(e), easyClose = TRUE))
    })    
  })

  
  observeEvent(input[["start-stop-button"]], {
    if(timer$state == "on") {
      timer$state <- "off"
      updateActionButton(session, "start-stop-button", label = "Start", icon = icon("play"))  ## show Start when off
    } else {
      timer$state <- "on"
      updateActionButton(session, "start-stop-button", label = "Stop", icon = icon("stop"))  ## show Stop when on
    }
  })


  observe({
    if(timer$state == "off") return()  ## NOP, short-circuiting the next invalidateLater tick
    ## else
    invalidateLater(1000)
    isolate({
      timer$remaining_seconds <- max(timer$remaining_seconds - 1, 0)  ## keep remaining_seconds >= 0
      if(timer$remaining_seconds <= 0) {
        timer$state <- "off"
        timer$is_expired <- TRUE
      }
    })
  })
  
  
  output$DEBUG <- renderPrint({
    print(reactiveValuesToList(timer))
  })
  
}

shinyApp(ui, server)
