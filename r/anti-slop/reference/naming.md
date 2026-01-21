# Naming Conventions and Variable Standards

## Core Naming Rules

### 1. Always Use snake_case

All R objects must use `snake_case` naming:

```r
# CORRECT - snake_case for everything
customer_data <- readr::read_csv("customers.csv")
revenue_total <- calculate_total_revenue(customer_data)
active_customers <- filter_active(customer_data)

calculate_growth_rate <- function(initial_value, final_value, periods) {
  growth_rate <- (final_value / initial_value)^(1 / periods) - 1
  return(growth_rate)
}

# WRONG - camelCase or PascalCase
customerData <- read.csv("customers.csv")
revenueTotal <- calculateTotalRevenue(customerData)
CustomerData <- read.csv("customers.csv")
```

**Applies to**:
- Variables: `customer_lifetime_value`
- Functions: `calculate_age_adjusted_rate`
- Function arguments: `input_data`, `threshold_value`
- Data frame columns: `age_group`, `revenue_2023`

### 2. Explicit Returns

**ALWAYS use explicit `return()` statements** - never rely on implicit returns.

```r
# CORRECT - explicit return
calculate_rate <- function(numerator, denominator) {
  if (denominator == 0) {
    return(NA_real_)
  }

  rate <- numerator / denominator
  return(rate)
}

# WRONG - implicit return
calculate_rate <- function(numerator, denominator) {
  numerator / denominator  # implicit, hard to track
}

# WRONG - multiple implicit branches
calculate_rate <- function(numerator, denominator) {
  if (denominator == 0) {
    NA_real_
  } else {
    numerator / denominator
  }
}
```

**Why explicit returns matter**:
- Makes function exits obvious
- Easier to debug
- Clearer for code review
- Reduces confusion about what's returned

**Multiple return points are OK** when they improve clarity:

```r
# CORRECT - early returns for validation
process_data <- function(data, threshold) {
  if (nrow(data) == 0) {
    return(NULL)
  }

  if (!all(c("id", "value") %in% names(data))) {
    return(NULL)
  }

  filtered_data <- data |>
    dplyr::filter(value > threshold)

  return(filtered_data)
}
```

## Forbidden Generic Names

### Never Use These Names

These generic names are **always forbidden** in production code:

| Forbidden | Why | Use Instead |
|-----------|-----|-------------|
| `df` | Generic, unhelpful | `customer_data`, `sales_records` |
| `data` | Too vague | `mortality_data`, `survey_responses` |
| `result` | Meaningless | `filtered_customers`, `summary_stats` |
| `temp` | Indicates poor planning | Descriptive intermediate name |
| `output` | What kind of output? | `formatted_table`, `plot_data` |
| `final` | Final what? | `cleaned_data`, `merged_results` |
| `new_df` | Generic derivative | `aggregated_sales`, `monthly_totals` |

### Examples of Good Names

```r
# CORRECT - descriptive names
mortality_data <- readr::read_csv("data/mortality.csv")

age_standardized_rates <- mortality_data |>
  dplyr::group_by(county, age_group) |>
  dplyr::summarize(
    deaths = sum(death_count),
    population = sum(pop_size),
    .groups = "drop"
  )

county_summary <- age_standardized_rates |>
  dplyr::group_by(county) |>
  dplyr::summarize(
    total_deaths = sum(deaths),
    crude_rate = sum(deaths) / sum(population) * 100000,
    .groups = "drop"
  )

# WRONG - generic names
df <- read.csv("data/mortality.csv")
result <- df |>
  group_by(county, age_group) |>
  summarize(deaths = sum(death_count))
final <- result |>
  group_by(county) |>
  summarize(total = sum(deaths))
```

## Single-Letter Variables

### When Single Letters Are Allowed

Single-letter variables are **only acceptable** in these contexts:

1. **Standard mathematical notation**:
```r
# CORRECT - recognized math conventions
fit_linear_model <- function(X, y) {
  beta_hat <- solve(t(X) %*% X) %*% t(X) %*% y
  return(beta_hat)
}

# Matrix algebra
A <- matrix(c(1, 2, 3, 4), nrow = 2)
b <- c(5, 6)
x <- solve(A, b)

# Loop counters in simple iterations
for (i in 1:10) {
  print(i)
}
```

2. **Anonymous function arguments** (in simple cases):
```r
# CORRECT - simple lambda
customer_data |>
  purrr::map_dbl(~ mean(.x, na.rm = TRUE))

# But prefer descriptive names for anything complex
customer_data |>
  purrr::map_dfr(function(column) {
    tibble::tibble(
      mean = mean(column, na.rm = TRUE),
      sd = sd(column, na.rm = TRUE)
    )
  })
```

### When Single Letters Are Forbidden

```r
# WRONG - unclear data structures
d <- readr::read_csv("data.csv")
x <- d |> filter(status == "active")
n <- nrow(x)

# CORRECT
customer_data <- readr::read_csv("data/customers.csv")
active_customers <- customer_data |>
  dplyr::filter(status == "active")
active_customer_count <- nrow(active_customers)

# WRONG - ambiguous function parameters
calculate_stats <- function(x, n, p) {
  # What are x, n, and p?
}

# CORRECT
calculate_binomial_ci <- function(successes, trials, confidence_level) {
  # Clear what each parameter represents
}
```

