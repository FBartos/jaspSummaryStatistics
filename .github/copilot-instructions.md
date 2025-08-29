This is a JASP module that contains a QML user-facing interface and R files responsible for the back-end computations.

### Main Rules for Building QML Interface 
- The QML interface contains `Analyses` defined in the `inst/Descriptions/` directory. Each analysis links to the GUI defined in the `inst/qml/` directory and the R functions defined in the `R/` directory.
- The QML interface defines a list of options that are passed to the R functions via the `options` argument.
- The QML interface type-checks the `options` argument to ensure that the required options are present and have valid values. If any required option is missing or has an invalid value, the JASP software automatically terminates before proceeding to the R functions and an error message will be displayed to the user.
- The QML interface should prevent users from setting incorrect options by providing appropriate input controls. For example, the `DoubleField` contains `min` and `max` properties to restrict the range of acceptable values.
- The QML interface uses custom QML elements implemented in jasp-desktop (https://github.com/jasp-stats/jasp-desktop/). 
- A QML element's `title`/`label` property is user-facing and should be concise and descriptive.
- A QML element's `name` property is internal and should correspond to the `title`/`label` property translated into camelCase, inheriting prefixes from the hierarchy of the QML elements.
- QML elements should be organized in a way that reflects the logical structure of the user interface, grouping related elements together.
- QML elements should be documented using the `info` property. Document the elements in simple, non-technical, and accessible language.
- Use the existing QML files as examples for QML structure and style.
- If you add a new QML option, you might need to add the default value to the `options` list in the corresponding unit tests.
- Further details about the QML elements can be found in the `jasp-qml-guide.md` file.

### Main Rules for Building R Side
- The R files are located in the `R/` directory and contain R functions that are called by the `Analyses` defined in the `inst/Descriptions/` directory.
- The R files should follow CRAN guidelines for code, documentation, and package structure.
- R scripts should be organized in a way that reflects the logical structure of the analyses, grouping related functions together.
- R functions common to multiple analyses should be placed in a common R file (there are multiple common files depending on whether the functions are common to all analyses or only a subset of analyses).
- R files should always use camelCase for function and variable names throughout the codebase.
- Never use `library()` or `require()` in the R files. Use the `package::function()` syntax to avoid conflicts.
- Avoid adding dependencies unless absolutely necessary. If a simple R function would require a new dependency, re-implement the function without the dependency and acknowledge the source of the original function in a comment.
- Since the `options` argument is checked in the GUI, the R functions should not check the validity of the user input. The only exceptions are the `dataset` input object (a data.frame forwarded from the GUI) and the `TextField` and `FormulaField` options (which can contain arbitrary text input). If the `dataset`, `TextField`, or `FormulaField` contain an invalid input, the `.quitAnalysis(gettext("<INSERT INFORMATIVE ERROR MESSAGE>"))` function should be used to terminate the execution.
- The `tests` directory contains unit tests for the R functions. The unit tests are run via the `jaspTools::testAll()` function.
- Avoid using non-CRAN dependencies to maintain CRAN compliance.
- Further details about the R files can be found in the `jasp-r-guide.md` file.
- Further details about implementing the R analyses can be found in the `jasp-r-analyses-guide.md` file.
- Further details about writing messages for the user-facing elements can be found in the `jasp-human-guide.md` file.