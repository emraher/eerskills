# Forbidden Patterns and Anti-Patterns

This document catalogs patterns that are **always forbidden** in production R code. These patterns indicate generic AI-generated code or poor practices that reduce code quality and maintainability.

## 1. Generic Variable Names

### FORBIDDEN: df, data, result, temp

These names provide no information about the data:

```r
# FORBIDDEN
df <- read.csv("customers.csv")
data <- filter(df, status == "active")
result <- summarize(data, mean_revenue = mean(revenue))
temp <- merge(result, other_data)
final <- arrange(temp, desc(mean_revenue))

# CORRECT
customer_data <- readr::read_csv("data/customers.csv")
active_customers <- customer_data |>
  dplyr::filter(status == "active")
revenue_summary <- active_customers |>
  dplyr::summarize(mean_revenue = mean(revenue))
merged_summary <- revenue_summary |>
  dplyr::left_join(regional_benchmarks, by = "region")
ranked_summary <- merged_summary |>
  dplyr::arrange(desc(mean_revenue))
```

### FORBIDDEN: Single-Letter Non-Math Variables

```r
# FORBIDDEN - unclear data structures
d <- read.csv("data.csv")
x <- filter(d, value > 0)
n <- nrow(x)
r <- x$value / x$population

# CORRECT
mortality_data <- readr::read_csv("data/mortality.csv")
valid_records <- mortality_data |>
  dplyr::filter(deaths > 0, population > 0)
record_count <- nrow(valid_records)
mortality_rates <- valid_records |>
  dplyr::mutate(rate_per_100k = (deaths / population) * 100000)

# ALLOWED - standard math notation
beta_hat <- solve(t(X) %*% X) %*% t(X) %*% y
for (i in 1:10) { print(i) }
```

### FORBIDDEN: output, new_*, final_*

```r
# FORBIDDEN
output <- calculate_statistics(data)
new_df <- mutate(output, x = y * 2)
final_result <- filter(new_df, x > 0)

# CORRECT
summary_statistics <- calculate_summary_stats(customer_data)
enriched_customers <- summary_statistics |>
  dplyr::mutate(revenue_score = revenue * 2)
high_value_customers <- enriched_customers |>
  dplyr::filter(revenue_score > threshold)
```

## 2. Implicit Returns

### FORBIDDEN: Functions Without Explicit return()

```r
# FORBIDDEN - implicit return
calculate_rate <- function(numerator, denominator) {
  numerator / denominator * 100000
}

# FORBIDDEN - multiple implicit branches
categorize_value <- function(x) {
  if (x > 100) {
    "high"
  } else if (x > 50) {
    "medium"
  } else {
    "low"
  }
}

# CORRECT - explicit returns
calculate_rate <- function(numerator, denominator) {
  rate <- (numerator / denominator) * 100000
  return(rate)
}

categorize_value <- function(x) {
  if (x > 100) {
    return("high")
  } else if (x > 50) {
    return("medium")
  } else {
    return("low")
  }
}
```

## 3. Missing Namespace Qualification

### FORBIDDEN: Unqualified External Functions

```r
# FORBIDDEN - requires library() calls, unclear origins
library(dplyr)
library(readr)
library(stringr)

data <- read_csv("data.csv")
result <- data %>%
  filter(value > 0) %>%
  mutate(clean_name = str_to_lower(name))

# CORRECT - explicit namespaces
customer_data <- readr::read_csv("data/customers.csv")
cleaned_customers <- customer_data |>
  dplyr::filter(revenue > 0) |>
  dplyr::mutate(clean_name = stringr::str_to_lower(customer_name))
```

### FORBIDDEN: attach()

```r
# FORBIDDEN - pollutes namespace, causes conflicts
attach(customer_data)
mean_revenue <- mean(revenue)
filtered <- subset(customer_data, age > 18)
detach(customer_data)

# CORRECT - explicit references
mean_revenue <- mean(customer_data$revenue)
filtered_customers <- customer_data |>
  dplyr::filter(age > 18)
```

## 4. Right-Hand Assignment

### FORBIDDEN: Using ->

```r
# FORBIDDEN - right-hand assignment
read.csv("data.csv") -> data
filter(data, x > 0) -> result
mean(result$x) -> avg

# CORRECT - left-hand assignment
data <- read.csv("data.csv")
result <- data |> dplyr::filter(x > 0)
avg <- mean(result$x)
```

## 5. Magrittr Pipe in Modern R

### FORBIDDEN: %>% When |> Available

