## rxval: reactive value (with caching)
## rxobs: reactive observer
## rxexp: reactive expression (with caching)
## rxfun: reactive function (without caching, but with reactive dependencies)

forceable_rxfun <- function(rxfun) {
  rxexp <- reactive(rxfun())
  function(.force = FALSE) {
    if(isTRUE(.force)) rxfun() else rxexp()
  }
}

rxval <- reactiveVal(0)

doit <- function() print("doing it")

rxfun <- function() {
  print("starting rxfun")
  doit()
  print("ending rxfun")
}

new_rxfun <- forceable_rxfun(rxfun)

