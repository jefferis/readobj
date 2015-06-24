context("loadobj")

test_that("can load an obj file", {
  expect_error(loadobj(c("foo","bar")), "single value")
  expect_error(loadobj("rhubarb"), "Error")
  expect_is(loadobj(system.file("obj/cube.obj", package = "tinyobjloader")),
            "list")
})
