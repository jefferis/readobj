#' Read a Wavefront OBJ 3D scene file into an R list
#'
#' @param f Path to an OBJ file
#' @param materialspath Path to a folder containing materials files. This is
#'   optional and only required if materials files are in a different folder
#'   from the OBJ file defined by \code{f}.
#' @param convert.rgl Whether to convert the returned list to a
#'   \code{rgl::\link[rgl]{shapelist3d}} object containing
#'   \code{rgl::\link[rgl]{mesh3d}} objects.
#' @param triangulate (default \code{TRUE}) Whether to convert all mesh faces to
#'   triangles. Note that only meshes with triangular or quad faces are
#'   supported, so setting \code{triangulate=FALSE} will throw an error for more
#'   complex files.
#' @section Sample files: Note that at the request of the CRAN maintainers the
#'   sample files have the file extension \code{.wavefront} instead of the
#'   standard \code{.obj} because this triggers a false positive R CMD check
#'   NOTE.
#' @details \code{tinyobjloader} made some substantial changes to its data
#'   structures after the first code snapshot was taken for the this package in
#'   2015. In order to benefit from bug fixes, we updated the code in 2020 but
#'   we note that \code{tinyobjloader} now de-duplicates vertices more
#'   aggressively e.g. in the situation where there are normals or texture coordinates.
#'   We were forced when converting to \code{rgl::\link[rgl]{shapelist3d}} objects
#'   to revert these de-duplications on the R side
#'   in order for display in rgl; note that this only happens
#'   when there are texture coordinates and/or normals in the obj file.
#'
#'   Note that some fields in the \code{tinyobjloader} return structure will be
#'   omitted when they are not relevant for a given obj file. In this case, as
#'   with any R list, the list element will have the value \code{NULL} when
#'   tested. See examples.
#' @return When \code{convert.rgl=FALSE}, the default, a named list with items
#'   \code{shapes} and \code{materials}, each containing sublists with one entry
#'   per object (shapes) or material (materials). Objects in the \code{shapes}
#'   list have the following structure \itemize{
#'
#'   \item \code{positions} 3 x N matrix of 3D vertices
#'
#'   \item \code{indices} 3/4 x M matrix of indices into vertex array
#'   (trimesh/quadmesh) 0-indexed
#'
#'   \item \code{normals} 3 x N matrix of normal directions for each vertex
#'   (missing when there are no normals)
#'
#'   \item \code{normindices} 3/4 x M matrix of indices into normals array
#'   (trimesh/quadmesh) 0-indexed (missing when there are no normals)
#'
#'   \item \code{texcoords} 2 x N matrix of texture coordinates (missing when
#'   there are no texture coordinates)
#'
#'   \item \code{texindices} 3/4 x M matrix of indices into \code{texcoords}
#'   array (trimesh/quadmesh) 0-indexed (missing when there are no texture
#'   coordinates)
#'
#'   \item \code{nvfaces} Raw vector specifying the number of vertices per face
#'   (missing unless \code{triangulate=FALSE} and there are a mixture of
#'   different numbers of vertices per face.)
#'
#'   \item \code{material_ids} 0-indexed, -1 when not set (missing when no
#'   materials)
#'
#'   }
#'
#'   When \code{convert.rgl=TRUE} a list of class \code{\link[rgl]{shapelist3d}}
#'   containing a \code{\link[rgl]{mesh3d}} for each object or group element in
#'   the original OBJ file. See \code{\link{tinyobj2shapelist3d}} for details of
#'   rgl conversion.
#' @export
#' @seealso \code{\link{tinyobj2shapelist3d}}, \code{rgl::\link[rgl]{readOBJ}}
#'   for simpler, pure R implementation.
#' @examples
#' cube=read.obj(system.file("obj/cube.wavefront", package = "readobj"))
#' str(cube)
#' # elements will be NULL when not present in the obj file e.g. normals
#' is.null(cube$shapes[[1]]$texcoords)
#'
#' # demonstrate direct conversion of result to rgl format
#' if(require('rgl')) {
#'   cuber=read.obj(system.file("obj/cube.wavefront", package = "readobj"),
#'     convert.rgl=TRUE)
#'   shade3d(cuber)
#' }
read.obj <- function(f, materialspath=NULL, convert.rgl=FALSE, triangulate=TRUE) {
  if(length(f)!=1)
    stop("Please pass exactly one file to `read.obj`!")
  # expand any ~ etc
  f=path.expand(f)
  # set default materialspath
  if(is.null(materialspath)) {
    materialspath=dirname(f)
  }
  # ensure there is a trailing fsep
  lastchar=substr(materialspath, nchar(materialspath), nchar(materialspath))
  fsep=.Platform$file.sep
  if(lastchar!=fsep)
  materialspath=paste0(materialspath,fsep)
  rval=loadobj(f, materialspath, triangulate=triangulate)
  if(convert.rgl) tinyobj2shapelist3d(rval) else rval
}
