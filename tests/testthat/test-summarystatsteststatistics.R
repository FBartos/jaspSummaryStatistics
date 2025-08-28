context("SummaryStatsTestStatistics")

# Test z-test
test_that("z-test works correctly", {
  options <- analysisOptions("SummaryStatsTestStatistics")
  options$testType <- "z"
  options$testStatistic <- 1.96
  options$alternative <- "twoSided"
  results <- runAnalysis("SummaryStatsTestStatistics", NULL, options)
  
  table <- results[["results"]][["testStatTable"]][["data"]]
  expect_equal(table[[1]][["testType"]], "z-test")
  expect_equal(table[[1]][["statistic"]], 1.96)
  expect_true(abs(table[[1]][["pvalue"]] - 0.05) < 0.01) # approximately 0.05
})

# Test t-test
test_that("t-test works correctly", {
  options <- analysisOptions("SummaryStatsTestStatistics") 
  options$testType <- "t"
  options$testStatistic <- 2.0
  options$df <- 10
  options$alternative <- "twoSided"
  results <- runAnalysis("SummaryStatsTestStatistics", NULL, options)
  
  table <- results[["results"]][["testStatTable"]][["data"]]
  expect_equal(table[[1]][["testType"]], "t-test")
  expect_equal(table[[1]][["statistic"]], 2.0)
  expect_equal(table[[1]][["df"]], 10)
  expect_true(table[[1]][["pvalue"]] > 0 && table[[1]][["pvalue"]] < 1)
})

# Test chi-square test
test_that("chi-square test works correctly", {
  options <- analysisOptions("SummaryStatsTestStatistics")
  options$testType <- "chisq"
  options$testStatistic <- 3.84
  options$df <- 1
  results <- runAnalysis("SummaryStatsTestStatistics", NULL, options)
  
  table <- results[["results"]][["testStatTable"]][["data"]]
  expect_equal(table[[1]][["testType"]], "χ²-test")
  expect_equal(table[[1]][["statistic"]], 3.84)
  expect_equal(table[[1]][["df"]], 1)
  expect_true(abs(table[[1]][["pvalue"]] - 0.05) < 0.01) # approximately 0.05
})

# Test F-test
test_that("F-test works correctly", {
  options <- analysisOptions("SummaryStatsTestStatistics")
  options$testType <- "f"
  options$testStatistic <- 4.0
  options$df1 <- 1
  options$df2 <- 10
  results <- runAnalysis("SummaryStatsTestStatistics", NULL, options)
  
  table <- results[["results"]][["testStatTable"]][["data"]]
  expect_equal(table[[1]][["testType"]], "F-test")
  expect_equal(table[[1]][["statistic"]], 4.0)
  expect_equal(table[[1]][["df1"]], 1)
  expect_equal(table[[1]][["df2"]], 10)
  expect_true(table[[1]][["pvalue"]] > 0 && table[[1]][["pvalue"]] < 1)
})