
roxygen_function <- function(name) {
  get(name, envir = asNamespace("roxygen2"), inherits = FALSE)
}

trim <- function(x) {
  sub("\\s$", "", sub("^\\s*", "", x))
}

ws_to_empty <- function(x) {
  sub("^\\s*$", "", x)
}

parse_manual_link <- function(xml) {
  txt <- xml_text(xml)

  ## package name might be missing. If not missing it must start with a
  ## letter and must be at least two characters long
  reg <- regexpr(
    "^((?<p>[a-zA-Z][a-zA-Z0-9\\.]+)|)::(?<f>[a-zA-Z\\.][a-zA-Z\\.0-9]*)$",
    txt,
    perl = TRUE
  )
  if (reg != 1L) return(NULL)

  pkg <- if (attr(reg, "capture.start")[,"p"] == 0) {
    ""
  } else {
    substring(
      txt,
      attr(reg, "capture.start")[,"p"],
      attr(reg, "capture.start")[,"p"] + attr(reg, "capture.length")[,"p"] - 1
    )
  }

  func <- substring(
    txt,
    attr(reg, "capture.start")[,"f"],
    attr(reg, "capture.start")[,"f"] + attr(reg, "capture.length")[,"f"] - 1
  )

  list(pkg = pkg, func = func)
}
