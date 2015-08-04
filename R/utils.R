
roxygen_function <- function(name) {
  get(name, envir = asNamespace("roxygen2"), inherits = FALSE)
}

trim <- function(x) {
  sub("\\s$", "", sub("^\\s*", "", x))
}

ws_to_empty <- function(x) {
  sub("^\\s*$", "", x)
}
