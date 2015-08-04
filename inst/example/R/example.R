
#' @title Documentation example for `maxygen`
#'
#' @description
#' Note that you explicitly need to use `@@title`, `@@description` and
#' also `@@details`.
#' 
#' @details
#' We test each feature here.
#'
#' @section Simple markup:
#' This is **strong** and there are *both* _emphasized_, probably as
#' italic.
#' 
#' @section List:
#' Bulleted list:
#' * First item.
#' * Second item.
#'
#' Numbered list:
#' 1. Fist item.
#' 1. Second item.
#'
#' Nested lists:
#' * Bulleted item containing
#'     1. a numbered
#'     1. list.
#' * Another bulleted item.
#'
#' Nested lists of the same kind:
#' * Bulleted first
#'     * containing
#'     * another bulleted
#' * Bulleted second.
#'
#' 1. Numbered first,
#'     1. containing
#'     1. another numbered.
#' 1. Numbered second.
#'
#' @section Code:
#'
#' Inline code is simple like `2 times 2`. Code blocks are also easy:
#' ```
#' markdown <- function(text, tags) {
#'   md <- markdown_xml(text, hardbreaks = TRUE)
#'   xml <- read_xml(md)
#'   trim(markdown_rparse(xml, tags))
#' } 
#' ```
#'
#' @section Links:
#' This is just a link: [http://igraph.org]().
#' This is another link: [igraph](http://igraph.org).
#' 
#' @param x Markdown is **allowed** for parameters _as well_.
#' @return This is a _return value_.
#'
#' @note
#' Markdown can be used within a _note_, **of course**.
#'
#' @author
#' This was written by _Bugs Bunny_, so don't blame me.
#' 
#' @export
#' @family maxygen examples
#' @seealso Don't forget to read _Writing R extensions_. Here is a link:
#'   [https://cran.r-project.org/doc/manuals/r-release/R-exts.html]().

MD <- function(x) {
  "Keep Cool and MarkDown!"
}

#' Another example, to have a family
#'
#' @param x This is ignored, sorry.
#' 
#' @family maxygen examples
#' @export

MD2 <- function(x) {
  "Still looking cool!"
}
