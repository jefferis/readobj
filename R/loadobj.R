#' Read a Wavefront OBJ 3D scene file into an R list
#'
#' @param f Path to an OBJ file
#' @param materialspath Path to a folder containing materials files. This is
#'   optional and only required if materials files are in a different folder
#'   from the OBJ file defined by \code{f}.
#' @param convert.rgl Whether to convert the returned list to a
#'   \code{rgl::\link[rgl]{shapelist3d}} object containing
#'   \code{rgl::\link[rgl]{mesh3d}} objects.
#' @section Sample files: Note that at the request of the CRAN maintainers the
#'   sample files have the file extension \code{.wavefront} instead of the
#'   standard \code{.obj} because this triggers a false positive R CMD check
#'   NOTE.
#' @return When \code{convert.rgl=FALSE}, the default, a named list with items
#'   \code{shapes} and \code{materials}, each containing sublists with one entry
#'   per object (shapes) or material (materials). Objects in the \code{shapes}
#'   list have the following structure \itemize{
#'
#'   \item positions 3xN set of 3D vertices
#'
#'   \item normals 3xN set of normal directions for each vertex (has 3 rows and
#'   0 cols when normals are not available)
#'
#'   \item texcoords vector containing unprocessed texture coordinates
#'
#'   \item indices 3/4xM set of indices into vertex array (trimesh/quadmesh)
#'   0-indexed
#'
#'   \item material_ids (0-indexed, -1 when not set) }
#'
#'   When \code{convert.rgl=FALSE} a list of class shapelist3d containing a
#'   mesh3d for each object or group element in the original OBJ file. See
#'   \code{\link{tinyobj2shapelist3d}} for details of rgl conversion.
#' @export
#' @seealso \code{\link{tinyobj2shapelist3d}}, \code{rgl::\link[rgl]{readOBJ}}
#'   for simpler, pure R implementation.
#' @examples
#' cube=read.obj(system.file("obj/cube.wavefront", package = "readobj"))
#' str(cube, max.level = 3)
#'
#' # demonstrate direct convert of result to rgl format
#' if(require('rgl')) {
#'   cuber=read.obj(system.file("obj/cube.wavefront", package = "readobj"),
#'     convert.rgl=TRUE)
#'   shade3d(cuber)
#' }
read.obj <- function(f, materialspath=NULL, convert.rgl=FALSE) {
  if(length(f)>1)
    stop("I only know how to read single files!")
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
  rval=loadobj(f, materialspath)
  if(convert.rgl) tinyobj2shapelist3d(rval) else rval
}
