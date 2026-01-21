# R Package Documentation Standards

## Roxygen2 Documentation Quality

All R package functions must have complete, specific roxygen2 documentation. Generic or circular documentation is forbidden.

## The Problem: Generic Documentation

### Forbidden Generic Patterns

These documentation patterns are **always forbidden**:

```r
# WRONG - circular description
#' Process Data
#'
#' This function processes the data.
#' @param data The data
#' @return The result
process_data <- function(data) { }

# WRONG - generic verbs without specifics
#' Calculate Values
#'
#' Calculates the values for the given input.
#' @param x Input values
#' @return Calculated values
calculate_values <- function(x) { }

# WRONG - "this function" phrasing
#' @description This function filters the dataset based on criteria
filter_data <- function(data, threshold) { }
```

## @description Tag

### Write Specific Descriptions

The description should explain **what the function does** in specific, actionable terms:

```r
# CORRECT - specific description
#' Calculate age-adjusted mortality rates
#'
#' Computes mortality rates per 100,000 population, standardized to the
#' 2000 US Census age distribution using direct standardization. Applies
#' the standard population weights to age-specific rates to enable
#' comparison across populations with different age structures.
#'
#' @param deaths Data frame with columns `age_group` and `count`
#' @param population Data frame with columns `age_group` and `pop_size`
#' @param standard_pop Data frame with standard population weights
#' @return Numeric vector of age-adjusted rates per 100,000
calculate_age_adjusted_rate <- function(deaths, population, standard_pop) {
  # Implementation
}

# WRONG - generic description
#' Calculate Rate
#'
#' This function calculates the rate from the provided data.
#'
#' @param deaths The death data
#' @param population The population data
#' @return The calculated rate
calculate_rate <- function(deaths, population) { }
```

### Avoid "This function" Phrasing

Start with an imperative verb or statement of what is computed:

```r
# CORRECT - imperative phrasing
#' Calculate customer lifetime value
#'
#' Estimates the net present value of all future revenue from a customer
#' using a discount rate and historical purchase patterns.

# CORRECT - statement of computation
#' Customer lifetime value
#'
#' Estimated net present value of future customer revenue.

# WRONG - "this function" phrasing
#' @description This function calculates customer lifetime value
```

## @param Descriptions

### Describe Structure and Constraints

Parameter documentation must specify:
1. **Data type** (data frame, numeric vector, character, etc.)
2. **Expected structure** (column names, dimensions, ranges)
3. **Constraints** (must be positive, length must match, etc.)

```r
# CORRECT - detailed parameter descriptions
#' @param mortality_data Data frame with columns:
#'   \describe{
#'     \item{county}{County FIPS code (character)}
#'     \item{age_group}{Age category: "0-19", "20-44", "45-64", "65+" (character)}
#'     \item{deaths}{Death count, must be non-negative (numeric)}
#'     \item{population}{Population size, must be positive (numeric)}
#'   }
#' @param confidence_level Confidence level for interval estimation,
#'   must be between 0 and 1. Default is 0.95 (numeric scalar)
#' @param standard_year Reference year for standard population, must be
#'   one of 1940, 1970, 2000. Default is 2000 (numeric scalar)

# WRONG - vague parameter descriptions
#' @param data The data
#' @param conf The confidence level
#' @param year The year
```

### Document Data Frame Structures

For data frame parameters, always document expected columns:

```r
# CORRECT - explicit structure
#' @param customer_data Data frame containing customer information with columns:
#'   * `customer_id`: Unique customer identifier (character)
#'   * `signup_date`: Date of customer signup (Date)
#'   * `total_revenue`: Cumulative revenue in dollars (numeric, >= 0)
#'   * `status`: Customer status, one of "active", "inactive", "churned" (character)

# WRONG - no structure specified
#' @param customer_data A data frame with customer information
```

### Optional Parameters

Clearly indicate optional parameters and their defaults:

```r
# CORRECT - clear optional parameters
#' @param na.rm Logical indicating whether to remove NA values before
#'   computation. If FALSE (default), NA values will cause the function
#'   to return NA
#' @param method Method for rate standardization, one of "direct" (default)
#'   or "indirect"
#' @param weights Optional numeric vector of weights, must have same length
#'   as input data. If NULL (default), equal weights are used

# WRONG - unclear defaults
#' @param na.rm Whether to remove NAs
#' @param method The method to use
#' @param weights The weights
```

