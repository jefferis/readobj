context("loadobj")

test_that("can load an obj file", {
  expect_error(read.obj(c("foo","bar")), "single value")
  expect_error(read.obj("rhubarb"), "Error")
  expect_is(read.obj(system.file("obj/cube.obj", package = "tinyobjloader")),
            "list")
})
