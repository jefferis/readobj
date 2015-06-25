#' Read a Wavefront OBJ 3D scene file into an R list
#'
#' @param f Path to an OBJ file
#' @param materialspath Path to a folder containing materials files. This is
#'   optional and only required if materials files are in a different folder
#'   from the OBJ file defined by \code{f}.
#'
#' @return a named list with items \code{shapes} and \code{materials}, each
#'   containing sublists with one entry per object (shapes) or material
#'   (materials). Objects in the \code{shapes} list have the following structure
#'   \itemize{
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
#' @export
#'
#' @examples
#' cube=read.obj(system.file("obj/cube.obj", package = "readobj"))
#' str(cube, max.level = 3)
read.obj <- function(f, materialspath=NULL) {
  if(length(f)>1)
    stop("I only know how to read single files!")
  # check that materialspath has a trailing fsep
  if(is.null(materialspath)) {
    materialspath=dirname(f)
  }
  # ensure there is a trailing fsep
  materialspath=file.path(materialspath,"")

  .Call('readobj_loadobj', PACKAGE = 'readobj', f, materialspath)
}
