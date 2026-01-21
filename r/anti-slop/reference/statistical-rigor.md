# Statistical Rigor and Reproducibility

## Data Validation

### Always Validate Input Data

Every analysis must validate data structure and assumptions before proceeding:

```r
# CORRECT - comprehensive validation
validate_mortality_data <- function(data) {
  # Check required columns exist
  required_cols <- c("county", "age_group", "deaths", "population")
  missing_cols <- setdiff(required_cols, names(data))

  if (length(missing_cols) > 0) {
    cli::cli_abort(
      "Missing required columns: {.field {missing_cols}}"
    )
  }

  # Check data types
  if (!is.numeric(data$deaths)) {
    cli::cli_abort(
      "Column {.field deaths} must be numeric, got {.cls {class(data$deaths)}}"
    )
  }

  # Check value constraints
  if (any(data$deaths < 0, na.rm = TRUE)) {
    cli::cli_abort("Column {.field deaths} contains negative values")
  }

  if (any(data$population <= 0, na.rm = TRUE)) {
    cli::cli_warn(
      "Column {.field population} contains zero or negative values"
    )
  }

  # Check for expected categories
  valid_age_groups <- c("0-19", "20-44", "45-64", "65+")
  invalid_ages <- setdiff(unique(data$age_group), valid_age_groups)

  if (length(invalid_ages) > 0) {
    cli::cli_abort(
      "Invalid age groups: {.val {invalid_ages}}.
      Expected: {.val {valid_age_groups}}"
    )
  }

  return(invisible(TRUE))
}

# WRONG - no validation, assumes data is clean
calculate_rate <- function(data) {
  result <- data$deaths / data$population * 100000
  return(result)
}
```

### Use stopifnot() for Assertions

For simple checks, use `stopifnot()`:

```r
# CORRECT - explicit assertions
calculate_confidence_interval <- function(estimate, std_error,
                                          confidence_level = 0.95) {
  stopifnot(
    "estimate must be numeric" = is.numeric(estimate),
    "std_error must be positive" = is.numeric(std_error) && all(std_error > 0),
    "confidence_level must be between 0 and 1" =
      confidence_level > 0 && confidence_level < 1
  )

  z_score <- qnorm(1 - (1 - confidence_level) / 2)
  ci_lower <- estimate - z_score * std_error
  ci_upper <- estimate + z_score * std_error

  return(list(lower = ci_lower, upper = ci_upper))
}
```

### Document Data Transformations and Loss

Always document when data is filtered or modified:

```r
# CORRECT - reports data loss
clean_customer_data <- function(customer_data, min_purchases = 1) {
  initial_rows <- nrow(customer_data)

  # Remove records with missing revenue
  complete_data <- customer_data |>
    dplyr::filter(!is.na(revenue))

  missing_revenue <- initial_rows - nrow(complete_data)

  # Remove customers below purchase threshold
  filtered_data <- complete_data |>
    dplyr::filter(total_purchases >= min_purchases)

  excluded_customers <- nrow(complete_data) - nrow(filtered_data)

  # Report data loss
  cli::cli_alert_info(
    "Removed {missing_revenue} rows with missing revenue
    ({scales::percent(missing_revenue/initial_rows)})"
  )
  cli::cli_alert_info(
    "Excluded {excluded_customers} customers with < {min_purchases} purchases
    ({scales::percent(excluded_customers/initial_rows)})"
  )
  cli::cli_alert_success(
    "Final dataset: {nrow(filtered_data)} rows
    ({scales::percent(nrow(filtered_data)/initial_rows)} retained)"
  )

  return(filtered_data)
}

# WRONG - silent data filtering
clean_customer_data <- function(customer_data) {
  result <- customer_data |>
    filter(!is.na(revenue), total_purchases >= 1)
  return(result)
}
```

## Missing Data Handling

### Explicit Missing Data Strategy

Never ignore missing data without documentation. Choose and document a strategy:

#### 1. Complete Case Analysis

```r
# CORRECT - explicit complete case analysis
analyze_complete_cases <- function(data) {
  initial_n <- nrow(data)

  # Remove rows with any missing values
  complete_data <- na.omit(data)
  final_n <- nrow(complete_data)

  pct_removed <- (initial_n - final_n) / initial_n

  cli::cli_alert_warning(
    "Complete case analysis: removed {initial_n - final_n} rows
    ({scales::percent(pct_removed)}) with missing data"
  )

  if (pct_removed > 0.10) {
    cli::cli_alert_danger(
      "More than 10% of data removed. Consider multiple imputation or
      sensitivity analysis."
    )
  }

  return(complete_data)
}
```

