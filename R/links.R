
## Parse a MarkDown link, to see if we should create an Rd link
##
## * [](::function) becomes \link{function}
## * [](pkg::function) becomes \link[pkg]{function}
## * [name](::=dest) becomes \link[=dest]{name}
## * [name](pkg::bar) becomes \link[pkg:bar]{name}
##
## S3/S4 classes are also supported
## * [terms](::=terms.object) becomes \link[=terms.object]{terms}
## * [abc](::=abc-class) becomes \link[=abc-class]{abc}
##
## These actually do not require any special treatment from the
## parser, they are included in the four cases above.

parse_link <- function(destination, contents) {

  ## destination must contain :: exactly once, otherwise it is not an Rd link
  if (!contains_once(destination, "::", fixed = TRUE)) return(NULL)

  ## if contents is a `code tag`, then we need to move this outside
  ## of the link, Rd does not like \link{\code{}}, only \code{\link{}}
  pre <- post <- ""
  if (length(contents) == 3 &&
      xml_name(contents[[1]]) == "text" &&
      xml_name(contents[[2]]) == "code" &&
      xml_name(contents[[3]]) == "text") {
    pre <- paste0(ws_to_empty(xml_text(contents[[1]])), "\\code{")
    post <- paste0("}", ws_to_empty(xml_text(contents[[3]])))
    contents <- xml_contents(contents[[2]])
  }

  split_contents <- strsplit(destination, "::", fixed = TRUE)[[1]]
  pkg <- split_contents[1]
  func <- split_contents[2]

  if (is_empty_xml(contents) && pkg == "") {
    ## [](::function) -> \link{function}
    paste0("\\code{\\link{", func, "}}")

  } else if (is_empty_xml(contents)) {
    ## [](pkg::function) -> \link[pkg]{function}
    paste0("\\code{\\link[", pkg, "]{", func, "}}")

  } else if (pkg == "") {
    ## [name](::=dest) -> \link[=dest]{name}
    list(pre, paste0("\\link[", func, "]{"), contents, "}", post)

  } else {
    ## [name](pkg::bar) -> \link[pkg:bar]{name}
    list(pre, paste0("\\link[", pkg, ":", func, "]{"), contents, "}", post)
  }
}
