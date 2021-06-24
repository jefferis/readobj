# readobj
<!-- badges: start -->
[![Travis-CI Build Status](https://travis-ci.org/jefferis/readobj.svg?branch=master)](https://travis-ci.org/jefferis/readobj)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/readobj)](https://cran.r-project.org/package=readobj)
[![Downloads](http://cranlogs.r-pkg.org/badges/readobj?color=brightgreen)](https://www.r-pkg.org:443/pkg/readobj)
<!-- badges: end -->

## Quick Start

For the impatient ...

```r
# install CRAN version
install.packages("readobj")

# use
library(readobj)

# run examples
example("read.obj")

# get overview help for package
?readobj
# help for functions
?read.obj

# run tests
library(testthat)
test_package("readobj")
```

## Installation
A released version is now available on [CRAN](https://cran.r-project.org/package=readobj).

```r
install.packages("readobj")
```

### Development version
You can use the [remotes](https://cran.r-project.org/package=remotes) package
to install the development version:

```r
if (!require("remotes")) install.packages("remotes")
remotes::install_github("jefferis/readobj")
```

Note: You will need a development environment able to compile code C++ to 
install in this way. MacOS X users will likely need Xcode (see https://cran.r-project.org/). Windows users need [Rtools](http://www.murdoch-sutherland.com/Rtools/) to install this way.

## Acknwoledgements
This package wraps the tinyobjloader C++ library available at 
https://github.com/tinyobjloader/tinyobjloader. Kudos to its author, Syoyo Fujita!

tinyobjloader is released under a liberal 2 clause BSD license, which this
package therefore inherits.
