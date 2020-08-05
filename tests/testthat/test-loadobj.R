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

test_that("can convert to rgl format", {
  if(require('rgl', quietly = TRUE)){
    cube=readRDS("testdata/cube.rds")
    cubesl_baseline=readRDS("testdata/cubesl.rds")
    expect_is(cubesl <- tinyobj2shapelist3d(cube), 'shapelist3d')
    # rgl dropped the "primitivetype" component in version 0.100.x
    # Ignore it in the tests so we work with both old and new rgl
    for (side in c("front", "back", "right", "left", "top", "bottom")) {
      cubesl[[side]]$primitivetype <-
        cubesl_baseline[[side]]$primitivetype <- NULL
    }
    expect_equal(cubesl, cubesl_baseline)

    tile=readRDS("testdata/tile.rds")
    expect_is(tilesl <- tinyobj2shapelist3d(tile), 'shapelist3d')
    # saveRDS(tilesl, file='testdata/tilesl.rds')
    tilesl_baseline=readRDS("testdata/tilesl.rds")
    for (side in c("front", "back", "right", "left", "top", "bottom")) {
      tilesl[[side]]$primitivetype <-
        tilesl_baseline[[side]]$primitivetype <- NULL
    }
    expect_equal(tilesl, tilesl_baseline)
  }
})

test_that("texture rendered correctly", {
  skip_on_cran() # not sure how consistent rgl.snapshot() will be cross-platform
  if(require('rgl', quietly = TRUE) && require('magick', quietly = TRUE)){
      open3d()
      view3d(phi=-45)
      tilesl=readRDS("testdata/tilesl.rds")
      texture=system.file("obj/tile.png", package="readobj")
      shade3d(tilesl, material=list(texture=texture, color="white"))
      # rgl.snapshot("testdata/snapshot.png")
      snapshot <- tempfile(fileext=".png")
      rgl.snapshot(snapshot)
      rgl.close()

      control=image_read("testdata/snapshot.png")
      test=image_read(snapshot)
      diff=image_compare(control, test, "AE")
      expect_true(attr(diff, "distortion") < 0.01)
  }
})
