
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->
<!-- badges: end -->

## Overview

ctar offers standardized versions of cross-trait association methods.

## Installation

<div class="pkgdown-devel">

``` r
# Install development version from GitHub
pak::pak("slamballais/ctar")
```

</div>

## Usage

``` r
library(ctar)

p <- replicate(2, runif(100000), simplify = FALSE)
out <- sumrank(p)
```