#### 2. Imputation

```r
# CORRECT - documented imputation
impute_missing_values <- function(data, method = "median") {
  numeric_cols <- names(data)[sapply(data, is.numeric)]

  imputed_data <- data
  imputation_summary <- list()

  for (col in numeric_cols) {
    n_missing <- sum(is.na(data[[col]]))

    if (n_missing > 0) {
      if (method == "median") {
        impute_value <- median(data[[col]], na.rm = TRUE)
      } else if (method == "mean") {
        impute_value <- mean(data[[col]], na.rm = TRUE)
      }

      imputed_data[[col]][is.na(data[[col]])] <- impute_value

      imputation_summary[[col]] <- list(
        n_missing = n_missing,
        pct_missing = n_missing / nrow(data),
        impute_value = impute_value
      )

      cli::cli_alert_info(
        "Imputed {n_missing} missing values in {.field {col}}
        with {method} = {round(impute_value, 2)}"
      )
    }
  }

  attr(imputed_data, "imputation_summary") <- imputation_summary
  return(imputed_data)
}
```

#### 3. Sensitivity Analysis

```r
# CORRECT - sensitivity analysis for missing data
sensitivity_to_missing <- function(data, outcome_var, predictor_var) {
  # Complete case analysis
  complete_results <- data |>
    tidyr::drop_na(all_of(c(outcome_var, predictor_var))) |>
    summarize(
      correlation = cor(!!sym(outcome_var), !!sym(predictor_var)),
      method = "complete_case"
    )

  # Mean imputation
  mean_imputed <- data |>
    mutate(
      across(
        all_of(c(outcome_var, predictor_var)),
        ~ if_else(is.na(.x), mean(.x, na.rm = TRUE), .x)
      )
    )

  mean_results <- mean_imputed |>
    summarize(
      correlation = cor(!!sym(outcome_var), !!sym(predictor_var)),
      method = "mean_imputation"
    )

  # Combine results
  sensitivity_results <- bind_rows(complete_results, mean_results)

  return(sensitivity_results)
}
```

### Report Missing Data Patterns

```r
# CORRECT - comprehensive missing data report
report_missing_data <- function(data) {
  # Overall missing
  total_cells <- nrow(data) * ncol(data)
  missing_cells <- sum(is.na(data))
  pct_missing_overall <- missing_cells / total_cells

  cli::cli_h1("Missing Data Report")
  cli::cli_alert_info(
    "Total missing: {missing_cells} / {total_cells} cells
    ({scales::percent(pct_missing_overall)})"
  )

  # By column
  col_missing <- data |>
    purrr::map_df(~ sum(is.na(.x))) |>
    tidyr::pivot_longer(everything(), names_to = "column", values_to = "n_missing") |>
    dplyr::mutate(
      pct_missing = n_missing / nrow(data),
      complete = nrow(data) - n_missing
    ) |>
    dplyr::arrange(desc(pct_missing))

  cli::cli_h2("Missing by Column")
  print(col_missing)

  # Rows with any missing
  rows_with_missing <- sum(apply(data, 1, function(x) any(is.na(x))))
  complete_rows <- nrow(data) - rows_with_missing

  cli::cli_alert_info(
    "Complete rows: {complete_rows} / {nrow(data)}
    ({scales::percent(complete_rows / nrow(data))})"
  )

  return(invisible(col_missing))
}
```

## Statistical Rigor

### Always Report Uncertainty

Never report point estimates without measures of uncertainty:

```r
# CORRECT - reports estimate with SE and CI
estimate_treatment_effect <- function(treatment_group, control_group) {
  # Point estimates
  mean_treatment <- mean(treatment_group)
  mean_control <- mean(control_group)
  effect_estimate <- mean_treatment - mean_control

  # Standard errors
  se_treatment <- sd(treatment_group) / sqrt(length(treatment_group))
  se_control <- sd(control_group) / sqrt(length(control_group))
  se_difference <- sqrt(se_treatment^2 + se_control^2)

  # Confidence interval
  ci_95 <- effect_estimate + c(-1, 1) * qnorm(0.975) * se_difference

  # T-test for p-value
  test_result <- t.test(treatment_group, control_group)

  # Return comprehensive results
  results <- list(
    estimate = effect_estimate,
    std_error = se_difference,
    ci_lower = ci_95[1],
    ci_upper = ci_95[2],
    p_value = test_result$p.value,
    n_treatment = length(treatment_group),
    n_control = length(control_group)
  )

  return(results)
}

# WRONG - only point estimate
estimate_treatment_effect <- function(treatment_group, control_group) {
  effect <- mean(treatment_group) - mean(control_group)
  return(effect)
}
```

