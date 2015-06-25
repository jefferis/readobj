context("loadobj")

test_that("can load an obj file", {
  expect_error(read.obj(c("foo","bar")), "single")
  expect_error(read.obj("rhubarb"), "Error")
  expect_warning(read.obj(system.file("obj/cube_badmtl.obj", package = "readobj")),
                 'default material')

  expect_is(cube<-read.obj(system.file("obj/cube.obj", package = "readobj")),
            "list")
  # saveRDS(cube, file='tests/testthat/testdata/cube.rds')
  cube_baseline=readRDS("testdata/cube.rds")
  expect_equal(cube, cube_baseline)
})
