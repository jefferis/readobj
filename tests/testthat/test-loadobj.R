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
  }
})
