
restricted_markdown <- function(key, rest) {
  list(key = key, rest = markdown(rest, tags_restricted))
}

full_markdown <- function(key, rest) {
  list(key = key, rest = markdown(rest, tags))
}

#' @importFrom commonmark markdown_xml
#' @importFrom xml2 read_xml

markdown <- function(text, tags) {
  md <- markdown_xml(text, hardbreaks = TRUE)
  xml <- read_xml(md)
  trim(markdown_rparse(xml, tags))
}

#' @importFrom xml2 xml_name xml_type xml_text xml_contents xml_attr
#'   xml_children

markdown_rparse <- function(xml, tags) {

  ## We have a string, a list of things, or XML stuff

  ## Strings are simply returned
  if (is.character(xml)) return(paste(xml, collapse = ""))

  ## List is iterated over
  if (is(xml, "list")) {
    return(paste(vapply(xml, markdown_rparse, "", tags = tags),
                 collapse = ""))
  }

  ## Otherwise it is XML stuff, node set
  if (is(xml, "xml_nodeset")) {
    return(paste(vapply(xml, markdown_rparse, "", tags = tags),
                 collapse = ""))
  }

  ## text node, only keep if not entirely whitespace
  if (is(xml, "xml_node") && xml_type(xml) == "text") {
    return(ws_to_empty(xml_text(xml)))
  }

  ## generic node
  if (is(xml, "xml_node") && xml_type(xml) == "element") {
    return(markdown_rparse(tags[[ xml_name(xml) ]](xml), tags = tags))
  }

  warning("Unknown xml object")
}

tags <- list(

  unknown = function(xml) {
    ## Just ignore the tag, keep the contents
    xml_contents(xml)
  },

  document = function(xml) {
    ## Keep the contents only, tag does nothing
    xml_contents(xml)
  },

  block_quote = function(xml) {
    ## Cannot really format this in Rd, so we just leave it
    xml_contents(xml)
  },

  list = function(xml) {
    ## A list, either bulleted or numbered
    type <- xml_attr(xml, "type")
    if (type == "ordered") {
      list("\n\\enumerate{", xml_contents(xml), "\n}")
    } else {
      list("\n\\itemize{", xml_contents(xml), "\n}")
    }
  },

  item = function(xml) {
    ## A single item within a list. We remove the first paragraph
    ## tag, to avoid an empty line at the beginning of the first item.
    cnts <- xml_children(xml)
    if (xml_name(cnts[[1]]) == "paragraph") {
      cnts <- list(xml_contents(cnts[[1]]), cnts[-1])
    }
    list("\n\\item ", cnts)
  },

  code_block = function(xml) {
    ## Large block of code
    list("\\preformatted{", xml_contents(xml), "}")
  },

  html = function(xml) {
    ## Not sure what to do with this, we'll just leave it
    xml_contents(xml)
  },

  paragraph = function(xml) {
    ## Paragraph
    list("\n\n", xml_contents(xml))
  },

  header = function(xml) {
    ## Not sure what this is, ignore it for now.
    xml_contents(xml)
  },

  hrule = function(xml) {
    ## We cannot have horizontal rules, will just start a new
    ## paragraph instead.
    "\n\n"
  },

  text = function(xml) {
    ## Just ordinary text, leave it as it is.
    xml_text(xml)
  },

  softbreak = function(xml) {
    ## Inserted line break (?).
    "\n"
  },

  linebreak = function(xml) {
    ## Original line break (?).
    "\n"
  },

  code = function(xml) {
    ## Inline code. Check if it is a link.
    link <- parse_manual_link(xml)
    if (!is.null(link)) {
      if (link$pkg != "") link$pkg <- paste0("[", link$pkg, "]")
      paste0("\\code{\\link", link$pkg, "{", link$func, "}}")
    } else {
      list("\\code{", xml_contents(xml), "}")
    }
  },

  inline_html = function(xml) {
    ## Will just ignore this for now.
    xml_contents(xml)
  },

  emph = function(xml) {
    ## Emphasized text.
    list("\\emph{", xml_contents(xml), "}")
  },

  strong = function(xml) {
    ## Bold text.
    list("\\strong{", xml_contents(xml), "}")
  },

  link = function(xml) {
    ## Hyperlink
    dest <- xml_attr(xml, "destination")
    if (dest == "") {
      list("\\url{", xml_contents(xml), "}")
    } else {
      list("\\href{", dest, "}{", xml_contents(xml), "}")
    }
  },

  image = function(xml) {
    dest <- xml_attr(xml, "destination")
    title <- xml_attr(xml, "title")
    paste0("\\figure{", dest, "}{", title, "}")
  }

)

tags_restricted <- tags
