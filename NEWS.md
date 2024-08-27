# ctar 0.2.2 (2024-08-27)

### Bug fixes
* [8f7a2cd](https://github.com/slamballais/ctar/commit/8f7a2cd301f5b81ef1c8bdd24edb5572a467ce07): Removed unnecessary values in `Imports` field.
* [0c21c9b](https://github.com/slamballais/ctar/commit/0c21c9b682b75c496a560930a5551e22dd6312ca): Make sure that `R CMD CHECK` is passed successfully.

### Minor tweaks
* [23d7741](https://github.com/slamballais/ctar/commit/23d774154d7ccae381ba2208e10edcf76ac9081c): Add `R CMD CHECK` badge for GitHub.
* [098a69f](https://github.com/slamballais/ctar/commit/098a69f39bf7cbb02bdb410a1672e8356cddd089): Updated looks of `NEWS.md`. 
* [#24](https://github.com/slamballais/ctar/pull/24): Added `codecov` checks.
* [](): Added a GitHub Actions for PR commands.

# ctar 0.2.1 (2024-08-27)

### Minor tweaks
* [#10](https://github.com/slamballais/ctar/pull/10): Added internal functions and checks for the input arguments.
* [#11](https://github.com/slamballais/ctar/pull/11): Added `p_exp` (-log10 p-values) to the output of `cpma` and `fct`.
* [#12](https://github.com/slamballais/ctar/pull/12): Added tests against the non-subset `sumrank`, `cpma`, and `fct`.
* [b9c3e56](https://github.com/slamballais/ctar/commit/b9c3e56775919bafd1c7a8ccf677e5fe011fd204): Added tests to see if p-values are equal to `0`.
* [#16](https://github.com/slamballais/ctar/pull/16): Modified `z_in` to `z`, and `p_in` to `p`. Added checks for `z`.

# ctar 0.2.0 (2024-08-26)

Version `0.2.0` extends beyond `sumrank` and adds a number of necessary features.

### New features
* [#1](https://github.com/slamballais/ctar/pull/1): Implemented initial testing framework.
* [a5d2280](https://github.com/slamballais/ctar/commit/a5d228051d27e69f2a45d244c100423392860de6): Implemented PLACO ("pleiotropic analysis under composite null hypothesis") as `placo`.
* [#6](https://github.com/slamballais/ctar/pull/6): Implemented CPMA ("cross-phenotype meta-analysis") as `cpma`.
* [#8](https://github.com/slamballais/ctar/pull/8): Implemented FCT ("Fisher's combined probability test") as `fct`.

# ctar 0.1.0 (2024-08-26)

This is the very first version of `ctar`: cross-trait associations in `R`. This version purely contains the necessary files to have an `R` package, as well as an uncleaned version of `sumrank`. I will add in more features soon!
