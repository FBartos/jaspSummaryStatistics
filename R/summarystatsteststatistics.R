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

  # Create main results table
  .testStatisticsMainTable(jaspResults, options)
  
  return()
}

.testStatisticsMainTable <- function(jaspResults, options) {
  
  if (!is.null(jaspResults[["testStatisticsTable"]])) return()
  
  # Create table
  testStatisticsTable <- createJaspTable(title = gettext("Test Statistics"))
  testStatisticsTable$position <- 1
  
  # Add columns based on test type
  if (options[["testType"]] == "z") {
    testStatisticsTable$addColumnInfo(name = "statistic", title = gettext("z"), type = "number")
    testStatisticsTable$dependOn(c("testType", "zStatistic", "alternative"))
  } else if (options[["testType"]] == "t") {
    testStatisticsTable$addColumnInfo(name = "statistic", title = gettext("t"), type = "number")
    testStatisticsTable$addColumnInfo(name = "df", title = gettext("df"), type = "integer")
    testStatisticsTable$dependOn(c("testType", "tStatistic", "tDf", "alternative"))
  } else if (options[["testType"]] == "chisq") {
    testStatisticsTable$addColumnInfo(name = "statistic", title = gettext("χ²"), type = "number")
    testStatisticsTable$addColumnInfo(name = "df", title = gettext("df"), type = "integer")
    testStatisticsTable$dependOn(c("testType", "chisqStatistic", "chisqDf"))
  } else if (options[["testType"]] == "f") {
    testStatisticsTable$addColumnInfo(name = "statistic", title = gettext("F"), type = "number")
    testStatisticsTable$addColumnInfo(name = "df1", title = gettext("df₁"), type = "integer")
    testStatisticsTable$addColumnInfo(name = "df2", title = gettext("df₂"), type = "integer")
    testStatisticsTable$dependOn(c("testType", "fStatistic", "fDf1", "fDf2"))
  }
  
  testStatisticsTable$addColumnInfo(name = "pValue", title = gettext("p"), type = "pvalue")
  
  jaspResults[["testStatisticsTable"]] <- testStatisticsTable
  
  # Calculate p-values
  results <- .calculatePValue(options)
  
  # Create row for results
  row <- list()
  
  if (options[["testType"]] == "z") {
    row[["statistic"]] <- options[["zStatistic"]]
  } else if (options[["testType"]] == "t") {
    row[["statistic"]] <- options[["tStatistic"]]
    row[["df"]] <- options[["tDf"]]
  } else if (options[["testType"]] == "chisq") {
    row[["statistic"]] <- options[["chisqStatistic"]]
    row[["df"]] <- options[["chisqDf"]]
  } else if (options[["testType"]] == "f") {
    row[["statistic"]] <- options[["fStatistic"]]
    row[["df1"]] <- options[["fDf1"]]
    row[["df2"]] <- options[["fDf2"]]
  }
  
  row[["pValue"]] <- results[["pValue"]]
  
  testStatisticsTable$addRows(row)
}

.calculatePValue <- function(options) {
  
  testType <- options[["testType"]]
  
  if (testType == "z") {
    statistic <- options[["zStatistic"]]
    alternative <- options[["alternative"]]
    
    if (alternative == "twoSided") {
      pValue <- 2 * stats::pnorm(-abs(statistic))
    } else if (alternative == "greater") {
      pValue <- stats::pnorm(statistic, lower.tail = FALSE)
    } else if (alternative == "less") {
      pValue <- stats::pnorm(statistic)
    }
    
  } else if (testType == "t") {
    statistic <- options[["tStatistic"]]
    df <- options[["tDf"]]
    alternative <- options[["alternative"]]
    
    if (alternative == "twoSided") {
      pValue <- 2 * stats::pt(-abs(statistic), df = df)
    } else if (alternative == "greater") {
      pValue <- stats::pt(statistic, df = df, lower.tail = FALSE)
    } else if (alternative == "less") {
      pValue <- stats::pt(statistic, df = df)
    }
    
  } else if (testType == "chisq") {
    statistic <- options[["chisqStatistic"]]
    df <- options[["chisqDf"]]
    
    pValue <- stats::pchisq(statistic, df = df, lower.tail = FALSE)
    
  } else if (testType == "f") {
    statistic <- options[["fStatistic"]]
    df1 <- options[["fDf1"]]
    df2 <- options[["fDf2"]]
    
    pValue <- stats::pf(statistic, df1 = df1, df2 = df2, lower.tail = FALSE)
  }
  
  return(list(pValue = pValue))
}