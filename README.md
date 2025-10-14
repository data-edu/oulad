
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ouladr

Data loaders for the **Open University Learning Analytics Dataset
(OULAD)**, packaged for convenient use in R.

This package provides a reproducible structure for working with the
seven core OULAD tables in efficient Parquet format, along with helper
functions for loading and filtering them.

## Installation

``` r
# Install from GitHub
# (requires remotes or devtools)
remotes::install_github("data-edu/ouladr")

# Load the package
library(ouladr)
```

## Data Overview

This package mirrors the original OULAD tables:

| Function                        | Description                                                   |
|---------------------------------|---------------------------------------------------------------|
| `ouladr::assessments()`         | Assessment structure and key dates                            |
| `ouladr::courses()`             | Module and presentation metadata                              |
| `ouladr::studentAssessment()`   | Student submissions and assessment results                    |
| `ouladr::studentInfo()`         | Demographics, age band, region, etc.                          |
| `ouladr::studentRegistration()` | Student module registration records                           |
| `ouladr::vle()`                 | Virtual Learning Environment (VLE) materials and release info |
| `ouladr::studentVle()`          | **Large** log of student interactions with VLE materials      |

## How to Load the Data

``` r
library(ouladr)

assessments <- ouladr::assessments()
courses <- ouladr::courses()
student_assess <- ouladr::studentAssessment()
student_info <- ouladr::studentInfo()
student_reg <- ouladr::studentRegistration()
vle <- ouladr::vle()
student_vle <- ouladr::studentVle()
```

## How to Join the Data

``` r
library(ouladr) 
library(dplyr)

students <- student_info %>% 
    left_join(courses) %>% 
    left_join(student_reg)

assessments <- student_assess %>% 
    left_join(assessments)

interactions <- student_vle %>%
    left_join(vle) %>%
    left_join(courses)
```

## Developers

The raw OULAD CSV files are **not distributed** with this package
because of their size.  
To rebuild the Parquet files locally, first download the dataset from
the official OULAD site:

> **Download source:**  
> <https://analyse.kmi.open.ac.uk/open-dataset>

Then, place the CSVs under `data-raw/csv/` and run:

``` r
source("data-raw/make-extdata.R")
```

This script will convert the CSVs into compressed Parquet files under
`inst/extdata/` for fast access in R.  
These files are ignored by version control (see `.Rbuildignore`).

## Authors

- **Joshua M. Rosenberg** – University of Tennessee, Knoxville  
- **Kelly L. Boles** – University of Tennessee, Knoxville

## License & Citation

Data © The Open University, used under the terms of the [OULAD
license](https://analyse.kmi.open.ac.uk/open-dataset).

If you use this package or the data in research or teaching, please
cite:

> Kuzilek, J., Hlosta, M., & Zdrahal, Z. (2017).  
> *Open University Learning Analytics Dataset (OULAD).*  
> *Scientific Data*, 4, 170171.  
> <https://doi.org/10.1038/sdata.2017.171>

and

> Rosenberg, J. M., & Boles, K.L. (2025).  
> *ouladr: Load and use the Open University Learning Analytics Dataset
> (OULAD).*  
> GitHub repository: <https://github.com/yourusername/ouladr>
