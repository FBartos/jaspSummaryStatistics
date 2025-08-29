# JASP Summary Statistics Module

ALWAYS follow these instructions first and fallback to additional search and context gathering ONLY if the information in these instructions is incomplete or found to be in error.

This is a JASP module providing Bayesian statistical tests from summary statistics. It contains QML user-facing interfaces and R backend computations.

## Critical Reference Guides

**MANDATORY**: Always consult these comprehensive guides located in `.github/` for detailed development work:

- **[jasp-qml-guide.md](.github/jasp-qml-guide.md)** - Complete QML component reference (1000+ lines covering all components, properties, layout, connections)
- **[jasp-human-guide.md](.github/jasp-human-guide.md)** - Essential user experience guidelines (error messages, internationalization, input validation)  
- **[r-analyses-guide.md](.github/r-analyses-guide.md)** - Comprehensive R analysis development guide (step-by-step process, error checking, tables/plots/text)
- **[r-style-guide.md](.github/r-style-guide.md)** - R coding standards and style requirements

These are the authoritative references for all detailed development work. Use them extensively.

## Working Effectively

### Initial Setup and Build
- Install R (version 4.5+ required): The system already has R 4.5.1
- Run tests to validate setup: `cd /path/to/jaspSummaryStatistics && Rscript -e "library(jaspTools); testAll()"`
- Tests take 70+ seconds to complete. NEVER CANCEL. Set timeout to 120+ seconds.
- All tests should pass (113 PASS expected) with some deprecation warnings that can be ignored.

### Running Tests
- `Rscript -e "library(jaspTools); testAll()"` -- runs full test suite, takes 70+ seconds. NEVER CANCEL.
- Tests are located in `tests/testthat/test-*.R` files
- Each test file corresponds to an R analysis file in the `R/` directory
- Test snapshots are stored in `tests/testthat/_snaps/`

### Repository Structure
```
/
├── R/                          # Backend R analysis functions
├── inst/
│   ├── qml/                   # QML interface definitions
│   ├── Descriptions/          # Analysis descriptions (Description.qml)
│   ├── help/                  # Markdown help files
│   └── Upgrades.qml          # Version upgrade mappings
├── tests/testthat/           # Unit tests using jaspTools
├── .github/workflows/        # CI/CD automation
├── DESCRIPTION               # R package metadata
├── renv.lock                # R dependency lockfile
└── jaspSummaryStatistics.Rproj  # RStudio project
```

### Key Files to Check After Changes
- Always check corresponding test file in `tests/testthat/` when modifying R functions
- Always update `inst/help/*.md` when changing analysis interfaces
- Check `inst/Upgrades.qml` when renaming QML options to maintain backward compatibility

## Building and Testing Code Changes

### Before Making Changes
- Run full test suite to establish baseline: `Rscript -e "library(jaspTools); testAll()"`
- NEVER CANCEL: Tests take 70+ seconds, set timeout to 120+ seconds

### After Making Changes
- Run tests again to verify your changes: `Rscript -e "library(jaspTools); testAll()"`
- NEVER CANCEL: Build and test can take up to 2 minutes total
- All 113 tests must pass - do not proceed if tests fail
- Some deprecation warnings are expected and can be ignored

### Manual Validation Scenarios
Since this module runs within JASP desktop application, manual testing requires:
- Testing via jaspTools test framework (covered above)
- Individual analysis validation can be done through R console using jaspTools::runAnalysis()
- CANNOT run standalone - module only functions within JASP ecosystem

## Development Rules

### QML Interface Rules
- QML interfaces in `inst/qml/` define user-facing options passed to R functions
- Each analysis links: `inst/Descriptions/` → `inst/qml/` → `R/` functions
- **CRITICAL**: Always reference [jasp-qml-guide.md](.github/jasp-qml-guide.md) for complete component documentation
- QML elements use `name` (camelCase internal) and `title`/`label` (user-facing)
- Document QML elements using `info` property for help generation
- Use existing QML files as examples for structure and style
- Add default values to unit tests when adding new QML options

### R Backend Rules  
- R functions in `R/` directory called by analyses in `inst/Descriptions/`
- **CRITICAL**: Follow [r-style-guide.md](.github/r-style-guide.md) for all coding standards
- **CRITICAL**: Use [r-analyses-guide.md](.github/r-analyses-guide.md) for step-by-step development process
- Use camelCase for all function and variable names
- NEVER use `library()` or `require()` - use `package::function()` syntax
- Avoid new dependencies - re-implement simple functions instead
- Use `.quitAnalysis(gettext("message"))` for terminating execution on invalid input
- Follow CRAN guidelines for code structure and documentation