## @return Documentation

### Specify Return Structure

Return value documentation must describe:
1. **Type** (data frame, numeric vector, list, etc.)
2. **Structure** (columns, names, dimensions)
3. **Units** (if applicable)

```r
# CORRECT - detailed return documentation
#' @return A tibble with one row per county containing:
#'   \describe{
#'     \item{county}{County FIPS code}
#'     \item{adjusted_rate}{Age-adjusted mortality rate per 100,000 population}
#'     \item{standard_error}{Standard error of the adjusted rate}
#'     \item{ci_lower}{Lower bound of 95% confidence interval}
#'     \item{ci_upper}{Upper bound of 95% confidence interval}
#'     \item{n_deaths}{Total number of deaths used in calculation}
#'   }

# CORRECT - simple return
#' @return Numeric vector of length n containing the calculated rates
#'   per 100,000 population. Returns NA for counties with population = 0

# WRONG - generic return
#' @return The result
#' @return A data frame with the results
#' @return The calculated values
```

### Document NULL and Error Cases

Explain when function returns NULL or throws errors:

```r
#' @return A list with elements `coefficients`, `std_errors`, and
#'   `r_squared`. Returns NULL if the model fails to converge or if
#'   the design matrix is singular
#'
#' @return Data frame of filtered records. Returns empty data frame (0 rows)
#'   if no records meet the criteria

# With error documentation
#' @return Numeric vector of predicted values
#' @section Errors:
#' The function will throw an error if:
#' * Input data contains missing values and `na.rm = FALSE`
#' * Predictor variables have zero variance
```

## Empty @return is Forbidden

**Never use empty or minimal @return tags**:

```r
# WRONG - empty return
#' @return

# WRONG - minimal return
#' @return Results

# CORRECT - specific return
#' @return Numeric vector of length 1 containing the mean absolute error,
#'   or NA if predictions and actuals have different lengths
```

## Over-Documentation: Avoid It

### Don't Over-Document Simple Functions

Simple accessor or wrapper functions don't need elaborate documentation:

```r
# CORRECT - concise for simple function
#' Extract customer IDs
#'
#' @param data Data frame with `customer_id` column
#' @return Character vector of customer IDs
get_customer_ids <- function(data) {
  return(data$customer_id)
}

# WRONG - over-documented simple function
#' Extract Customer IDs from Data Frame
#'
#' This function extracts the customer ID column from a data frame and
#' returns it as a vector. The customer IDs are unique identifiers that
#' can be used to track individual customers across multiple datasets.
#' This is particularly useful when joining data from different sources
#' or when performing customer-level analysis...
#'
#' @param data A data frame object containing customer information. Must
#'   include a column named `customer_id` which contains the unique
#'   identifier for each customer in the dataset. This column should be
#'   of type character or could be numeric depending on your ID scheme...
#' @return A vector of customer IDs extracted from the input data frame.
#'   The return type will match the type of the `customer_id` column...
get_customer_ids <- function(data) {
  return(data$customer_id)
}
```

### Match Detail Level to Complexity

```r
# Simple function - brief documentation
#' Check if file exists and is readable
#' @param path File path to check
#' @return Logical TRUE if file exists and is readable, FALSE otherwise
file_is_readable <- function(path) {
  return(file.exists(path) && file.access(path, 4) == 0)
}

# Complex function - detailed documentation
#' Fit hierarchical Bayesian model with spatial random effects
#'
#' Estimates a Bayesian hierarchical model with spatially correlated
#' random effects using INLA (Integrated Nested Laplace Approximation).
#' The model includes fixed effects for covariates and spatial effects
#' modeled through a conditional autoregressive (CAR) prior based on
#' the neighborhood structure defined by the adjacency matrix.
#'
#' @param formula Model formula for fixed effects, e.g., `y ~ x1 + x2`
#' @param data Data frame containing response and predictor variables
#' @param adjacency_matrix Sparse matrix defining neighborhood structure,
#'   must be symmetric with dimensions matching number of spatial units
#' @param family Distribution family, one of "gaussian", "poisson", "binomial"
#' @param priors Named list with prior specifications for `fixed`, `spatial_tau`,
#'   and `observation_tau` parameters. See Details for default priors
#' @return A list of class "spatial_inla_fit" containing model fit,
#'   parameter estimates, DIC, and spatial predictions
fit_spatial_model <- function(formula, data, adjacency_matrix,
                               family = "gaussian", priors = NULL) {
  # Complex implementation
}
```

