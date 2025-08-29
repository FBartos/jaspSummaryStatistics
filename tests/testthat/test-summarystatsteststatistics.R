context("Summary Stats Test Statistics")

test_that("Z-test results match", {
  options <- jaspTools::analysisOptions("SummaryStatsTestStatistics")
  
  options$testType <- "z"
  options$zStatistic <- 1.96
  options$alternative <- "twoSided"
  
  results <- jaspTools::runAnalysis("SummaryStatsTestStatistics", "debug.csv", options)
  table   <- results[["results"]][["testStatisticsContainer"]][["collection"]][["testStatisticsContainer_testStatisticsTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
                      list("z", 0.0499584, 1.96)
  )
})

test_that("T-test results match", {
  options <- jaspTools::analysisOptions("SummaryStatsTestStatistics")
  
  options$testType <- "t" 
  options$tStatistic <- 2.0
  options$tDf <- 9
  options$alternative <- "twoSided"
  
  results <- jaspTools::runAnalysis("SummaryStatsTestStatistics", "debug.csv", options)
  table   <- results[["results"]][["testStatisticsContainer"]][["collection"]][["testStatisticsContainer_testStatisticsTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
                      list("t", 9, 0.0755928, 2)
  )
})

test_that("Chi-square test results match", {
  options <- jaspTools::analysisOptions("SummaryStatsTestStatistics")
  
  options$testType <- "chisq"
  options$chisqStatistic <- 5.991
  options$chisqDf <- 2
  
  results <- jaspTools::runAnalysis("SummaryStatsTestStatistics", "debug.csv", options)
  table   <- results[["results"]][["testStatisticsContainer"]][["collection"]][["testStatisticsContainer_testStatisticsTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
                      list("χ²", 2, 0.0500793, 5.991)
  )
})

test_that("F-test results match", {
  options <- jaspTools::analysisOptions("SummaryStatsTestStatistics")
  
  options$testType <- "f"
  options$fStatistic <- 3.84
  options$fDf1 <- 1
  options$fDf2 <- 10
  
  results <- jaspTools::runAnalysis("SummaryStatsTestStatistics", "debug.csv", options)
  table   <- results[["results"]][["testStatisticsContainer"]][["collection"]][["testStatisticsContainer_testStatisticsTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
                      list("F", 1, 10, 0.0791305, 3.84)
  )
})

test_that("One-tailed z-test results match", {
  options <- jaspTools::analysisOptions("SummaryStatsTestStatistics")
  
  options$testType <- "z"
  options$zStatistic <- 1.645
  options$alternative <- "greater"
  
  results <- jaspTools::runAnalysis("SummaryStatsTestStatistics", "debug.csv", options)
  table   <- results[["results"]][["testStatisticsContainer"]][["collection"]][["testStatisticsContainer_testStatisticsTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
                      list("z", 0.0500158, 1.645)
  )
})