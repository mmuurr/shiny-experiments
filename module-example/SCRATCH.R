generate_f <- function(x) {
  force(x)
  counter <- 0
  function(y) {
    counter <<- counter + 1
    print(counter)
    x + y
  }
}

