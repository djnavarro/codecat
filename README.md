
<!-- README.md is generated from README.Rmd. Please edit that file -->

# codecat

<!-- badges: start -->
<!-- badges: end -->

The goal of codecat is to provide a minimal toolkit for defining and
using codebooks (also called data dictionaries) which specify factor
levels and labels for one or more (usually categorical) variables in a
data set.

## Installation

You can install the development version of codecat like so:

``` r
remotes::install_github("djnavarro/codecat")
```

## Example

``` r
library(codecat)
library(tibble)
```

To specify the labelling scheme for a variable, use the `code()`
function:

``` r
code("SEX", levels = c(0, 1), labels = c("Male", "Female"))
#> # A tibble: 2 × 3
#>   variable level label 
#>   <chr>    <dbl> <chr> 
#> 1 SEX          0 Male  
#> 2 SEX          1 Female
```

Build a codebook for multiple variables:

``` r
codebook(
  code("SEX", levels = c(0, 1), labels = c("Male", "Female")),
  code("STUDY", levels = c(1, 2, 3), labels = c("S1", "S2", "S3"))
)
#> $SEX
#> # A tibble: 2 × 3
#>   variable level label 
#>   <chr>    <dbl> <chr> 
#> 1 SEX          0 Male  
#> 2 SEX          1 Female
#> 
#> $STUDY
#> # A tibble: 3 × 3
#>   variable level label
#>   <chr>    <dbl> <chr>
#> 1 STUDY        1 S1   
#> 2 STUDY        2 S2   
#> 3 STUDY        3 S3
```

Apply it to data:

``` r
dat <- tibble(
  STUDY = c(1, 1, 1, 2, 2, 2),
  SEX   = c(0, 0, 1, 1, 1, 0),
  AGE   = c(32, 18, 64, 52, 26, 80)
)

labels <- codebook(
  code("SEX", levels = c(0, 1), labels = c("Male", "Female")),
  code("STUDY", levels = c(1, 2, 3), labels = c("S1", "S2", "S3"))
)

encode(dat, labels)
#> # A tibble: 6 × 3
#>   STUDY SEX      AGE
#>   <fct> <fct>  <dbl>
#> 1 S1    Male      32
#> 2 S1    Male      18
#> 3 S1    Female    64
#> 4 S2    Female    52
#> 5 S2    Female    26
#> 6 S2    Male      80
```
