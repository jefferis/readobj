#' Wrapper for tiny_obj_loader single file C++ library
#'
#' This package provides fast reading of Wavefront OBJ files with support for
#' some material properties using the
#' \href{https://github.com/tinyobjloader/tinyobjloader}{tinyobjloader} C++
#' library. It is noticeably faster than the pure R \code{\link[rgl]{readOBJ}}
#' implemented in the \code{rgl} package.
#'
#' Note that the rgl package does provide a \code{\link[rgl]{writeOBJ}}
#' function, whereas this library only focusses on fast reading of OBJ files.
#'
#' As of readobj v0.4 released in June 2021, tinyobjloader was updated tag
#' v1.0.7; this was after considering and rejecting the 2.0 series where between
#' 2.0 rc3 and rc4 a default diffuse value was added. This update means that the
#' internal structure of more complex meshes has changed.
#'
#' @name readobj-package
#' @aliases readobj
#' @useDynLib readobj
#' @import Rcpp
#' @seealso \code{\link{read.obj}}, \code{\link[rgl]{readOBJ}}
NULL
