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

  # Check for errors
  .testStatisticsCheckErrors(options)

  # Create results table
  .testStatisticsMainTable(jaspResults, options)

  return()
}

.testStatisticsCheckErrors <- function(options) {
  
  # Basic validation based on test type
  if (options[["testType"]] == "zTest") {
    if (!is.numeric(options[["zStatistic"]]) || is.na(options[["zStatistic"]])) {
      jaspBase::.quitAnalysis(gettext("Please provide a valid z-statistic value."))
    }
  } else if (options[["testType"]] == "tTest") {
    if (!is.numeric(options[["tStatistic"]]) || is.na(options[["tStatistic"]])) {
      jaspBase::.quitAnalysis(gettext("Please provide a valid t-statistic value."))
    }
    if (!is.numeric(options[["tDf"]]) || is.na(options[["tDf"]]) || options[["tDf"]] <= 0) {
      jaspBase::.quitAnalysis(gettext("Please provide valid degrees of freedom (positive integer)."))
    }
  } else if (options[["testType"]] == "chiSquare") {
    if (!is.numeric(options[["chiSquareStatistic"]]) || is.na(options[["chiSquareStatistic"]]) || options[["chiSquareStatistic"]] < 0) {
      jaspBase::.quitAnalysis(gettext("Please provide a valid chi-square statistic value (non-negative)."))
    }
    if (!is.numeric(options[["chiSquareDf"]]) || is.na(options[["chiSquareDf"]]) || options[["chiSquareDf"]] <= 0) {
      jaspBase::.quitAnalysis(gettext("Please provide valid degrees of freedom (positive integer)."))
    }
  } else if (options[["testType"]] == "fTest") {
    if (!is.numeric(options[["fStatistic"]]) || is.na(options[["fStatistic"]]) || options[["fStatistic"]] < 0) {
      jaspBase::.quitAnalysis(gettext("Please provide a valid F-statistic value (non-negative)."))
    }
    if (!is.numeric(options[["fDf1"]]) || is.na(options[["fDf1"]]) || options[["fDf1"]] <= 0) {
      jaspBase::.quitAnalysis(gettext("Please provide valid numerator degrees of freedom (positive integer)."))
    }
    if (!is.numeric(options[["fDf2"]]) || is.na(options[["fDf2"]]) || options[["fDf2"]] <= 0) {
      jaspBase::.quitAnalysis(gettext("Please provide valid denominator degrees of freedom (positive integer)."))
    }
  }
}

.testStatisticsMainTable <- function(jaspResults, options) {
  
  if (!is.null(jaspResults[["testStatisticsTable"]])) {
    return()
  }

  # Create the table
  testStatisticsTable <- jaspBase::createJaspTable(title = gettext("Test Statistics"))
  testStatisticsTable$dependOn(c("testType", "zStatistic", "tStatistic", "tDf", 
                                  "chiSquareStatistic", "chiSquareDf", 
                                  "fStatistic", "fDf1", "fDf2", "alternative"))

  # Add columns based on test type
  testStatisticsTable$addColumnInfo(name = "test", title = gettext("Test"), type = "string")
  testStatisticsTable$addColumnInfo(name = "statistic", title = gettext("Statistic"), type = "number")
  
  if (options[["testType"]] == "tTest") {
    testStatisticsTable$addColumnInfo(name = "df", title = gettext("df"), type = "integer")
  } else if (options[["testType"]] == "chiSquare") {
    testStatisticsTable$addColumnInfo(name = "df", title = gettext("df"), type = "integer")
  } else if (options[["testType"]] == "fTest") {
    testStatisticsTable$addColumnInfo(name = "df1", title = gettext("df1"), type = "integer")
    testStatisticsTable$addColumnInfo(name = "df2", title = gettext("df2"), type = "integer")
  }
  
  testStatisticsTable$addColumnInfo(name = "pValue", title = gettext("p-value"), type = "pvalue")

  jaspResults[["testStatisticsTable"]] <- testStatisticsTable

  # Calculate p-value
  result <- .testStatisticsCalculatePValue(options)
  
  if (!is.null(result)) {
    testStatisticsTable$addRows(result)
  }

  return()
}

.testStatisticsCalculatePValue <- function(options) {
  
  if (options[["testType"]] == "zTest") {
    statistic <- options[["zStatistic"]]
    alternative <- options[["alternative"]]
    
    if (alternative == "twoSided") {
      pValue <- 2 * (1 - stats::pnorm(abs(statistic)))
    } else if (alternative == "greater") {
      pValue <- 1 - stats::pnorm(statistic)
    } else if (alternative == "less") {
      pValue <- stats::pnorm(statistic)
    }
    
    return(list(
      test = "z-test",
      statistic = statistic,
      pValue = pValue
    ))
    
  } else if (options[["testType"]] == "tTest") {
    statistic <- options[["tStatistic"]]
    df <- options[["tDf"]]
    alternative <- options[["alternative"]]
    
    if (alternative == "twoSided") {
      pValue <- 2 * (1 - stats::pt(abs(statistic), df))
    } else if (alternative == "greater") {
      pValue <- 1 - stats::pt(statistic, df)
    } else if (alternative == "less") {
      pValue <- stats::pt(statistic, df)
    }
    
    return(list(
      test = "t-test",
      statistic = statistic,
      df = df,
      pValue = pValue
    ))
    
  } else if (options[["testType"]] == "chiSquare") {
    statistic <- options[["chiSquareStatistic"]]
    df <- options[["chiSquareDf"]]
    pValue <- 1 - stats::pchisq(statistic, df)
    
    return(list(
      test = "Chi-square test",
      statistic = statistic,
      df = df,
      pValue = pValue
    ))
    
  } else if (options[["testType"]] == "fTest") {
    statistic <- options[["fStatistic"]]
    df1 <- options[["fDf1"]]
    df2 <- options[["fDf2"]]
    pValue <- 1 - stats::pf(statistic, df1, df2)
    
    return(list(
      test = "F-test",
      statistic = statistic,
      df1 = df1,
      df2 = df2,
      pValue = pValue
    ))
  }
  
  return(NULL)
}