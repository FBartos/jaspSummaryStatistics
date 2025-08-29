context("Summary Stats Test Statistics")

test_that("Main table results match for z-test", {
  options <- list(
    testType = "z",
    zStatistic = 1.96,
    alternative = "twoSided"
  )
  
  results <- jaspTools::runAnalysis("SummaryStatsTestStatistics", options = options)
  table <- results[["results"]][["testStatisticsTable"]][["data"]]
  
  expect_equal(table[[1]][["statistic"]], 1.96, tolerance = 1e-5)
  expect_equal(table[[1]][["pValue"]], 0.05, tolerance = 1e-2)
})

test_that("Main table results match for t-test", {
  options <- list(
    testType = "t",
    tStatistic = 2.0,
    tDf = 10,
    alternative = "twoSided"
  )
  
  results <- jaspTools::runAnalysis("SummaryStatsTestStatistics", options = options)
  table <- results[["results"]][["testStatisticsTable"]][["data"]]
  
  expect_equal(table[[1]][["statistic"]], 2.0, tolerance = 1e-5)
  expect_equal(table[[1]][["df"]], 10)
  expect_true(table[[1]][["pValue"]] > 0 && table[[1]][["pValue"]] < 1)
})

test_that("Main table results match for chi-squared test", {
  options <- list(
    testType = "chisq",
    chisqStatistic = 3.84,
    chisqDf = 1
  )
  
  results <- jaspTools::runAnalysis("SummaryStatsTestStatistics", options = options)
  table <- results[["results"]][["testStatisticsTable"]][["data"]]
  
  expect_equal(table[[1]][["statistic"]], 3.84, tolerance = 1e-5)
  expect_equal(table[[1]][["df"]], 1)
  expect_equal(table[[1]][["pValue"]], 0.05, tolerance = 1e-2)
})

test_that("Main table results match for F-test", {
  options <- list(
    testType = "f",
    fStatistic = 4.0,
    fDf1 = 1,
    fDf2 = 10
  )
  
  results <- jaspTools::runAnalysis("SummaryStatsTestStatistics", options = options)
  table <- results[["results"]][["testStatisticsTable"]][["data"]]
  
  expect_equal(table[[1]][["statistic"]], 4.0, tolerance = 1e-5)
  expect_equal(table[[1]][["df1"]], 1)
  expect_equal(table[[1]][["df2"]], 10)
  expect_true(table[[1]][["pValue"]] > 0 && table[[1]][["pValue"]] < 1)
})