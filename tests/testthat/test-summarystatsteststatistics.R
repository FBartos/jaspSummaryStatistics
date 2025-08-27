context("Summary Statistics Test Statistics")

# Test z-test functionality
test_that("z-test two-sided results match", {
  options <- jaspTools::analysisOptions("SummaryStatsTestStatistics")
  options$testType <- "zTest"
  options$zStatistic <- 1.96
  options$alternative <- "twoSided"
  results <- jaspTools::runAnalysis("SummaryStatsTestStatistics", "debug.csv", options)

  table <- results[["results"]][["testStatisticsTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
                      list("z-test", 1.96, 0.0499957902964407))
})

test_that("t-test one-sided results match", {
  options <- jaspTools::analysisOptions("SummaryStatsTestStatistics")
  options$testType <- "tTest"
  options$tStatistic <- 2.0
  options$tDf <- 10
  options$alternative <- "greater"
  results <- jaspTools::runAnalysis("SummaryStatsTestStatistics", "debug.csv", options)

  table <- results[["results"]][["testStatisticsTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
                      list("t-test", 2.0, 10, 0.0366940173853703))
})

test_that("chi-square test results match", {
  options <- jaspTools::analysisOptions("SummaryStatsTestStatistics")
  options$testType <- "chiSquare"
  options$chiSquareStatistic <- 5.99
  options$chiSquareDf <- 2
  results <- jaspTools::runAnalysis("SummaryStatsTestStatistics", "debug.csv", options)

  table <- results[["results"]][["testStatisticsTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
                      list("Chi-square test", 5.99, 2, 0.0500366270865863))
})

test_that("F-test results match", {
  options <- jaspTools::analysisOptions("SummaryStatsTestStatistics")
  options$testType <- "fTest"
  options$fStatistic <- 4.0
  options$fDf1 <- 2
  options$fDf2 <- 15
  results <- jaspTools::runAnalysis("SummaryStatsTestStatistics", "debug.csv", options)

  table <- results[["results"]][["testStatisticsTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
                      list("F-test", 4.0, 2, 15, 0.0405252472096711))
})