# readobj
[![Travis-CI Build Status](https://travis-ci.org/jefferis/readobj.svg?branch=master)](https://travis-ci.org/jefferis/readobj)
## Quick Start

For the impatient ...

```r
# install development version
if (!require("devtools")) install.packages("devtools")
devtools::install_github("jefferis/readobj")

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
A released version is currently in submission to [CRAN](https://cran.r-project.org/).
Until this is available you should install the development version as described
below.

### Development version
You can use the [devtools](https://cran.r-project.org/package=devtools) package
to install the development version:

```r
if (!require("devtools")) install.packages("devtools")
devtools::install_github("jefferis/readobj")
```

Note: MacOS X users will need a development environment 
([Xcode](https://developer.apple.com/xcode/downloads/)) to compile code.
Windows users need [Rtools](http://www.murdoch-sutherland.com/Rtools/) to install this way.

## Acknwoledgements
This package wraps the tinyobjloader C++ library available at 
https://github.com/syoyo/tinyobjloader. Kudos to its author, Syoyo Fujita!

tinyobjloader is released under a liberal 2 clause BSD license, which this
package therefore inherits.