```r
# FORBIDDEN - using magrittr pipe in R >= 4.1
library(magrittr)
result <- data %>%
  filter(x > 0) %>%
  mutate(y = x * 2)

# CORRECT - native pipe
result <- data |>
  dplyr::filter(x > 0) |>
  dplyr::mutate(y = x * 2)

# ACCEPTABLE - when needing advanced features
result <- data %>%
  lm(y ~ x, data = .)  # Dot in non-first position
```

## 6. Obvious Comments

### FORBIDDEN: Comments That Restate Code

```r
# FORBIDDEN - obvious comments
# Load the library
library(dplyr)

# Read the data
data <- read.csv("data.csv")

# Filter the data
filtered_data <- data |> filter(x > 0)

# Calculate the mean
mean_value <- mean(filtered_data$x)

# CORRECT - comments explain WHY, not WHAT
# Use log transformation to reduce right skew before standardization
log_values <- log(customer_revenue + 1)

# CDC standard population uses 2000 census; adjust for compatibility
standard_pop_2000 <- load_standard_population(year = 2000)

# Set seed for reproducible cross-validation splits
set.seed(20240121)
```

## 7. Generic Documentation

### FORBIDDEN: Circular @description

```r
# FORBIDDEN
#' Process Data
#'
#' This function processes the data.
#' @param data The data
#' @return The result
process_data <- function(data) { }

# CORRECT
#' Calculate age-adjusted mortality rates
#'
#' Computes mortality rates per 100,000 population, standardized to the
#' 2000 US Census age distribution using direct standardization.
#'
#' @param mortality_data Data frame with columns `age_group`, `deaths`, `population`
#' @return Numeric vector of age-adjusted rates per 100,000
calculate_age_adjusted_rate <- function(mortality_data) { }
```

### FORBIDDEN: Vague @param Descriptions

```r
# FORBIDDEN
#' @param data The data
#' @param x The x value
#' @param conf The confidence level
#' @param method The method to use

# CORRECT
#' @param mortality_data Data frame with columns:
#'   * `county`: County FIPS code (character)
#'   * `deaths`: Number of deaths (numeric, non-negative)
#'   * `population`: Population size (numeric, positive)
#' @param confidence_level Confidence level for interval estimation,
#'   must be between 0 and 1. Default is 0.95
#' @param method Standardization method, one of "direct" or "indirect".
#'   Default is "direct"
```

### FORBIDDEN: Empty or Generic @return

```r
# FORBIDDEN
#' @return The result
#' @return A data frame
#' @return

# CORRECT
#' @return A tibble with columns:
#'   \describe{
#'     \item{county}{County FIPS code}
#'     \item{adjusted_rate}{Age-adjusted mortality rate per 100,000}
#'     \item{std_error}{Standard error of the rate}
#'     \item{ci_lower}{Lower bound of 95% confidence interval}
#'     \item{ci_upper}{Upper bound of 95% confidence interval}
#'   }
```

## 8. Poor Error Handling

### FORBIDDEN: Silent Failures

```r
# FORBIDDEN - returns NULL silently
load_data <- function(path) {
  if (!file.exists(path)) {
    return(NULL)
  }
  read.csv(path)
}

# FORBIDDEN - prints error but continues
validate_data <- function(data) {
  if (nrow(data) == 0) {
    print("Warning: data is empty")
  }
  # Continues processing empty data
}

# CORRECT - informative errors
load_data <- function(path) {
  if (!file.exists(path)) {
    cli::cli_abort(
      "Data file not found: {.path {path}}",
      "i" = "Current directory: {.path {getwd()}}"
    )
  }
  readr::read_csv(path)
}

validate_data <- function(data) {
  if (nrow(data) == 0) {
    cli::cli_abort(
      "Input data is empty (0 rows)",
      "i" = "Expected data frame with at least 1 row"
    )
  }
  return(invisible(TRUE))
}
```

### FORBIDDEN: Bare try() Without Error Handling

```r
# FORBIDDEN
result <- try(risky_operation(), silent = TRUE)
if (inherits(result, "try-error")) {
  result <- NA
}

# CORRECT
result <- tryCatch(
  {
    risky_operation()
  },
  error = function(e) {
    cli::cli_warn(
      "Operation failed: {conditionMessage(e)}",
      "i" = "Returning NA"
    )
    return(NA)
  }
)
```

## 9. Missing Statistical Rigor

### FORBIDDEN: Point Estimates Without Uncertainty

