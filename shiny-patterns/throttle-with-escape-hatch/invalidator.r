#' @export
Invalidator <- R6::R6Class("Invalidator",

  private = list(
    .rxval = NULL
  ),

  public = list(
    initialize = function() {
      private$.rxval <- shiny::reactiveVal(0)
    },

    depend = function() {
      private$.rxval()
    },

    invalidate = function() {
      private$.rxval(shiny::isolate(private$.rxval()) + 1)
    }
  )
)

#' export
invalidator <- function() Invalidator$new()


#' export
Throttler <- R6::R6Class("Throttler",

  private = list(
    .upstream_rx = NULL,
    .upstream_rx.throttled = NULL,
    .invalidator = NULL
  ),

  public = list(

    initialize = function(upstream, millis, priority = 100, domain = shiny::getDefaultReactiveDomain()) {
      stopifnot(isTRUE(shiny::is.reactive(upstream)))
      private$.upstream_rx <- upstream
      private$.upstream_rx.throttled <- shiny::throttle(private$.upstream_rx, millis, priority, domain)
      private$.invalidator <- invalidator()
    },

    rxdepend = function() {
      private$.invalidator$depend()
      private$.upstream_rx.throttled()
    },
    depend = function() self$rxdepend(),

    rxget = function(.bypass = FALSE) {
      self$rxdepend()
      shiny::isolate({  ## already re-took the two (invalidator & throttled upstream) dependencies
        if (isTRUE(.bypass)) private$.upstream_rx() else private$.upstream_rx.throttled()
      })
    },

    rxinvalidate = function() private$.invalidator$invalidate(),
    invalidate = function() self$rxinvalidate()
    
  ) ## closes public
)
  
throttler <- function(upstream, millis, priority = 100, domain = shiny::getDefaultReactiveDomain()) {
  Throttler$new(upstream, millis, priority, domain)
}




accumulator <- function(init = 0) {
  rxval <- shiny::reactiveVal(init)
  set <- function(x) {
    rxval(x)
  }
  add <- function(x) {
    rxval(shiny::isolate(rxval()) + x)
  }
  get <- function() {
    rxval()
  }
  list(set = set, add = add, rxget = get, isoget = shiny::isolate(get()))
}
