context("loadobj")

test_that("can load an obj file", {
  expect_error(read.obj(c("foo","bar")), "single")
  expect_error(read.obj("rhubarb"), "Cannot open file")
  expect_warning(read.obj(system.file("obj/cube_badmtl.wavefront", package = "readobj")),
                 'default material')

  expect_is(cube<-read.obj(system.file("obj/cube.wavefront", package = "readobj")),
            "list")
  # saveRDS(cube, file='tests/testthat/testdata/cube.rds')
  cube_baseline=readRDS("testdata/cube.rds")
  expect_equal(cube, cube_baseline)

  expect_is(tile<-read.obj(system.file("obj/tile.wavefront", package = "readobj")),
            "list")
  # saveRDS(tile, file='testdata/tile.rds')
  tile_baseline=readRDS("testdata/tile.rds")
  expect_equal(tile, tile_baseline)
})

removeNULLs <- function(x) {
  for (i in seq_along(x))
    for (n in names(x[[i]]))
      if (is.null(x[[i]][[n]]))
        x[[i]][[n]] <- NULL
  x
}

test_that("can convert to rgl format", {
  if(require('rgl', quietly = TRUE)){
    cube=readRDS("testdata/cube.rds")
    cubesl_baseline=readRDS("testdata/cubesl.rds")
    cubesl_baseline <- removeNULLs(cubesl_baseline)
    expect_is(cubesl <- tinyobj2shapelist3d(cube), 'shapelist3d')
    cubesl <- removeNULLs(cubesl)
    # rgl dropped the "primitivetype" component in version 0.100.x
    # Ignore it in the tests so we work with both old and new rgl
    # In the upcoming release of rgl mesh objects contain more
    # components (points, line segments are the main changes).
    # Remove these if NULL.
    for (side in c("front", "back", "right", "left", "top", "bottom")) {
      cubesl[[side]]$primitivetype <-
        cubesl_baseline[[side]]$primitivetype <- NULL
    }
    expect_equal(cubesl, cubesl_baseline)

    tile=readRDS("testdata/tile.rds")
    expect_is(tilesl <- tinyobj2shapelist3d(tile), 'shapelist3d')
    tilesl <- removeNULLs(tilesl)
    # texture=system.file("obj/tile.png", package="readobj")
    # shade3d(tilesl, material=list(texture=texture, color="white"))
    # saveRDS(tilesl, file='testdata/tilesl.rds')
    tilesl_baseline=readRDS("testdata/tilesl.rds")
    tilesl_baseline <- removeNULLs(tilesl_baseline)
    for (s in seq_along(tilesl)) {
      tilesl[[s]]$primitivetype <-
        tilesl_baseline[[s]]$primitivetype <- NULL
    }
    expect_equal(tilesl, tilesl_baseline)
  }
})
