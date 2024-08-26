# ctar 0.2.1

## Minor tweaks
* [#10](https://github.com/slamballais/ctar/pull/10): Added internal functions and checks for the input arguments.
* [#11](https://github.com/slamballais/ctar/pull/11): Added `p_exp` (-log10 p-values) to the output of `cpma` and `fct`.
* [#12](https://github.com/slamballais/ctar/pull/12): Added tests against the non-subset `sumrank`, `cpma`, and `fct`.
* [b9c3e56](https://github.com/slamballais/ctar/commit/b9c3e56775919bafd1c7a8ccf677e5fe011fd204): Added tests to see if p-values are equal to 0.

# ctar 0.2.0 
Version 0.2.0 extends beyond SumRank and adds a number of necessary features.

## New features
* [#1](https://github.com/slamballais/ctar/pull/1): Implemented initial testing framework.
* [a5d2280](https://github.com/slamballais/ctar/commit/a5d228051d27e69f2a45d244c100423392860de6): Implemented PLACO ("pleiotropic analysis under composite null hypothesis").
* [#6](https://github.com/slamballais/ctar/pull/6): Implemented CPMA ("cross-phenotype meta-analysis").
* [#8](https://github.com/slamballais/ctar/pull/8): Implemented FCT ("Fisher's combined probability test").

# ctar 0.1.0
This is the very first version of `ctar`: cross-trait associations in R. This version purely contains the necessary files to have an R package, as well as an uncleaned version of SumRank. I will add in more features soon!
