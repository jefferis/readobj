# readobj
## Quick Start

For the impatient ...

```r
# install
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
Currently there isn't a released version on [CRAN](http://cran.r-project.org/).

### Development version
You can use the **devtools** package to install the development version:

```r
if (!require("devtools")) install.packages("devtools")
devtools::install_github("jefferis/readobj")
```

Note: MacOS X users will need a development environment (Xcode) to compile code.
Windows users need [Rtools](http://www.murdoch-sutherland.com/Rtools/) and
[devtools](http://CRAN.R-project.org/package=devtools) to install this way.