### Report Sample Sizes

Always include sample sizes in statistical summaries:

```r
# CORRECT - includes sample sizes
summarize_by_group <- function(data, group_var, value_var) {
  summary_stats <- data |>
    dplyr::group_by(!!sym(group_var)) |>
    dplyr::summarize(
      n = dplyr::n(),
      mean = mean(!!sym(value_var), na.rm = TRUE),
      std_error = sd(!!sym(value_var), na.rm = TRUE) / sqrt(dplyr::n()),
      median = median(!!sym(value_var), na.rm = TRUE),
      q25 = quantile(!!sym(value_var), 0.25, na.rm = TRUE),
      q75 = quantile(!!sym(value_var), 0.75, na.rm = TRUE),
      .groups = "drop"
    )

  return(summary_stats)
}

# WRONG - no sample sizes
summarize_by_group <- function(data, group_var, value_var) {
  summary_stats <- data |>
    group_by(!!sym(group_var)) |>
    summarize(
      mean = mean(!!sym(value_var)),
      median = median(!!sym(value_var))
    )
  return(summary_stats)
}
```

### Check Model Assumptions

Always validate statistical model assumptions:

```r
# CORRECT - checks regression assumptions
check_lm_assumptions <- function(model, data) {
  # Extract residuals and fitted values
  residuals <- residuals(model)
  fitted <- fitted(model)

  # 1. Linearity - residuals vs fitted
  linearity_plot <- ggplot2::ggplot(
    data = NULL,
    ggplot2::aes(x = fitted, y = residuals)
  ) +
    ggplot2::geom_point(alpha = 0.5) +
    ggplot2::geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
    ggplot2::geom_smooth(se = FALSE) +
    ggplot2::labs(
      title = "Residuals vs Fitted",
      x = "Fitted Values",
      y = "Residuals"
    )

  # 2. Normality - Q-Q plot
  qq_plot <- ggplot2::ggplot(
    data = NULL,
    ggplot2::aes(sample = residuals)
  ) +
    ggplot2::stat_qq() +
    ggplot2::stat_qq_line(color = "red") +
    ggplot2::labs(title = "Normal Q-Q Plot")

  # 3. Homoscedasticity - scale-location plot
  scale_location_plot <- ggplot2::ggplot(
    data = NULL,
    ggplot2::aes(x = fitted, y = sqrt(abs(residuals)))
  ) +
    ggplot2::geom_point(alpha = 0.5) +
    ggplot2::geom_smooth(se = FALSE) +
    ggplot2::labs(
      title = "Scale-Location Plot",
      x = "Fitted Values",
      y = "√|Residuals|"
    )

  # 4. Statistical tests
  # Shapiro-Wilk test for normality (if n < 5000)
  if (length(residuals) < 5000) {
    normality_test <- shapiro.test(residuals)
    cli::cli_alert_info(
      "Shapiro-Wilk test for normality: p = {round(normality_test$p.value, 4)}"
    )
  }

  # Breusch-Pagan test for heteroscedasticity
  bp_test <- lmtest::bptest(model)
  cli::cli_alert_info(
    "Breusch-Pagan test for heteroscedasticity: p = {round(bp_test$p.value, 4)}"
  )

  # Return diagnostic plots
  diagnostic_plots <- list(
    linearity = linearity_plot,
    normality = qq_plot,
    homoscedasticity = scale_location_plot
  )

  return(diagnostic_plots)
}
```

## Reproducibility

### Set Seeds for Random Operations

**Always set seeds before any random or stochastic operation**:

```r
# CORRECT - seed set before random operations
perform_bootstrap_analysis <- function(data, n_bootstrap = 1000) {
  # Set seed for reproducibility
  set.seed(20240121)

  cli::cli_alert_info("Random seed set to 20240121 for reproducibility")

  bootstrap_results <- replicate(n_bootstrap, {
    # Resample with replacement
    boot_sample <- data[sample(nrow(data), replace = TRUE), ]

    # Calculate statistic
    mean(boot_sample$value)
  })

  return(bootstrap_results)
}

# CORRECT - seed for cross-validation
perform_cross_validation <- function(data, formula, k_folds = 5) {
  set.seed(20240121)

  # Create folds
  fold_ids <- sample(rep(1:k_folds, length.out = nrow(data)))

  cv_results <- purrr::map_dbl(1:k_folds, function(fold) {
    train_data <- data[fold_ids != fold, ]
    test_data <- data[fold_ids == fold, ]

    model <- lm(formula, data = train_data)
    predictions <- predict(model, newdata = test_data)
    actual <- test_data[[all.vars(formula)[1]]]

    # Calculate RMSE
    sqrt(mean((predictions - actual)^2))
  })

  return(cv_results)
}

# WRONG - no seed, not reproducible
perform_bootstrap_analysis <- function(data, n_bootstrap = 1000) {
  bootstrap_results <- replicate(n_bootstrap, {
    boot_sample <- data[sample(nrow(data), replace = TRUE), ]
    mean(boot_sample$value)
  })
  return(bootstrap_results)
}
```

