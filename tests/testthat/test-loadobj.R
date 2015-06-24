context("loadobj")

test_that("can load an obj file", {
  expect_error(loadobj(c("foo","bar")), "one file")
  expect_error(loadobj("rhubarb"), "Error")
})
