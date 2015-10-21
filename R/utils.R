
roxygen_function <- function(name) {
  get(name, envir = asNamespace("roxygen2"), inherits = FALSE)
}

trim <- function(x) {
  sub("\\s$", "", sub("^\\s*", "", x))
}

ws_to_empty <- function(x) {
  sub("^\\s*$", "", x)
}

## Check if a string contains a pattern exactly once. Overlapping
## patterns do not count.

contains_once <- function(x, pattern, ...) {
  length(strsplit(x = x, split = pattern, ...)[[1]]) == 2
}

is_empty_xml <- function(x) {
  is(x, "xml_nodeset") && length(x) == 0
}
