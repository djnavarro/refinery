
<!-- README.md is generated from README.Rmd. Please edit that file -->

# refinery

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/refinery)](https://CRAN.R-project.org/package=refinery)
[![R-CMD-check](https://github.com/djnavarro/refinery/workflows/R-CMD-check/badge.svg)](https://github.com/djnavarro/refinery/actions)
<!-- badges: end -->

The goal of the refinery package is to provide tools that make it easier
to blog reproducibly using distill. The central idea is to associate
every post with a unique R environment, using the renv package to ensure
that each post is rendered using its associated environment. The
motivation for writing this package is articulated in the blog post
here:

<https://blog.djnavarro.net/on-blogging-reproducibly>

It is, however, **a work in progress**. It is not yet on CRAN, and may
never be, but if you are foolish enough to try out the dev version
despite the near-total lack of documentation, unit tests, or anything
else that you’d expect of a functioning package…

``` r
# install.packages("devtools")
devtools::install_github("djnavarro/refinery")
```

To the extent that documentation exists, you can find it on the package
website:

<https://refinery.djnavarro.net>
