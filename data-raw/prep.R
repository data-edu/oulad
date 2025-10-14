csv_dir <- "data-raw"     # folder holding the 7 CSVs
out_dir <- "inst/extdata"
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

library(tibble)
library(readr)
library(arrow)

# Helper: robust read (OULAD-style headers, UTF-8)
read_csv_quiet <- function(path) readr::read_csv(path, progress = FALSE, show_col_types = FALSE)

# --- small tables -> single Parquet files ---
small <- list(
    assessments         = file.path(csv_dir, "assessments.csv"),
    courses             = file.path(csv_dir, "courses.csv"),
    studentAssessment   = file.path(csv_dir, "studentAssessment.csv"),
    studentInfo         = file.path(csv_dir, "studentInfo.csv"),
    studentRegistration = file.path(csv_dir, "studentRegistration.csv"),
    vle                 = file.path(csv_dir, "vle.csv")
)

for (nm in names(small)) {
    df <- read_csv_quiet(small[[nm]])
    write_parquet(df, file.path(out_dir, paste0(nm, ".parquet")), compression = "zstd")
}

# --- big table -> partitioned dataset ---
# Typical OULAD columns in studentVle: code_module, code_presentation, id_student, id_site, date, sum_click
# Partitioning by module & presentation gives small, targeted reads.
vle_big_csv <- file.path(csv_dir, "studentVle.csv")

vle_df <- read_csv_quiet(vle_big_csv)

# Make sure partition keys exist (rename to canonical if needed)
# If your columns already match, these no-ops won’t hurt:
# if ("codeModule" %in% names(vle_df)) names(vle_df)[names(vle_df)=="codeModule"] <- "code_module"
# if ("codePresentation" %in% names(vle_df)) names(vle_df)[names(vle_df)=="codePresentation"] <- "code_presentation"

vle_ds_dir <- file.path(out_dir, "studentVle_ds")
unlink(vle_ds_dir, recursive = TRUE, force = TRUE)
dir.create(vle_ds_dir, recursive = TRUE, showWarnings = FALSE)

write_dataset(
    vle_df,
    path         = vle_ds_dir,
    format       = "parquet",
    partitioning = c("code_module", "code_presentation"),
    compression  = "zstd"
)

# Optional: manifest
readr::write_csv(
    tibble::tibble(
        table = c(names(small), "studentVle_ds"),
        path  = c(paste0(names(small), ".parquet"), "studentVle_ds/")
    ),
    file.path(out_dir, "_manifest.csv")
)

message("extdata written.")
