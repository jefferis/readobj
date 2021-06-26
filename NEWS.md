# readobj 0.4

This version makes significant changes under the hood by updating
`tinyobjloader` to enable triangulation of more complex shapes together with
support for rendering textures on such shapes. @trevorld has been added as a
package author due to his significant effort in making those changes.

These internal changes will be reflected in the details of the mesh structures
returned for more complex objects (although they should render equivalently, or better in the case of textures).

* upgrade the embedded version of `tinyobjloader` to v1.0.7
  to support the triangulation of previously unsupported shapes (#6)
* preserve texture coordinates in `tinyshape2mesh3d()` (thanks to @trevorld, #7)

# readobj 0.3.2

* fixes a test error introduced by a change in object structure for latest
  version of rgl (thanks to Duncan Murdoch for the fix, #3)

# readobj 0.3.1

* Rename .obj sample files to .wavefront at request of CRAN maintainers to avoid
  false positive object file R CMD check NOTE.

# readobj 0.3

* fix bug in .Call since Rcpp update
* documentation improvements
* URL fixes preparing for CRAN

# readobj 0.2

* fix bug in reading of normals (#1)
* expand paths before reading (#2)
