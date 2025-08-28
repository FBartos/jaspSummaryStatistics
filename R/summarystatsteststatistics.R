SummaryStatsTestStatistics <- function(jaspResults, dataset, options, ...) {
  
  # Create main table
  if (is.null(jaspResults[["testStatTable"]])) {
    jaspResults[["testStatTable"]] <- .testStatMainTable(options)
  }
  
  return()
}

.testStatMainTable <- function(options) {
  
  table <- createJaspTable(title = gettext("Test Statistics"))
  table$dependOn(c("testType", "testStatistic", "df", "df1", "df2", "alternative"))
  
  # Add columns based on test type
  table$addColumnInfo(name = "testType", title = gettext("Test"), type = "string")
  table$addColumnInfo(name = "statistic", title = gettext("Statistic"), type = "number")
  
  if (options$testType %in% c("t", "chisq")) {
    table$addColumnInfo(name = "df", title = gettext("df"), type = "integer")
  }
  
  if (options$testType == "f") {
    table$addColumnInfo(name = "df1", title = gettext("df1"), type = "integer")
    table$addColumnInfo(name = "df2", title = gettext("df2"), type = "integer")
  }
  
  table$addColumnInfo(name = "pvalue", title = gettext("p"), type = "pvalue")
  
  # Calculate p-value
  results <- .calculatePValue(options)
  
  if (!is.null(results$error)) {
    table$setError(results$error)
    return(table)
  }
  
  # Create row data
  rowData <- list(
    testType = .getTestTypeLabel(options$testType),
    statistic = options$testStatistic
  )
  
  if (options$testType %in% c("t", "chisq")) {
    rowData$df <- options$df
  }
  
  if (options$testType == "f") {
    rowData$df1 <- options$df1
    rowData$df2 <- options$df2
  }
  
  rowData$pvalue <- results$pvalue
  
  table$addRows(rowData)
  
  return(table)
}

.calculatePValue <- function(options) {
  
  # Input validation
  if (is.null(options$testStatistic) || !is.finite(options$testStatistic)) {
    return(list(error = gettext("Test statistic must be a valid number")))
  }
  
  testStat <- options$testStatistic
  
  tryCatch({
    if (options$testType == "z") {
      # Z-test
      if (options$alternative == "twoSided") {
        pvalue <- 2 * stats::pnorm(abs(testStat), lower.tail = FALSE)
      } else if (options$alternative == "greater") {
        pvalue <- stats::pnorm(testStat, lower.tail = FALSE)
      } else { # less
        pvalue <- stats::pnorm(testStat)
      }
    } else if (options$testType == "t") {
      # t-test
      if (options$alternative == "twoSided") {
        pvalue <- 2 * stats::pt(abs(testStat), df = options$df, lower.tail = FALSE)
      } else if (options$alternative == "greater") {
        pvalue <- stats::pt(testStat, df = options$df, lower.tail = FALSE)
      } else { # less
        pvalue <- stats::pt(testStat, df = options$df)
      }
    } else if (options$testType == "chisq") {
      # Chi-square test (always upper tail)
      pvalue <- stats::pchisq(testStat, df = options$df, lower.tail = FALSE)
    } else if (options$testType == "f") {
      # F-test (always upper tail)
      pvalue <- stats::pf(testStat, df1 = options$df1, df2 = options$df2, lower.tail = FALSE)
    }
    
    return(list(pvalue = pvalue))
    
  }, error = function(e) {
    return(list(error = gettext("Error calculating p-value: ") + e$message))
  })
}

.getTestTypeLabel <- function(testType) {
  switch(testType,
    "z" = "z-test",
    "t" = "t-test", 
    "chisq" = "χ²-test",
    "f" = "F-test",
    testType
  )
}