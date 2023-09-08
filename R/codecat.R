
#' Define the data coding scheme for a variable
#'
#' @param variable Name of the variable
#' @param levels Vector specifying the factor levels
#' @param labels Vector specifying the factor labels
#'
#' @return A tibble with three columns and one row per factor level
#' @export
#'
#' @examples
#'   code("SEX", levels = c(0, 1), labels = c("Male", "Female"))
code <- function(variable, levels, labels) {
  tibble::tibble(
    variable = variable,
    level = levels,
    label = labels
  )
}

#' Define a codebook for a collection of variables
#'
#' @param ... One or more data coding schemes
#'
#' @return A list of tibbles
#' @export
#'
#' @examples
#' codebook(
#'   code("SEX", levels = c(0, 1), labels = c("Male", "Female")),
#'   code("STUDY", levels = c(1, 2, 3), labels = c("S1", "S2", "S3"))
#' )
codebook <- function(...) {
  map <- rlang::list2(...)
  names(map) <- purrr::map_chr(map, function(x) x$variable[1])
  return(map)
}

#' Use a codebook to create factors
#'
#' @param data A data frame or tibble
#' @param codebook A codebook
#'
#' @return Data set with variables encoded as factors
#' @export
#'
#' @examples
#' labels <- codebook(
#'   code("SEX", levels = c(0, 1), labels = c("Male", "Female")),
#'   code("STUDY", levels = c(1, 2, 3), labels = c("S1", "S2", "S3"))
#' )
#' dataset <- data.frame(
#'    STUDY = c(1, 1, 1, 2, 2, 2),
#'    SEX   = c(0, 0, 1, 1, 1, 0),
#'    AGE   = c(32, 18, 64, 52, 26, 80)
#' )
#' encode(dataset, labels)
encode <- function(data, codebook) {
  mapped_vars <- names(codebook)
  mapped_data <- purrr::map2(
    data,
    names(data),
    function(x, var, m) {
      if(!(var %in% mapped_vars)) return(x)
      x <- factor(x, levels = m[[var]]$level, labels = m[[var]]$label)
      return(x)
    },
    m = codebook
  )
  tibble::as_tibble(mapped_data)
}

#' Use a codebook to recreate original levels from factors
#'
#' @param data A data frame or tibble
#' @param codebook A codebook
#'
#' @return Data set with variables encoded as factors
#' @export
#'
#' @examples
#' labels <- codebook(
#'   code("SEX", levels = c(0, 1), labels = c("Male", "Female")),
#'   code("STUDY", levels = c(1, 2, 3), labels = c("S1", "S2", "S3"))
#' )
#' dataset <- data.frame(
#'    STUDY = factor(c("S1", "S1", "S1", "S2", "S2", "S2")),
#'    SEX   = factor(c("Male", "Male", "Female", "Female", "Female", "Male")),
#'    AGE   = c(32, 18, 64, 52, 26, 80)
#' )
#' decode(dataset, labels)
decode <- function(data, codebook) {
  mapped_vars <- names(codebook)
  mapped_data <- purrr::map2(
    data,
    names(data),
    function(x, var, m) {
      if(!(var %in% mapped_vars)) return(x)
      x_chr <- as.character(x)
      x_lvl <- m[[var]]$level
      x_lab <- m[[var]]$label
      x <- x_lvl[match(x_chr, x_lab)]
      return(x)
    },
    m = codebook
  )
  tibble::as_tibble(mapped_data)
}



