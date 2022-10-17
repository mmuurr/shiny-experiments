library(shiny)

invalidator <- function() {
  rxval <- reactiveVal(0)
  list(
    invalidate = function() {
      rxval(shiny::isolate(rxval()) + 1)
    },
    depend = function() rxval()
  )
}
inv <- invalidator()



ObserveWrapper <- R6::R6Class(
  classname = "ObserveWrapper",
  inherit   = NULL,
  cloneable = FALSE,

  private = list(
    finalize = function() {
      print(sprintf("%s: finalizing", self$name))
      self$obs$destroy()
      print(sprintf("%s: finalized", self$name))
    }
  ),

  public = list(
    name = NULL,
    obs = NULL,
    initialize = function(name, invalidator) {
      self$name <- name
      self$obs <- shiny::observe({
        invalidator$depend()
        print(sprintf("%s: observe", self$name))
      })
    }
  )
)


obj1 <- ObserveWrapper$new("obj1", inv)
obj2 <- ObserveWrapper$new("obj2", inv)

shiny:::flushReact()

inv$invalidate()

shiny:::flushReact()

rm(obj1, obj2)
gc()

obj3 <- ObserveWrapper$new("obj3", inv)
obj4 <- ObserveWrapper$new("obj4", inv)

shiny:::flushReact()

inv$invalidate()
shiny:::flushReact()

obj3$obs$destroy()
obj4$obs$destroy()

inv$invalidate()
shiny:::flushReact()

rm(obj3, obj4)
gc()


ReactiveValWrapper <- R6::R6Class(
  classname = "ReactiveValWrapper",
  inherit = NULL,
  cloneable = FALSE,
  private = list(
    finalize = function() {
      print(sprintf("%s: finalizing", self$name))
      self$rxval <- NULL
      print(sprintf("%s: finalized", self$name))
    }
  ),
  public = list(
    name = NULL,
    rxval = NULL,
    initialize = function(name) {
      self$name <- name
      self$rxval <- shiny::reactiveVal(0)
    }
  )
)

rxval1 <- ReactiveValWrapper$new("rxval1")
rxval2 <- ReactiveValWrapper$new("rxval2")

rm(rxval1)
gc()


ReactiveFunWrapper <- R6::R6Class(
  classname = "ReactiveFunWrapper",
  inherit = NULL,
  cloneable = FALSE,
  private = list(
    finalize = function() {
      print(sprintf("%s: finalizing", self$name))
      print(sprintf("%s: finalized", self$name))
    }
  ),
  public = list(
    name = NULL,
    rxfun = NULL,
    initialize = function(name, invalidator) {
      self$name <- name
      self$rxfun <- shiny::reactive({
        invalidator$depend()
        print(sprintf("%s: rxfun", self$name))
      })
    }
  )
)


rxfun1 <- ReactiveFunWrapper$new("rxfun1", inv)
rxfun2 <- ReactiveFunWrapper$new("rxfun2", inv)

## force an observer on rxfun1 and rxfun2
obs <- shiny::observe({
  rxfun1$rxfun()
  rxfun2$rxfun()
})

shiny:::flushReact()

rm(rxfun1)
gc()

inv$invalidate()
shiny:::flushReact()
