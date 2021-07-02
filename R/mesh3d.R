#' Convert the raw tinyobjloader shapes/materials list into an rgl shapelist3d
#'
#' @param x A raw tinyobjloader shapes/materials list
#' @return a list of class \code{shapelist3d} containing a \code{mesh3d} for
#'   each object or group element in the original OBJ file.
#' @export
#' @details Not all materials settings can be processed at the moment. In
#'   particular only the following are used: \itemize{
#'
#'   \item \code{diffuse} -> mapped onto rgl material \code{color} field
#'
#'   \item \code{ambient}
#'
#'   \item \code{specular}
#'
#'   \item \code{emission}
#'
#'   }
#'
#' @seealso \code{\link{read.obj}}, \code{\link[rgl]{mesh3d}},
#'   \code{\link[rgl]{shapelist3d}}, \code{\link[rgl]{rgl.material}}
#' @examples
#' cube=read.obj(system.file("obj/cube.wavefront", package = "readobj"))
#' if(require("rgl")){
#'   cubesl=tinyobj2shapelist3d(cube)
#'   shade3d(cubesl)
#' }
tinyobj2shapelist3d<-function(x) {
  if(!requireNamespace('rgl'))
    stop('Please install.packages("rgl") to use this function!')

  mats=lapply(x$materials, tinymaterial2rgl)

  sl=lapply(x$shapes, tinyshape2mesh3d)
  # 1-indexed into material array
  materialids=sapply(x$shapes, function(y) {
    um=unique(y$material_ids)+1L
    if(length(um)==0) um=-1L
    um
    })
  # do we have any materials specified?
  if(!is.integer(materialids)) {
    warning("Some object groups have more than one material id! Keeping first only!")
    materialids=sapply(materialids, head, 1)
  }
  for(i in which(materialids>0)) {
    sl[[i]]$material=mats[[materialids[i]]]
  }
  class(sl) <- c("shapelist3d", "shape3d")
  sl
}

#' @importFrom grDevices rgb
myrgb=function(x) {
  if(any(x>1)) {
    warning("bad rgb value!")
    return("black")
  }
  rgb(x[1],x[2],x[3])
}

# process a tinyobj material specification into an rgl compatible material list
tinymaterial2rgl<-function(x){
  cols=c("diffuse","ambient", "specular", "emission")
  y=lapply(x[cols], myrgb)
  names(y)[1]='color'
  y$shininess=x$shininess
  y
}

# convert individual tiny shape into an rgl mesh3d object
tinyshape2mesh3d<-function(x) {
  # standardize OBJ data
  vertices=x$positions
  indices=x$indices+1L
  if(length(x$normals)) {
      normals=x$normals
      normindices=ifelse(x$normindices == -1L, NA_integer_, x$normindices+1L)
  } else {
      normals=NULL
      normindices=NULL
  }
  if(length(x$texcoords)) {
      texcoords=x$texcoords
      texindices=ifelse(x$texindices == -1L, NA_integer_, x$texindices+1L)
  } else {
      texcoords=NULL
      texindices=NULL
  }
  # if necessary duplicate vertices, normals, tex coordinates
  if(!is.null(normals) && !is.null(texcoords)) {
      if (!identical(indices, normindices) || !identical(indices, texindices)) {
          # for each mesh vertex in (norm)indices find associated position, normal, and tex coordinate
          dft=expand.grid(r=seq_len(nrow(indices)), c=seq_len(ncol(indices)))
          dft$position=c(indices)
          dft$normal=c(normindices)
          dft$texcoord=c(texindices)
          # find our new duplicated vertices/normal/tex coords indices
          dfi=unique(dft[, 3:5])
          dfi$id=seq_len(nrow(dfi))
          dft=merge(dft, dfi, sort=FALSE)
          dft=dft[order(dft$c, dft$r),]
          # update vectices, normals, and indices with new duplicated indices
          vertices=vertices[, dfi[, 1L]]
          normals=normals[, dfi[, 2L]]
          texcoords=texcoords[, dfi[, 3L]]
          indices[,]=dft$id
      }
  } else if(is.null(normals) && !is.null(texcoords)) {
      if(!identical(indices, texindices)) {
          # for each mesh vertex in (tex)indices find associated position and tex coordinate
          dft=expand.grid(r=seq_len(nrow(indices)), c=seq_len(ncol(indices)))
          dft$position=c(indices)
          dft$texcoord=c(texindices)
          # find our new duplicated vertices/texcoords indices
          dfi=unique(dft[, 3:4])
          dfi$id=seq_len(nrow(dfi))
          dft=merge(dft, dfi, sort=FALSE)
          dft=dft[order(dft$c, dft$r),]
          # update vectices, texcoords, and indices with new duplicated indices
          vertices=vertices[, dfi[, 1L]]
          texcoords=texcoords[, dfi[, 2L]]
          indices[,]=dft$id
      }
  } else if(is.null(texcoords) && !is.null(normals)) {
      if(!identical(indices, normindices)) {
          # for each mesh vertex in (norm)indices find associated position and normal
          dft=expand.grid(r=seq_len(nrow(indices)), c=seq_len(ncol(indices)))
          dft$position=c(indices)
          dft$normal=c(normindices)
          # find our new duplicated vertices/normal indices
          dfi=unique(dft[, 3:4])
          dfi$id=seq_len(nrow(dfi))
          dft=merge(dft, dfi, sort=FALSE)
          dft=dft[order(dft$c, dft$r),]
          # update vectices, normals, and indices with new duplicated indices
          vertices=vertices[, dfi[, 1L]]
          normals=normals[, dfi[, 2L]]
          indices[,]=dft$id
      }
  }
  # rgl::tmesh3d expects the transpose of texcoords and normals (but not vertices)
  if (!is.null(normals)) normals=t(normals)
  if (!is.null(texcoords)) texcoords=t(texcoords)
  m=rgl::tmesh3d(vertices, indices, homogeneous = FALSE,
                 normals = normals, texcoords = texcoords)
  # nb normals are expected to be 4 component in some places
  if(length(m$normals) && nrow(m$normals)==3L)
    m$normals=rbind(m$normals, 1)
  m
}
