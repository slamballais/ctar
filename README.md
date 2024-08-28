
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->

[![R-CMD-check](https://github.com/slamballais/ctar/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/slamballais/ctar/actions/workflows/R-CMD-check.yaml)
[![CRAN
status](https://www.r-pkg.org/badges/version/ctar)](https://CRAN.R-project.org/package=ctar)
[![License: GPL
v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![codecov](https://codecov.io/gh/slamballais/ctar/graph/badge.svg?token=IUVYSTN6SX)](https://codecov.io/gh/slamballais/ctar)
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

## Acknowledgements

- The PLACO method was [published by Debashree Ray and Nilanjan
  Chatterjee in 2020](https://doi.org/10.1371/journal.pgen.1009218). The
  code for our PLACO implementation is heavily based on the [PLACO R
  function](https://github.com/RayDebashree/PLACO).
- The CPMA method was [published by Chris Cotsapas and colleagues in
  2011](https://doi.org/10.1371/journal.pgen.1002254). The code for our
  CPMA implementation is loosely based on the original code from Chris.
