#' Wrapper for tiny_obj_loader single file C++ library
#'
#' This package provides fast reading of Wavefront OBJ files with support for
#' some material properties using the
#' \href{https://github.com/syoyo/tinyobjloader}{tinyobjloader} C++ library. It
#' is noticeably faster than the pure R \code{\link[rgl]{readOBJ}} implemented
#' in the \code{rgl} package.
#'
#' Note that the rgl package does provide a \code{\link[rgl]{writeOBJ}}
#' function, whereas this library only focusses on fast reading of OBJ files.
#'
#' @name readobj-package
#' @aliases readobj
#' @useDynLib readobj
#' @import Rcpp
#' @seealso \code{\link{read.obj}}, \code{\link[rgl]{readOBJ}}
NULL
