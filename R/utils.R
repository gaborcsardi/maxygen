
roxygen_function <- function(name) {
  get(name, envir = asNamespace("roxygen2"), inherits = FALSE)
}