### Document Random Seeds

Include seed values in documentation and outputs:

```r
# CORRECT - seed documented
#' Perform Monte Carlo simulation
#'
#' @param n_simulations Number of simulations to run
#' @param seed Random seed for reproducibility. Default is 20240121
#' @return Simulation results with seed attribute
monte_carlo_simulation <- function(n_simulations = 10000, seed = 20240121) {
  set.seed(seed)

  results <- replicate(n_simulations, {
    # Simulation code
  })

  # Attach seed to results
  attr(results, "seed") <- seed
  attr(results, "timestamp") <- Sys.time()

  return(results)
}
```

### Document Environment and Package Versions

Save session information with analysis results:

```r
# CORRECT - documents computational environment
save_analysis_with_sessioninfo <- function(results, output_path) {
  # Save main results
  saveRDS(results, file.path(output_path, "results.rds"))

  # Save session info
  session_info <- sessioninfo::session_info()
  saveRDS(session_info, file.path(output_path, "session_info.rds"))

  # Save human-readable version
  writeLines(
    capture.output(session_info),
    file.path(output_path, "session_info.txt")
  )

  cli::cli_alert_success(
    "Results saved with session information to {.path {output_path}}"
  )

  return(invisible(TRUE))
}

# Add to end of analysis scripts
if (interactive()) {
  sessioninfo::session_info()
}
```

### Use Relative Paths Only

Never use absolute paths in scripts:

```r
# CORRECT - relative paths with here package
library(here)

input_data <- readr::read_csv(here::here("data", "raw", "input.csv"))
output_path <- here::here("output", "results.csv")

# CORRECT - relative paths with file.path
input_data <- readr::read_csv(file.path("data", "raw", "input.csv"))

# WRONG - absolute paths (not portable)
input_data <- readr::read_csv("C:/Users/username/project/data/input.csv")
input_data <- readr::read_csv("/home/username/project/data/input.csv")
```

### Create Reproducible Project Structure

```r
# CORRECT - setup script for reproducible project
setup_analysis_project <- function(project_name) {
  # Create directory structure
  dir.create(project_name)
  dir.create(file.path(project_name, "data", "raw"), recursive = TRUE)
  dir.create(file.path(project_name, "data", "processed"), recursive = TRUE)
  dir.create(file.path(project_name, "R"))
  dir.create(file.path(project_name, "output", "figures"), recursive = TRUE)
  dir.create(file.path(project_name, "output", "tables"), recursive = TRUE)

  # Create README
  readme_content <- glue::glue("
    # {project_name}

    ## Project Structure

    - `data/raw/` - Original, immutable data
    - `data/processed/` - Cleaned data ready for analysis
    - `R/` - R scripts and functions
    - `output/figures/` - Generated plots
    - `output/tables/` - Generated tables

    ## Reproducibility

    Run scripts in order:
    1. `R/01_load_data.R`
    2. `R/02_clean_data.R`
    3. `R/03_analysis.R`
    4. `R/04_visualize.R`

    Session info saved in `output/session_info.txt`
  ")

  writeLines(readme_content, file.path(project_name, "README.md"))

  cli::cli_alert_success("Project structure created at {.path {project_name}}")
}
```

## Summary Checklist

Before finalizing statistical analysis:

- [ ] Input data validated (structure, types, constraints)
- [ ] Data transformations documented with data loss reported
- [ ] Missing data strategy explicit (complete case, imputation, sensitivity)
- [ ] Missing data patterns reported
- [ ] Point estimates accompanied by SE and CI
- [ ] Sample sizes reported for all summaries
- [ ] Model assumptions checked and documented
- [ ] Random seed set before stochastic operations
- [ ] Seed value documented in code and output
- [ ] Session info saved with results
- [ ] Only relative paths used
- [ ] Project structure supports reproducibility
- [ ] Analysis can be rerun from clean slate