### Input Validation and Error Handling
- **MANDATORY**: Always implement comprehensive input validation using `.hasErrors()` function
- **CRITICAL**: Reference [jasp-human-guide.md](.github/jasp-human-guide.md) for user-friendly error messages
- Use `gettext()` and `gettextf()` for all user-visible messages (internationalization)
- Check for: missing values, infinity, negative values, insufficient observations, factor levels, variance
- Example: `.hasErrors(dataset, type = c('observations', 'variance', 'infinity'), all.target = options$variables, observations.amount = '< 3', exitAnalysisIfErrors = TRUE)`
- Always validate assumptions automatically, even when users don't explicitly request checks
- Use footnotes for assumption violations that affect specific cells/values
- Place critical errors that invalidate entire analysis over the results table

### Error Message Guidelines (from jasp-human-guide.md)
- Write clear, actionable error messages that prevent user confusion
- Use `gettextf()` with placeholders for dynamic content: `gettextf("Number of factor levels is %1$s in %2$s", levels, variable)`
- For multiple arguments, use `%1$s`, `%2$s` format for translator clarity
- Use `ngettext()` for singular/plural forms
- Never mark empty strings for translation
- Use UTF-8 encoding for non-ASCII characters: `\u03B2` for β
- Double `%` characters in format strings: `gettextf("%s%% CI for Mean")`

### Testing Requirements
- Unit tests in `tests/testthat/` use jaspTools framework
- Tests run via `jaspTools::testAll()` - takes 70+ seconds, NEVER CANCEL
- Test files correspond to R analysis files (test-*.R matches *.R)
- Update test expected values when changing analysis outputs

## CI/CD Pipeline
- GitHub Actions in `.github/workflows/unittests.yml` runs on every push
- Triggers on changes to R, test, or package files
- Uses jasp-stats/jasp-actions reusable workflow
- No external dependencies (JAGS, igraph) required for this module

## Common Tasks

### Adding New Analysis
1. **MANDATORY**: Follow complete process in [r-analyses-guide.md](.github/r-analyses-guide.md)
2. Create R function in `R/` directory following camelCase naming
3. Add QML interface in `inst/qml/` (reference [jasp-qml-guide.md](.github/jasp-qml-guide.md))  
4. Define analysis in `inst/Description.qml`
5. Create help file in `inst/help/`
6. Add unit tests in `tests/testthat/`
7. Run `jaspTools::testAll()` to validate (70+ seconds, NEVER CANCEL)

### Modifying Existing Analysis
1. **MANDATORY**: Follow [r-analyses-guide.md](.github/r-analyses-guide.md) for proper structure
2. Update R function maintaining existing interface
3. Update QML if adding/changing options (see [jasp-qml-guide.md](.github/jasp-qml-guide.md))
4. Update help documentation
5. Update unit tests and expected results
6. Add upgrade mapping to `inst/Upgrades.qml` if renaming options
7. Run tests: `jaspTools::testAll()` (NEVER CANCEL, 70+ seconds)

### Detailed Development Process (from r-analyses-guide.md)
- **Step 1**: Create main analysis function with `jaspResults`, `dataset`, `options` arguments
- **Step 2**: Check if results can be computed (`ready <- length(options$variables) > 0`)
- **Step 3**: Read dataset with `.readDataSetToEnd()` and proper column specifications  
- **Step 4**: **CRITICAL** - Use `.hasErrors()` for comprehensive error checking
- **Step 5**: Create output tables/plots with proper dependencies, citations, column specs
- Use `createJaspTable()`, `createJaspPlot()`, `createJaspHtml()` for output elements
- Always set `$dependOn()` for proper caching and state management
- Use containers for grouping related elements, state objects for reusing computed results

### Key Dependencies
- jaspTools: Testing and development framework
- BayesFactor: Core Bayesian computations  
- jaspBase, jaspGraphs, jaspTTests: Core JASP functionality
- R 4.5+ required

## Validation Checklist
- [ ] **MANDATORY**: Referenced [jasp-qml-guide.md](.github/jasp-qml-guide.md) for QML components
- [ ] **MANDATORY**: Referenced [r-analyses-guide.md](.github/r-analyses-guide.md) for R development  
- [ ] **MANDATORY**: Referenced [jasp-human-guide.md](.github/jasp-human-guide.md) for user experience
- [ ] **MANDATORY**: Followed [r-style-guide.md](.github/r-style-guide.md) for coding standards
- [ ] Run `jaspTools::testAll()` - wait full 70+ seconds, all 113 tests pass
- [ ] Check test output for new failures (ignore deprecation warnings)  
- [ ] Verify help files updated for interface changes
- [ ] Confirm QML options have corresponding test defaults
- [ ] Add upgrade mappings if renaming QML options
- [ ] Implemented comprehensive input validation with `.hasErrors()`
- [ ] Used `gettext()`/`gettextf()` for all user-visible messages
- [ ] Added proper error handling for edge cases and invalid inputs