```r
# FORBIDDEN - no SE, CI, or p-values
treatment_effect <- mean(treatment_group) - mean(control_group)
print(paste("Effect:", treatment_effect))

# CORRECT - comprehensive uncertainty reporting
estimate_treatment_effect <- function(treatment_group, control_group) {
  test_result <- t.test(treatment_group, control_group)

  effect_estimate <- diff(test_result$estimate)
  ci <- test_result$conf.int

  results <- tibble::tibble(
    estimate = effect_estimate,
    ci_lower = ci[1],
    ci_upper = ci[2],
    p_value = test_result$p.value,
    n_treatment = length(treatment_group),
    n_control = length(control_group)
  )

  return(results)
}
```

### FORBIDDEN: Ignoring Missing Data

```r
# FORBIDDEN - silent removal
clean_data <- data[complete.cases(data), ]

# CORRECT - explicit handling with reporting
clean_data <- function(data) {
  initial_n <- nrow(data)

  complete_data <- data[complete.cases(data), ]
  removed_n <- initial_n - nrow(complete_data)

  cli::cli_alert_warning(
    "Removed {removed_n} rows with missing values
    ({scales::percent(removed_n / initial_n)})"
  )

  if (removed_n / initial_n > 0.1) {
    cli::cli_alert_danger(
      "More than 10% of data has missing values.
      Consider imputation or sensitivity analysis."
    )
  }

  return(complete_data)
}
```

### FORBIDDEN: No Sample Sizes in Summaries

```r
# FORBIDDEN
summary_stats <- data |>
  group_by(category) |>
  summarize(mean_value = mean(value))

# CORRECT
summary_stats <- data |>
  dplyr::group_by(category) |>
  dplyr::summarize(
    n = dplyr::n(),
    mean_value = mean(value),
    std_error = sd(value) / sqrt(dplyr::n()),
    .groups = "drop"
  )
```

## 10. Non-Reproducible Code

### FORBIDDEN: No Seeds for Random Operations

```r
# FORBIDDEN
bootstrap_results <- replicate(1000, {
  sample_data <- data[sample(nrow(data), replace = TRUE), ]
  mean(sample_data$value)
})

# CORRECT
set.seed(20240121)
cli::cli_alert_info("Random seed: 20240121")

bootstrap_results <- replicate(1000, {
  sample_data <- data[sample(nrow(data), replace = TRUE), ]
  mean(sample_data$value)
})
```

### FORBIDDEN: Absolute Paths

```r
# FORBIDDEN
data <- read.csv("C:/Users/john/Documents/project/data.csv")
output_path <- "/home/john/project/output/"

# CORRECT
data <- readr::read_csv(here::here("data", "raw", "data.csv"))
output_path <- here::here("output")
```

### FORBIDDEN: Hardcoded System Dependencies

```r
# FORBIDDEN
setwd("C:/Users/john/project")
source("C:/Users/john/R/functions.R")
Sys.setenv(R_LIBS = "C:/R/library")

# CORRECT
# Use RStudio projects or here::here()
source(here::here("R", "functions.R"))
# Let R manage library paths
```

## 11. Bad Naming Conventions

### FORBIDDEN: camelCase or PascalCase

```r
# FORBIDDEN
customerData <- read.csv("data.csv")
CalculateRevenue <- function(x) { x * 1.2 }
totalRevenue <- sum(customerData$revenue)

# CORRECT
customer_data <- readr::read_csv("data/customers.csv")
calculate_revenue <- function(base_revenue) {
  adjusted_revenue <- base_revenue * 1.2
  return(adjusted_revenue)
}
total_revenue <- sum(customer_data$revenue)
```

### FORBIDDEN: Inconsistent Naming

```r
# FORBIDDEN - mixing conventions
customerData <- read.csv("customer_data.csv")
Total_Revenue <- sum(customerData$revenue)
calculate.rate <- function(x, y) { x / y }

# CORRECT - consistent snake_case
customer_data <- readr::read_csv("data/customer_data.csv")
total_revenue <- sum(customer_data$revenue)
calculate_rate <- function(numerator, denominator) {
  rate <- numerator / denominator
  return(rate)
}
```

## 12. Poor Function Design

### FORBIDDEN: Functions That Modify Global State

```r
# FORBIDDEN - modifies global variable
global_data <- NULL

load_data <- function(path) {
  global_data <<- read.csv(path)
}

# CORRECT - returns value
load_data <- function(path) {
  data <- readr::read_csv(path)
  return(data)
}
```

### FORBIDDEN: Functions With Side Effects Without Documentation

```r
# FORBIDDEN - undocumented side effect
process_data <- function(data) {
  # Silently writes to file
  write.csv(data, "output.csv")
  return(data)
}

# CORRECT - documented side effect
#' Process customer data and save to disk
#'
#' @param data Customer data frame
#' @param output_path Path for output CSV file
#' @return Processed data frame (invisibly)
#' @section Side Effects:
#' Writes processed data to CSV file at `output_path`
process_data <- function(data, output_path = "output/processed_data.csv") {
  processed <- data |>
    dplyr::filter(!is.na(revenue))

  readr::write_csv(processed, output_path)
  cli::cli_alert_success("Data saved to {.path {output_path}}")

  return(invisible(processed))
}
```

