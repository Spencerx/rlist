#' Clean a list by a function
#'
#' This function removes all elements evaluated to be
#' \code{TRUE} by an indicator function. The removal can be recursive
#' so that the resulted list surely does not include such elements in
#' any level.
#'
#' @details
#' Raw data is usually not completely ready for analysis, and needs to
#' be cleaned up to certain standards. For example, some data operations
#' require that the input does not include \code{NULL} values in any
#' level, therefore \code{fun = "is.null"} and \code{recursive = TRUE}
#' can be useful to clean out all \code{NULL} values in a list at any
#' level.
#'
#' Sometimes, not only \code{NULL} values are undesired,
#' empty vectors or lists are also unwanted. In this case,
#' \code{fun = function(x) length(x) == 0L} can be useful to remove
#' all empty elements of zero length. This works because
#' \code{length(NULL) == 0L}, \code{length(list()) == 0L} and
#' \code{length(numeric()) == 0L} are all \code{TRUE}.
#'
#' @param .data A \code{list} or \code{vector} to operate over.
#'
#' @param fun A \code{character} or a \code{function} that returns
#' \code{TRUE} or \code{FALSE} to indicate if an element of
#' \code{.data} should be removed.
#'
#' @param recursive \code{logical}. Should the list be
#' cleaned recursively? Set to FALSE by default.
#' @export
#' @examples
#' x <- list(a=NULL,b=list(x=NULL,y=character()),d=1,e=2)
#' list.clean(x)
#' list.clean(x, recursive = TRUE)
#' list.clean(x, function(x) length(x) == 0L, TRUE)
list.clean <- function(.data, fun = is.null, recursive = FALSE) {
  if (recursive) {
    .data <- lapply(.data, function(.item) {
      if (is.list(.item))
        list.clean(.item, fun, recursive = TRUE) else .item
    })
  }
  setmembers(.data, vapply(.data, fun, logical(1L)), NULL)
}
