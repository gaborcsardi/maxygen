
#' Markdown + Roxygen = Maxygen
#'
#' Write your Roxygen documentation in Markdown.
#'
#' @docType package
#' @name maxygen
NULL


#' Use Markdown and Roxygen to document a package
#'
#' @param pkg Package description, can be path or package name.  See
#'   \code{as.package} in \code{devtools} for more information.
#' @param roclets Character vector of roclet names to use with package.
#'   This defaults to \code{NULL}, which will use the \code{roclets} fields
#'   in the list provided in the \code{Roxygen} DESCRIPTION field. If none
#'   are specified, defaults to \code{c("collate", "namespace", "rd")}.
#' @param ... Additional parameters are passed to
#'   \code{devtools::document}.
#'
#' @importFrom roxygen2 register.preref.parsers
#' @importFrom devtools document
#' @export

macument <- function(pkg = ".", roclets = NULL, ...) {

  register.preref.parsers(
    restricted_markdown_value,
    "title",
    "family"
  )

  register.preref.parsers(
    full_markdown_value,
    "references",
    "note",
    "seealso",
    "return",
    "author",
    "section",
    "format",
    "source",
    "description",
    "details"
  )

  register.preref.parsers(
    full_markdown_name_description,
    "param"
  )

  document(pkg = pkg, roclets = roclets, ...)
}


restricted_markdown_value <- function(key, rest) {
  tmp <- restricted_markdown(key, rest)
  roxygen_function("parse.value")(tmp$key, tmp$rest)
}


full_markdown_value <- function(key, rest) {
  tmp <- full_markdown(key, rest)
  roxygen_function("parse.value")(tmp$key, tmp$rest)
}


full_markdown_name_description <- function(key, rest) {
  tmp <- full_markdown(key, rest)
  roxygen_function("parse.name.description")(tmp$key, tmp$rest)
}


#' @importFrom commonmark markdown_xml
#' @importFrom xml2 xml_name

restricted_markdown <- function(key, rest) {
  print(paste(key, "restricted"))
  list(key = key, rest = rest)
}


#' @importFrom commonmark markdown_xml
#' @importFrom xml2 xml_name

full_markdown <- function(key, rest) {
  print(paste(key, "full"))
  list(key = key, rest = rest)
}
