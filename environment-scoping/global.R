print("reading global.R")

explore <- function(f, name) {
  f_env <- rlang::get_env(f)
  f_env_parents <- rlang::env_parents(f_env)
  print(name)
  print(capture.output(f_env))
  print(capture.output(f_env_parents))
  NULL
}


f_global <- function() NULL
explore(f_global, "global")
