#
# Copyright (C) 2013-2018 University of Amsterdam
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

SummaryStatsTestStatistics <- function(jaspResults, dataset = NULL, options, ...) {
  
  # Check user input for possible errors
  .checkErrorsTestStatistics(options)
  
  # Compute the results and create main results table
  testStatsResults <- .testStatisticsMainFunction(jaspResults, options)
  
  return()
}

.checkErrorsTestStatistics <- function(options) {
  
  # Check if test statistic values are provided based on test type
  if (options$testType == "z" && is.null(options$zStatistic)) {
    .quitAnalysis(gettext("Please provide a z-statistic value"))
  }
  
  if (options$testType == "t" && (is.null(options$tStatistic) || is.null(options$tDf))) {
    .quitAnalysis(gettext("Please provide t-statistic and degrees of freedom"))
  }
  
  if (options$testType == "chisq" && (is.null(options$chisqStatistic) || is.null(options$chisqDf))) {
    .quitAnalysis(gettext("Please provide χ²-statistic and degrees of freedom"))
  }
  
  if (options$testType == "f" && (is.null(options$fStatistic) || is.null(options$fDf1) || is.null(options$fDf2))) {
    .quitAnalysis(gettext("Please provide F-statistic and both degrees of freedom"))
  }
  
  # Check for valid degrees of freedom
  if (options$testType == "t" && options$tDf <= 0) {
    .quitAnalysis(gettext("Degrees of freedom must be positive"))
  }
  
  if (options$testType == "chisq" && options$chisqDf <= 0) {
    .quitAnalysis(gettext("Degrees of freedom must be positive"))
  }
  
  if (options$testType == "f" && (options$fDf1 <= 0 || options$fDf2 <= 0)) {
    .quitAnalysis(gettext("Both degrees of freedom must be positive"))
  }
  
  # Check for valid test statistics
  if (options$testType == "chisq" && options$chisqStatistic < 0) {
    .quitAnalysis(gettext("χ²-statistic must be non-negative"))
  }
  
  if (options$testType == "f" && options$fStatistic < 0) {
    .quitAnalysis(gettext("F-statistic must be non-negative"))
  }
}

.testStatisticsMainFunction <- function(jaspResults, options) {
  
  # Create container for results
  container <- jaspResults[["testStatisticsContainer"]]
  if (is.null(container)) {
    container <- createJaspContainer("Test Statistics Results")
    container$position <- 1
    jaspResults[["testStatisticsContainer"]] <- container
  }
  
  # Create main table
  testStatsTable <- .createTestStatisticsTable(options)
  container[["testStatisticsTable"]] <- testStatsTable
  
  # Check if ready to compute
  ready <- .isReadyTestStatistics(options)
  
  if (ready) {
    # Compute results
    results <- .computeTestStatisticsResults(options)
    testStatsTable$setData(results)
  }
  
  return(list(ready = ready, table = testStatsTable))
}

.createTestStatisticsTable <- function(options) {
  
  # Create table
  testStatsTable <- createJaspTable(gettext("Test Statistics Results"))
  testStatsTable$position <- 1
  testStatsTable$dependOn(c("testType", "alternative", "zStatistic", "tStatistic", "tDf", 
                           "chisqStatistic", "chisqDf", "fStatistic", "fDf1", "fDf2"))
  
  # Add columns based on test type
  testStatsTable$addColumnInfo(name = "testType", title = gettext("Test"), type = "string")
  testStatsTable$addColumnInfo(name = "statistic", title = gettext("Statistic"), type = "number")
  
  if (options$testType %in% c("t", "chisq")) {
    testStatsTable$addColumnInfo(name = "df", title = gettext("df"), type = "integer")
  } else if (options$testType == "f") {
    testStatsTable$addColumnInfo(name = "df1", title = gettext("df1"), type = "integer")
    testStatsTable$addColumnInfo(name = "df2", title = gettext("df2"), type = "integer")
  }
  
  testStatsTable$addColumnInfo(name = "pValue", title = gettext("p"), type = "pvalue")
  
  return(testStatsTable)
}

.isReadyTestStatistics <- function(options) {
  
  if (options$testType == "z") {
    return(!is.null(options$zStatistic))
  } else if (options$testType == "t") {
    return(!is.null(options$tStatistic) && !is.null(options$tDf))
  } else if (options$testType == "chisq") {
    return(!is.null(options$chisqStatistic) && !is.null(options$chisqDf))
  } else if (options$testType == "f") {
    return(!is.null(options$fStatistic) && !is.null(options$fDf1) && !is.null(options$fDf2))
  }
  
  return(FALSE)
}

.computeTestStatisticsResults <- function(options) {
  
  results <- list()
  
  if (options$testType == "z") {
    statistic <- options$zStatistic
    
    if (options$alternative == "twoSided") {
      pValue <- 2 * stats::pnorm(-abs(statistic))
    } else if (options$alternative == "greater") {
      pValue <- 1 - stats::pnorm(statistic)
    } else { # less
      pValue <- stats::pnorm(statistic)
    }
    
    results <- list(
      testType = "z",
      statistic = statistic,
      pValue = pValue
    )
    
  } else if (options$testType == "t") {
    statistic <- options$tStatistic
    df <- options$tDf
    
    if (options$alternative == "twoSided") {
      pValue <- 2 * stats::pt(-abs(statistic), df)
    } else if (options$alternative == "greater") {
      pValue <- 1 - stats::pt(statistic, df)
    } else { # less
      pValue <- stats::pt(statistic, df)
    }
    
    results <- list(
      testType = "t",
      statistic = statistic,
      df = df,
      pValue = pValue
    )
    
  } else if (options$testType == "chisq") {
    statistic <- options$chisqStatistic
    df <- options$chisqDf
    pValue <- 1 - stats::pchisq(statistic, df)
    
    results <- list(
      testType = "χ²",
      statistic = statistic,
      df = df,
      pValue = pValue
    )
    
  } else if (options$testType == "f") {
    statistic <- options$fStatistic
    df1 <- options$fDf1
    df2 <- options$fDf2
    pValue <- 1 - stats::pf(statistic, df1, df2)
    
    results <- list(
      testType = "F",
      statistic = statistic,
      df1 = df1,
      df2 = df2,
      pValue = pValue
    )
  }
  
  return(results)
}