## @examples Best Practices

### Write Realistic, Runnable Examples

Examples should:
1. **Run without error** (unless demonstrating error handling)
2. **Use realistic data** (not just `1:10` and `letters[1:3]`)
3. **Show actual use cases**
4. **Include expected output** as comments

```r
# CORRECT - realistic, runnable example
#' @examples
#' # Calculate age-adjusted rates for sample counties
#' mortality_data <- data.frame(
#'   county = rep(c("County_A", "County_B"), each = 4),
#'   age_group = rep(c("0-19", "20-44", "45-64", "65+"), 2),
#'   deaths = c(15, 45, 120, 380, 12, 38, 95, 290),
#'   population = c(25000, 35000, 28000, 12000, 20000, 30000, 22000, 9000)
#' )
#'
#' standard_pop <- data.frame(
#'   age_group = c("0-19", "20-44", "45-64", "65+"),
#'   weight = c(0.35, 0.35, 0.20, 0.10)
#' )
#'
#' adjusted_rates <- calculate_age_adjusted_rate(
#'   mortality_data,
#'   standard_pop
#' )
#'
#' # Expected output:
#' # County_A: 185.2 per 100,000
#' # County_B: 172.8 per 100,000
#'
#' print(adjusted_rates)

# WRONG - toy example
#' @examples
#' x <- 1:10
#' y <- letters[1:3]
#' result <- my_function(x, y)
```

### Show Multiple Use Cases

For functions with options, show different parameter combinations:

```r
#' @examples
#' # Basic usage with defaults
#' model <- fit_model(y ~ x, data = sample_data)
#'
#' # With robust standard errors
#' model_robust <- fit_model(
#'   y ~ x + z,
#'   data = sample_data,
#'   se_type = "robust"
#' )
#'
#' # With clustering
#' model_clustered <- fit_model(
#'   y ~ x + z,
#'   data = sample_data,
#'   cluster_var = "group_id"
#' )
```

### Use \dontrun{} Sparingly

Only use `\dontrun{}` for examples that:
- Require external data not in package
- Take very long to run
- Require authentication or network access

```r
#' @examples
#' # Basic example (runs during R CMD check)
#' result <- calculate_statistic(sample_data)
#'
#' \dontrun{
#' # Example requiring external data
#' large_dataset <- read.csv("path/to/large/file.csv")
#' result <- calculate_statistic(large_dataset)
#' }
```

### Mark Slow Examples with \donttest{}

Use `\donttest{}` for examples that are correct but slow:

```r
#' @examples
#' # Fast example
#' quick_result <- analyze_subset(small_data)
#'
#' \donttest{
#' # Slow example (skipped on CRAN but runs in examples())
#' full_result <- analyze_complete_dataset(large_data)
#' }
```

## Comments and Documentation

### Section Headers in Code

Use clear section headers with roxygen-style formatting:

```r
# Data Import and Validation -----------------------------------------------

raw_data <- readr::read_csv("data/input.csv")

validated_data <- raw_data |>
  dplyr::filter(!is.na(value))

# Feature Engineering ------------------------------------------------------

feature_data <- validated_data |>
  dplyr::mutate(
    log_value = log(value + 1),
    squared_value = value^2
  )

# Model Fitting ------------------------------------------------------------

model <- lm(outcome ~ log_value + squared_value, data = feature_data)
```

### Inline Comments: Document WHY, Not WHAT

Comments should explain **why** code exists, not **what** it does:

```r
# CORRECT - explains WHY
# Use log transformation to reduce skewness before standardization
log_values <- log(values + 1)

# Add 1 to population to avoid division by zero for uninhabited areas
rate <- deaths / (population + 1) * 100000

# Set seed for reproducible cross-validation splits
set.seed(20240121)

# WRONG - restates WHAT code does (obvious)
# Calculate the mean
mean_value <- mean(values)

# Filter data where x is greater than 0
filtered_data <- data |> dplyr::filter(x > 0)

# Create new column
data$new_col <- data$old_col * 2
```

