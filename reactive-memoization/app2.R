library(rlang)
library(vctrs)
library(magrittr)
library(tidyverse)
library(shiny)

flush <- shiny:::flushReact

rxval <- reactiveVal(0)

rxfun_1 <- reactive({
  print("running rxfun_1")
  rxval()
})

fun_2 <- function() {
  print("running fun_2")
  rxfun_1()
}


isolate(rxfun_1())
## rxfun_1 YES

isolate(fun_2())
## fun_2 YES; rxfun_1 NO

rxval(1)

isolate(fun_2())
## fun_2 YES; rxfun_1 YES

isolate(fun_2())
## fun_2 YES; rxfun_1 NO