## Descriptive Intermediate Variables

Break complex operations into well-named steps:

```r
# CORRECT - clear intermediate steps
raw_mortality_data <- readr::read_csv("data/mortality_2023.csv")

validated_mortality_data <- raw_mortality_data |>
  dplyr::filter(
    !is.na(deaths),
    !is.na(population),
    age_group %in% c("0-19", "20-44", "45-64", "65+")
  )

age_specific_rates <- validated_mortality_data |>
  dplyr::mutate(
    rate_per_100k = (deaths / population) * 100000
  )

age_adjusted_rates <- age_specific_rates |>
  dplyr::left_join(standard_population, by = "age_group") |>
  dplyr::group_by(county) |>
  dplyr::summarize(
    adjusted_rate = sum(rate_per_100k * weight),
    .groups = "drop"
  )

# WRONG - unclear pipeline
df <- read.csv("data/mortality_2023.csv")
result <- df |>
  filter(!is.na(deaths), !is.na(population)) |>
  mutate(rate = deaths / population * 100000) |>
  left_join(std_pop, by = "age_group") |>
  group_by(county) |>
  summarize(adj_rate = sum(rate * weight))
```

## Function Naming

### Function Name Patterns

Use verb-noun patterns that describe what the function does:

```r
# CORRECT - verb_noun pattern
calculate_mortality_rate <- function(deaths, population) {
  rate <- (deaths / population) * 100000
  return(rate)
}

filter_active_customers <- function(customer_data, cutoff_date) {
  active <- customer_data |>
    dplyr::filter(last_purchase >= cutoff_date)
  return(active)
}

validate_data_structure <- function(data, required_columns) {
  missing <- setdiff(required_columns, names(data))
  if (length(missing) > 0) {
    cli::cli_abort("Missing columns: {.field {missing}}")
  }
  return(invisible(TRUE))
}

# WRONG - vague function names
process_data <- function(data) { }  # Process how?
handle_results <- function(x) { }   # Handle how?
do_calculation <- function(a, b) { } # What calculation?
```

### Boolean Function Names

Functions returning TRUE/FALSE should use `is_*`, `has_*`, or `can_*`:

```r
# CORRECT - clear boolean functions
is_valid_date <- function(date_string) {
  parsed_date <- lubridate::ymd(date_string, quiet = TRUE)
  return(!is.na(parsed_date))
}

has_missing_values <- function(data) {
  any_missing <- any(is.na(data))
  return(any_missing)
}

can_merge_datasets <- function(data1, data2, by_column) {
  has_column <- by_column %in% names(data1) && by_column %in% names(data2)
  return(has_column)
}

# WRONG - ambiguous return type
valid_date <- function(date_string) { }  # Returns what?
missing_values <- function(data) { }     # Logical or count?
```

## Argument Naming

### Function Arguments

Arguments should be descriptive and use `snake_case`:

```r
# CORRECT
calculate_confidence_interval <- function(
  point_estimate,
  standard_error,
  confidence_level = 0.95,
  distribution = "normal"
) {
  # Implementation
}

# WRONG
calculate_confidence_interval <- function(est, se, conf = 0.95, dist = "normal") {
  # Abbreviated arguments hard to read
}
```

### Data Arguments

For functions that take data frames, be specific:

```r
# CORRECT - specific data argument names
calculate_age_adjusted_rate <- function(
  mortality_data,
  standard_population,
  stratification_vars = c("county", "year")
) {
  # Clear what each dataset represents
}

# WRONG - generic 'data' argument
calculate_age_adjusted_rate <- function(data, standard, vars) {
  # Unclear what 'data' contains
}
```

## Constants and Configuration

Use UPPERCASE_SNAKE_CASE for true constants:

```r
# CORRECT - constants
MAX_ITERATIONS <- 1000
DEFAULT_CONFIDENCE_LEVEL <- 0.95
STANDARD_POPULATION_YEAR <- 2000

# Regular variables
max_iterations <- 1000  # Not a constant, can be changed
```

## Column Name Conventions

When creating or modifying data frame columns:

```r
# CORRECT - descriptive column names
customer_data |>
  dplyr::mutate(
    revenue_per_customer = total_revenue / customer_count,
    is_high_value = revenue_per_customer > 1000,
    customer_segment = dplyr::case_when(
      revenue_per_customer > 5000 ~ "premium",
      revenue_per_customer > 1000 ~ "standard",
      TRUE ~ "basic"
    )
  )

# WRONG - abbreviated or generic names
customer_data |>
  mutate(
    rpc = total_revenue / customer_count,
    flag = rpc > 1000,
    seg = case_when(...)
  )
```

## Summary Checklist

Before committing code, verify:

- [ ] All variables use `snake_case`
- [ ] All functions have explicit `return()` statements
- [ ] No generic names: `df`, `data`, `result`, `temp`
- [ ] Single letters only for standard math notation or simple loops
- [ ] Function names follow verb-noun pattern
- [ ] Boolean functions use `is_*`, `has_*`, or `can_*`
- [ ] Function arguments are descriptive, not abbreviated
- [ ] Constants use UPPERCASE_SNAKE_CASE
- [ ] Column names are clear and specific
