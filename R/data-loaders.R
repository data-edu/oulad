#' Available packaged tables
#' @export
list_pkg_tables <- function() {
    c("assessments","courses","studentAssessment","studentInfo",
      "studentRegistration","vle","studentVle_ds")
}

.find_ext <- function(rel) {
    p <- system.file("extdata", rel, package = utils::packageName())
    if (identical(p, "")) stop("Missing extdata file/folder: ", rel, call. = FALSE)
    p
}

# Small tables (single parquet)
#' @export
assessments         <- function() arrow::read_parquet(.find_ext("assessments.parquet")) |> tibble::as_tibble()
#' @export
courses             <- function() arrow::read_parquet(.find_ext("courses.parquet")) |> tibble::as_tibble()
#' @export
studentAssessment   <- function() arrow::read_parquet(.find_ext("studentAssessment.parquet")) |> tibble::as_tibble()
#' @export
studentInfo         <- function() arrow::read_parquet(.find_ext("studentInfo.parquet")) |> tibble::as_tibble()
#' @export
studentRegistration <- function() arrow::read_parquet(.find_ext("studentRegistration.parquet")) |> tibble::as_tibble()
#' @export
vle                 <- function() arrow::read_parquet(.find_ext("vle.parquet")) |> tibble::as_tibble()

# Big table: open the dataset lazily and let users filter before collecting
#' Open the partitioned studentVle dataset (lazy)
#' @return An Arrow Dataset; use dplyr verbs then `collect()`
#' @examples
#' # Read only one presentation
#' # open_studentVle() |>
#' #   dplyr::filter(code_module == "AAA", code_presentation == "2013B") |>
#' #   dplyr::collect()
#' @export
open_studentVle <- function() {
    arrow::open_dataset(.find_ext("studentVle_ds"))
}

#' Convenience: load a slice of studentVle
#' @param module Optional code module (character scalar)
#' @param presentation Optional code presentation (character scalar)
#' @param date_between Optional numeric(2) for inclusive date window (OULAD uses day offsets)
#' @export
studentVle <- function(module = NULL, presentation = NULL, date_between = NULL) {
    ds <- open_studentVle()
    if (!is.null(module))      ds <- dplyr::filter(ds, .data$code_module == module)
    if (!is.null(presentation))ds <- dplyr::filter(ds, .data$code_presentation == presentation)
    if (!is.null(date_between) && length(date_between) == 2L) {
        ds <- dplyr::filter(ds, .data$date >= date_between[1], .data$date <= date_between[2])
    }
    dplyr::collect(ds) |> tibble::as_tibble()
}
