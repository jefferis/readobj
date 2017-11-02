## Test environments
* local OS X install, R 3.4.2
* ubuntu 12.04 (on travis-ci), R 3.4.2
* win-builder (devel)

https://win-builder.r-project.org/qbuDaPpBjVzI/00check.log

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.
* Note that I have inherited the BSD 2 clause license from the original author
  of the C++ library that this package wraps.
* On my local r-release but *not* on winbuilder r-devel I get the following 
  NOTE:

Found the following apparent object files/libraries:
  inst/obj/cube.obj inst/obj/cube_badmtl.obj

This is not a compiled object file but in fact a 'Wavefront' OBJ 3D scene file.

## Reverse dependencies

This is a new release, so there are no reverse dependencies.
