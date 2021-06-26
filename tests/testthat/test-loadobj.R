context("loadobj")

test_that("can load an obj file", {
  expect_error(read.obj(c("foo","bar")), "single")
  expect_error(read.obj("rhubarb"), "Cannot open file")
  expect_warning(read.obj(system.file("obj/cube_badmtl.wavefront", package = "readobj")),
                 'default material')

  expect_is(cube<-read.obj(system.file("obj/cube.wavefront", package = "readobj")),
            "list")
  # saveRDS(cube, file='testdata/cube.rds', version = 2)
  cube_baseline=readRDS("testdata/cube.rds")
  expect_equal(cube, cube_baseline)

  expect_is(tile<-read.obj(system.file("obj/tile.wavefront", package = "readobj")),
            "list")
  # saveRDS(tile, file='testdata/tile.rds', version = 2)
  tile_baseline=readRDS("testdata/tile.rds")
  expect_equal(tile, tile_baseline)
})

test_that("can load file with mix of quads and triangles", {
  expect_is(mixed<-read.obj(system.file("obj/mixed.wavefront", package = "readobj"), triangulate = FALSE),
            "list")
  expect_named(mixed$shapes[[1]], c("positions", "indices", "nvfaces"))
  expect_equal(as.integer(mixed$shapes[[1]]$nvfaces), rep(4:3,c(6,4)))
})

test_that("can convert to rgl format", {
  if(require('rgl', quietly = TRUE)){
    cube=readRDS("testdata/cube.rds")
    expect_is(cubesl <- tinyobj2shapelist3d(cube), 'shapelist3d')
    # saveRDS(cubesl, file='testdata/cubesl.rds', version = 2)
    cubesl_baseline=readRDS("testdata/cubesl.rds")
    # rgl dropped the "primitivetype" component in version 0.100.x
    # Ignore it in the tests so we work with both old and new rgl
    for (side in c("front", "back", "right", "left", "top", "bottom")) {
      cubesl[[side]]$primitivetype <-
        cubesl_baseline[[side]]$primitivetype <- NULL
    }
    expect_equal(cubesl, cubesl_baseline)

    tile=readRDS("testdata/tile.rds")
    expect_is(tilesl <- tinyobj2shapelist3d(tile), 'shapelist3d')
    # texture=system.file("obj/tile.png", package="readobj")
    # shade3d(tilesl, material=list(texture=texture, color="white"))
    # saveRDS(tilesl, file='testdata/tilesl.rds', version = 2)
    tilesl_baseline=readRDS("testdata/tilesl.rds")
    for (side in c("front", "back", "right", "left", "top", "bottom")) {
      tilesl[[side]]$primitivetype <-
        tilesl_baseline[[side]]$primitivetype <- NULL
    }
    expect_equal(tilesl, tilesl_baseline)
  }
})


test_that("can load more complex obj files", {
  expect_is(tile<-read.obj(system.file("obj/tile.wavefront", package = "readobj"), triangulate = FALSE, convert.rgl = TRUE),
            "shapelist3d")

    expect_is(pawn <-
              read.obj(system.file("obj/pawn.wavefront", package = "readobj")),
            "list")
  # try without triangulating
  expect_error(read.obj(system.file("obj/pawn.wavefront", package = "readobj"), triangulate = FALSE))

})
