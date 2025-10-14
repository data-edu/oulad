#' Packaged OULAD-style tables
#'
#' Six small tables are shipped as single Parquet files:
#' `assessments`, `courses`, `studentAssessment`, `studentInfo`,
#' `studentRegistration`, `vle`.
#' The large `studentVle` is shipped as a partitioned Parquet dataset
#' (partitioned by `code_module` and `code_presentation`) for efficient reads.
#'
#' Use `open_studentVle()` to query lazily and `load_studentVle()` to collect
#' targeted slices into memory.
#'
#' @name ouladr-tables
#' @docType data
#' @keywords datasets
#' @seealso list_pkg_tables, open_studentVle, load_studentVle
NULL
