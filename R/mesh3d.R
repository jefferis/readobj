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
#' cube=read.obj(system.file("obj/cube.obj", package = "readobj"))
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
  materialids=sapply(x$shapes, function(y) unique(y$material_ids))+1L
  if(!is.integer(materialids)) {
    stop("Some object groups have more than one material id!")
    warning("Keeping first only!")
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
  # nb normals are expected to be 4 component in some places
  m=rgl::tmesh3d(x$positions, x$indices+1, homogeneous = F,
               normals = if(length(x$normals)) t(x$normals) else NULL)
  if(length(m$normals) && nrow(m$normals)==3)
    m$normals=rbind(m$normals, 1)
  m
}
