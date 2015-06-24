#' Load a Wavefront OBJ 3D scene file
#'
#' @param f The path to a file
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
#' cube=loadobj(system.file('obj/cube.obj'))
#' str(cube, max.level = 2)
loadobj <- function(f) {
  .Call('tinyobjloader_loadobj', PACKAGE = 'tinyobjloader', f, dirname(f))
}
