# JASP Summary Statistics Module

ALWAYS follow these instructions first and fallback to additional search and context gathering ONLY if the information in these instructions is incomplete or found to be in error.

This is a JASP module providing Bayesian statistical tests from summary statistics. It contains QML user-facing interfaces and R backend computations.

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
- QML elements use `name` (camelCase internal) and `title`/`label` (user-facing)
- Document QML elements using `info` property for help generation
- Use existing QML files as examples for structure and style
- Add default values to unit tests when adding new QML options

### R Backend Rules  
- R functions in `R/` directory called by analyses in `inst/Descriptions/`
- Use camelCase for all function and variable names
- NEVER use `library()` or `require()` - use `package::function()` syntax
- Avoid new dependencies - re-implement simple functions instead
- Use `.quitAnalysis(gettext("message"))` for terminating execution on invalid input
- Follow CRAN guidelines for code structure and documentation

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
1. Create R function in `R/` directory following camelCase naming
2. Add QML interface in `inst/qml/`  
3. Define analysis in `inst/Description.qml`
4. Create help file in `inst/help/`
5. Add unit tests in `tests/testthat/`
6. Run `jaspTools::testAll()` to validate (70+ seconds, NEVER CANCEL)

### Modifying Existing Analysis
1. Update R function maintaining existing interface
2. Update QML if adding/changing options
3. Update help documentation
4. Update unit tests and expected results
5. Add upgrade mapping to `inst/Upgrades.qml` if renaming options
6. Run tests: `jaspTools::testAll()` (NEVER CANCEL, 70+ seconds)

### Key Dependencies
- jaspTools: Testing and development framework
- BayesFactor: Core Bayesian computations  
- jaspBase, jaspGraphs, jaspTTests: Core JASP functionality
- R 4.5+ required

## Validation Checklist
- [ ] Run `jaspTools::testAll()` - wait full 70+ seconds, all 113 tests pass
- [ ] Check test output for new failures (ignore deprecation warnings)  
- [ ] Verify help files updated for interface changes
- [ ] Confirm QML options have corresponding test defaults
- [ ] Add upgrade mappings if renaming QML options