## 13. Inefficient Code

### FORBIDDEN: Growing Vectors in Loops

```r
# FORBIDDEN - very slow for large n
results <- c()
for (i in 1:10000) {
  results <- c(results, calculate_value(i))
}

# CORRECT - pre-allocate
results <- vector("numeric", length = 10000)
for (i in 1:10000) {
  results[i] <- calculate_value(i)
}

# BEST - vectorize or use functional programming
results <- purrr::map_dbl(1:10000, calculate_value)
```

### FORBIDDEN: Loops for Vectorizable Operations

```r
# FORBIDDEN - slow
for (i in 1:nrow(data)) {
  data$log_value[i] <- log(data$value[i])
  data$is_high[i] <- data$value[i] > 100
}

# CORRECT - vectorized
data <- data |>
  dplyr::mutate(
    log_value = log(value),
    is_high = value > 100
  )
```

## 14. Poor ggplot2 Practices

### FORBIDDEN: + at Start of Line

```r
# FORBIDDEN
ggplot(data, aes(x, y))
  + geom_point()
  + theme_minimal()

# CORRECT
ggplot2::ggplot(data, ggplot2::aes(x, y)) +
  ggplot2::geom_point() +
  ggplot2::theme_minimal()
```

### FORBIDDEN: Unnamed Aesthetics in Complex Plots

```r
# FORBIDDEN - unclear what arguments are
ggplot(data, aes(x, y, color, size)) +
  geom_point(0.5, 2)

# CORRECT - named arguments
ggplot2::ggplot(
  data = customer_data,
  mapping = ggplot2::aes(
    x = age,
    y = revenue,
    color = segment,
    size = tenure_years
  )
) +
  ggplot2::geom_point(alpha = 0.5, size = 2)
```

## 15. Pipeline Anti-Patterns

### FORBIDDEN: Overly Long Pipelines

```r
# FORBIDDEN - too many operations (>8), hard to debug
final_result <- raw_data |>
  filter(!is.na(value)) |>
  mutate(log_value = log(value)) |>
  group_by(category) |>
  mutate(category_mean = mean(log_value)) |>
  ungroup() |>
  mutate(centered = log_value - category_mean) |>
  filter(abs(centered) < 3) |>
  group_by(category, year) |>
  summarize(mean_centered = mean(centered)) |>
  pivot_wider(names_from = year, values_from = mean_centered) |>
  arrange(category) |>
  mutate(across(where(is.numeric), round, 2))

# CORRECT - broken into logical steps
cleaned_data <- raw_data |>
  dplyr::filter(!is.na(value)) |>
  dplyr::mutate(log_value = log(value))

centered_data <- cleaned_data |>
  dplyr::group_by(category) |>
  dplyr::mutate(
    category_mean = mean(log_value),
    centered = log_value - category_mean
  ) |>
  dplyr::ungroup() |>
  dplyr::filter(abs(centered) < 3)

summary_by_year <- centered_data |>
  dplyr::group_by(category, year) |>
  dplyr::summarize(mean_centered = mean(centered), .groups = "drop")

final_result <- summary_by_year |>
  tidyr::pivot_wider(names_from = year, values_from = mean_centered) |>
  dplyr::arrange(category) |>
  dplyr::mutate(across(where(is.numeric), round, digits = 2))
```

### FORBIDDEN: Pipe at Start of Line

```r
# FORBIDDEN
result <- data
  |> filter(x > 0)
  |> mutate(y = x * 2)

# CORRECT
result <- data |>
  dplyr::filter(x > 0) |>
  dplyr::mutate(y = x * 2)
```

## Summary: Quick Detection

Code likely contains "AI slop" if it has:

- [ ] Variables named `df`, `data`, `result`, `temp`, `final`
- [ ] Functions without explicit `return()`
- [ ] External functions without `::` namespace
- [ ] `attach()` or `->` operators
- [ ] Comments that restate what code does
- [ ] Generic documentation ("This function...", "@param data The data")
- [ ] Point estimates without SE/CI
- [ ] Random operations without `set.seed()`
- [ ] Absolute file paths
- [ ] camelCase or PascalCase instead of snake_case
- [ ] Growing vectors in loops
- [ ] Pipelines with >8 operations
- [ ] Missing data ignored silently

**If you see these patterns: refactor before committing.**