### Document Complex Logic

Add comments for non-obvious algorithms or business logic:

```r
# CORRECT - documents complex logic
# Age-adjusted rate using direct standardization:
# 1. Calculate age-specific rates for each stratum
# 2. Multiply each rate by corresponding standard population weight
# 3. Sum weighted rates to get age-adjusted rate
age_adjusted_rate <- sum(age_specific_rates * standard_weights)

# Winsorize outliers at 1st and 99th percentiles rather than removing
# to preserve sample size while reducing impact of extreme values
lower_bound <- quantile(values, 0.01)
upper_bound <- quantile(values, 0.99)
winsorized_values <- pmax(pmin(values, upper_bound), lower_bound)
```

### Document Data Quirks and Workarounds

```r
# CDC data uses age_group = "85+" but our standard population uses "85-99"
# and "100+". Combine the two standard population groups to match CDC.
standard_pop_adjusted <- standard_pop |>
  dplyr::mutate(
    age_group = dplyr::if_else(
      age_group %in% c("85-99", "100+"),
      "85+",
      age_group
    )
  ) |>
  dplyr::group_by(age_group) |>
  dplyr::summarize(weight = sum(weight), .groups = "drop")

# Some counties have missing population data for 2023. Use 2022 population
# with 0.5% growth adjustment based on state average growth rate.
population_filled <- population |>
  dplyr::mutate(
    pop_2023 = dplyr::if_else(
      is.na(pop_2023),
      pop_2022 * 1.005,
      pop_2023
    )
  )
```

## Package-Level Documentation

### DESCRIPTION File Quality

Ensure the DESCRIPTION file has specific, informative content:

```
# CORRECT
Package: epidemiology
Title: Age-Adjusted Mortality Rate Calculation for County-Level Data
Description: Calculates age-adjusted mortality rates using direct and
    indirect standardization methods. Provides functions for spatial
    smoothing of rates, calculation of confidence intervals, and
    visualization of county-level patterns. Implements CDC and WHO
    standard population definitions.
Authors@R: person("First", "Last", email = "email@domain.com",
    role = c("aut", "cre"))
License: MIT + file LICENSE
Encoding: UTF-8
Roxygen: list(markdown = TRUE)
RoxygenNote: 7.2.3

# WRONG
Package: epidemiology
Title: Epidemiology Functions
Description: Functions for epidemiology analysis.
Author: Person Name
Maintainer: Person Name <email@domain.com>
```

### README.md Sections

A good package README should include:

1. **Overview** - What does the package do?
2. **Installation** - How to install
3. **Quick Example** - Minimal working example
4. **Key Features** - Main functionality
5. **Documentation** - Link to detailed docs
6. **Citation** - How to cite (for academic packages)

```markdown
# CORRECT README structure

# epidemiology

Calculate age-adjusted mortality rates for county-level data using CDC
standard populations.

## Installation

```r
# Install from GitHub
remotes::install_github("username/epidemiology")
```

## Quick Example

```r
library(epidemiology)

# Load sample mortality data
data(county_mortality)

# Calculate age-adjusted rates
adjusted_rates <- calculate_age_adjusted_rate(
  county_mortality,
  standard_year = 2000
)

# Plot results
plot_county_rates(adjusted_rates)
```

## Features

- Direct and indirect age standardization
- Confidence interval calculation
- Spatial smoothing for small areas
- Built-in standard populations (CDC 1940, 1970, 2000)
```

## Summary Checklist

Before releasing package documentation:

- [ ] No circular descriptions ("This function does X" → "Does X")
- [ ] No generic @param ("The data" → "Data frame with columns X, Y, Z")
- [ ] All @return tags specify structure and type
- [ ] @examples are realistic and runnable
- [ ] Complex logic has WHY comments
- [ ] Section headers for code organization
- [ ] DESCRIPTION file is specific
- [ ] README has working examples
- [ ] No "this function" phrasing in descriptions
- [ ] Data frame parameters document expected columns
- [ ] Return values document units where applicable
