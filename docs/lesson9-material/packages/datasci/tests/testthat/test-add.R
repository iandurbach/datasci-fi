context("numeric addition is correct")

test_that("1 + 1 equals 2", {
  expect_equal(add(1, 1), 2)
})

test_that("1 + -1 equals 0", {
  expect_equal(add(1, -1), 0)
})

context("non-numeric input results in an error")

test_that("string input results in an error", {
  expect_error(add("1", 1))
})
