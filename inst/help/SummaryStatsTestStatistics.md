Test Statistics
===

This function allows you to compute p-values from common test statistics (z, t, chi-square, F) and their corresponding degrees of freedom. This provides a unified and user-friendly way to obtain p-values from test statistics without needing the raw data.

### Assumptions
- The test statistics follow their respective theoretical distributions under the null hypothesis
- For z-tests: The test statistic follows a standard normal distribution
- For t-tests: The test statistic follows a t-distribution with specified degrees of freedom  
- For chi-square tests: The test statistic follows a chi-square distribution with specified degrees of freedom
- For F-tests: The test statistic follows an F-distribution with specified numerator and denominator degrees of freedom

### Input
---
#### Test Type
Select the type of test statistic:
- **z-test**: For test statistics that follow a standard normal distribution
- **t-test**: For test statistics that follow a t-distribution  
- **Chi-square test**: For test statistics that follow a chi-square distribution
- **F-test**: For test statistics that follow an F-distribution

#### Test Statistics
Depending on the selected test type, provide:
- **z-test**: z-statistic value
- **t-test**: t-statistic value and degrees of freedom
- **Chi-square test**: chi-square statistic value and degrees of freedom  
- **F-test**: F-statistic value, numerator degrees of freedom, and denominator degrees of freedom

#### Alternative Hypothesis (z and t tests only)
- *Two-sided*: Tests whether the parameter differs from the null value in either direction
- *Greater*: Tests whether the parameter is greater than the null value (one-sided)
- *Less*: Tests whether the parameter is less than the null value (one-sided)

Note: Chi-square and F-tests are inherently one-sided (right-tailed) tests.

### Output
---
#### Test Statistics Table
- **Test**: The type of test performed
- **Statistic**: The input test statistic value
- **df** (t and chi-square tests): Degrees of freedom
- **df1, df2** (F-test): Numerator and denominator degrees of freedom
- **p-value**: The computed p-value based on the test statistic and specified distribution

### R Packages
---
- stats