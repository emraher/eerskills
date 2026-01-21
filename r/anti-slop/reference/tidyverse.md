# Tidyverse Conventions and Formatting

## Philosophy

Follow the [Tidyverse Style Guide](https://style.tidyverse.org/) as the primary reference. Core principles:

1. **Design for humans** - Code should be readable and intuitive
2. **Reuse existing data structures** - Work with tibbles and data frames
3. **Compose simple functions with pipes** - Build complexity through composition
4. **Embrace functional programming** - Functions are first-class objects

## Spacing and Formatting

### Basic Spacing Rules

```r
# CORRECT - spaces around operators
x <- 5
y <- x + 10
result <- (x * 2) + (y / 3)

# Function calls - no space before parenthesis, space after comma
mean(x, na.rm = TRUE)
dplyr::filter(data, value > 0)

# WRONG - inconsistent spacing
x<-5
y<- x+10
result <- ( x*2 )+( y/3 )
mean (x,na.rm=TRUE)
```

### Line Length and Breaking

Keep lines under 80 characters when possible:

```r
# CORRECT - break long function calls
very_long_result <- calculate_complex_statistic(
  data = mortality_data,
  stratification_vars = c("age_group", "sex", "county"),
  standard_population = us_standard_2000,
  confidence_level = 0.95
)

# Break long pipelines at the pipe operator
customer_summary <- customer_data |>
  dplyr::filter(status == "active") |>
  dplyr::mutate(revenue_category = categorize_revenue(total_revenue)) |>
  dplyr::group_by(revenue_category) |>
  dplyr::summarize(
    mean_age = mean(age),
    total_customers = dplyr::n(),
    .groups = "drop"
  )

# WRONG - too long
very_long_result <- calculate_complex_statistic(data = mortality_data, stratification_vars = c("age_group", "sex", "county"), standard_population = us_standard_2000, confidence_level = 0.95)
```

### Indentation

Use 2 spaces for indentation (never tabs):

```r
# CORRECT - 2 space indentation
if (condition) {
  result <- calculate_value(x)
  return(result)
}

for (i in 1:10) {
  if (i %% 2 == 0) {
    print(paste("Even:", i))
  } else {
    print(paste("Odd:", i))
  }
}

# Function arguments spanning multiple lines
calculate_rate <- function(
  numerator,
  denominator,
  multiplier = 1,
  na.rm = TRUE
) {
  if (na.rm) {
    numerator <- numerator[!is.na(numerator)]
    denominator <- denominator[!is.na(denominator)]
  }

  rate <- (numerator / denominator) * multiplier
  return(rate)
}
```

## Pipe Conventions

### Native Pipe vs magrittr

**Prefer `|>` (native pipe) over `%>%` (magrittr)** unless R version < 4.1:

```r
# CORRECT - native pipe (R >= 4.1)
customer_data |>
  dplyr::filter(revenue > 0) |>
  dplyr::arrange(desc(revenue))

# ACCEPTABLE - magrittr pipe for R < 4.1 or when needing advanced features
customer_data %>%
  dplyr::filter(revenue > 0) %>%
  dplyr::arrange(desc(revenue))
```

**When to use `%>%` over `|>`**:
- Dot placeholder in non-first position: `data %>% lm(y ~ x, data = .)`
- Using `.` multiple times
- Legacy code consistency

### Pipe Formatting Rules

1. **Space before pipe, end of line**:
```r
# CORRECT
data |>
  dplyr::filter(x > 0) |>
  dplyr::mutate(y = x * 2)

# WRONG - pipe at start of line
data
  |> dplyr::filter(x > 0)
  |> dplyr::mutate(y = x * 2)

# WRONG - no space before pipe
data|>
  dplyr::filter(x > 0)|>
  dplyr::mutate(y = x * 2)
```

2. **One function call per line after pipe**:
```r
# CORRECT
result <- data |>
  dplyr::filter(status == "active") |>
  dplyr::select(customer_id, revenue) |>
  dplyr::arrange(desc(revenue))

# WRONG - multiple calls on one line
result <- data |> filter(status == "active") |> select(customer_id, revenue)
```

3. **Indent continuation lines by 2 spaces**:
```r
# CORRECT
summary_stats <- customer_data |>
  dplyr::group_by(segment, region) |>
  dplyr::summarize(
    mean_revenue = mean(revenue),
    median_revenue = median(revenue),
    total_customers = dplyr::n(),
    .groups = "drop"
  )
```

### Pipeline Length Guidelines

**Maximum 8 operations per pipeline**. Break longer chains into intermediate steps:

```r
# WRONG - too long (12 operations)
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
  arrange(category)

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

summary_by_category <- centered_data |>
  dplyr::group_by(category, year) |>
  dplyr::summarize(mean_centered = mean(centered), .groups = "drop")

wide_summary <- summary_by_category |>
  tidyr::pivot_wider(
    names_from = year,
    values_from = mean_centered
  ) |>
  dplyr::arrange(category)
```

**Benefits of breaking pipelines**:
- Easier to debug (can inspect intermediate results)
- Clearer variable names document the transformation
- Can reuse intermediate steps
- Easier to test individual transformations

## Namespace Qualification

### Always Use `::`

**ALWAYS qualify external package functions with `::`**:

```r
# CORRECT - explicit namespace
customer_data <- readr::read_csv("data/customers.csv")

summary_stats <- customer_data |>
  dplyr::filter(revenue > 0) |>
  dplyr::mutate(log_revenue = log(revenue)) |>
  dplyr::summarize(
    mean_log_revenue = mean(log_revenue),
    sd_log_revenue = sd(log_revenue)
  )

# WRONG - implicit namespace (requires library() calls)
library(dplyr)
library(readr)

customer_data <- read_csv("data/customers.csv")
summary_stats <- customer_data |>
  filter(revenue > 0) |>
  mutate(log_revenue = log(revenue))
```

**Exceptions** (no `::` needed):
- **base**: `mean()`, `sum()`, `log()`, `sqrt()`, `c()`, `list()`, etc.
- **stats**: `lm()`, `glm()`, `t.test()`, `anova()`, `predict()`, etc.
- **utils**: `head()`, `tail()`, `str()`, `View()`, etc.
- **graphics**: `plot()`, `points()`, `lines()`, etc.

**Why use `::`**:
- No `library()` calls cluttering scripts
- Clear where functions come from
- Prevents namespace conflicts
- Works in package development without importing

### Common Package Namespaces

```r
# Data manipulation
dplyr::filter(), dplyr::mutate(), dplyr::summarize()
tidyr::pivot_longer(), tidyr::separate()
purrr::map(), purrr::map_dbl()

# Data import/export
readr::read_csv(), readr::write_csv()
readxl::read_excel()
haven::read_dta(), haven::read_sas()

# String operations
stringr::str_detect(), stringr::str_replace()

# Date/time
lubridate::ymd(), lubridate::floor_date()

# Visualization
ggplot2::ggplot(), ggplot2::aes(), ggplot2::geom_point()

# Modeling
broom::tidy(), broom::glance(), broom::augment()
```

## Argument Formatting

### Named Arguments

Always name arguments after the first positional argument:

```r
# CORRECT - named arguments
dplyr::filter(customer_data, revenue > 0)
mean(revenue_vector, na.rm = TRUE, trim = 0.1)
readr::read_csv("data.csv", col_types = "cdin", skip = 1)

# WRONG - too many positional arguments
mean(revenue_vector, TRUE, 0.1)
read_csv("data.csv", "cdin", 1)
```

### Multi-line Arguments

Break complex arguments across lines:

```r
# CORRECT - readable multi-line arguments
customer_categories <- dplyr::case_when(
  revenue > 10000 ~ "premium",
  revenue > 5000 ~ "standard",
  revenue > 1000 ~ "basic",
  TRUE ~ "inactive"
)

# CORRECT - multi-line function call
ggplot2::ggplot(
  data = customer_data,
  mapping = ggplot2::aes(x = age, y = revenue)
) +
  ggplot2::geom_point(alpha = 0.5) +
  ggplot2::geom_smooth(method = "lm", se = TRUE) +
  ggplot2::labs(
    title = "Revenue by Customer Age",
    x = "Customer Age (years)",
    y = "Annual Revenue ($)"
  )
```

## ggplot2 Conventions

### Plot Structure

```r
# CORRECT - clear structure with explicit namespacing
revenue_plot <- ggplot2::ggplot(
  data = customer_data,
  mapping = ggplot2::aes(x = age, y = revenue, color = segment)
) +
  ggplot2::geom_point(alpha = 0.6, size = 2) +
  ggplot2::geom_smooth(method = "loess", se = TRUE) +
  ggplot2::scale_y_continuous(
    labels = scales::dollar_format(),
    breaks = seq(0, 50000, 10000)
  ) +
  ggplot2::labs(
    title = "Customer Revenue by Age and Segment",
    subtitle = "2023 Annual Revenue",
    x = "Customer Age (years)",
    y = "Annual Revenue",
    color = "Customer Segment"
  ) +
  ggplot2::theme_minimal() +
  ggplot2::theme(
    plot.title = ggplot2::element_text(size = 14, face = "bold"),
    legend.position = "bottom"
  )

# Save with explicit dimensions
ggplot2::ggsave(
  filename = "plots/revenue_by_age.png",
  plot = revenue_plot,
  width = 8,
  height = 6,
  dpi = 300
)
```

### ggplot2 Formatting Rules

1. **`+` at end of line, not beginning**:
```r
# CORRECT
ggplot2::ggplot(data, ggplot2::aes(x, y)) +
  ggplot2::geom_point() +
  ggplot2::theme_minimal()

# WRONG
ggplot2::ggplot(data, ggplot2::aes(x, y))
  + ggplot2::geom_point()
  + ggplot2::theme_minimal()
```

2. **Use explicit `data =` and `mapping =`** for `ggplot()`:
```r
# CORRECT - explicit arguments
ggplot2::ggplot(data = customer_data, mapping = ggplot2::aes(x = age, y = revenue))

# ACCEPTABLE for simple plots
ggplot2::ggplot(customer_data, ggplot2::aes(age, revenue))
```

3. **One geom/scale/theme per line**:
```r
# CORRECT
plot +
  ggplot2::geom_point() +
  ggplot2::geom_smooth() +
  ggplot2::theme_minimal()

# WRONG
plot + geom_point() + geom_smooth() + theme_minimal()
```

### Faceting and Scales

```r
# CORRECT - well-formatted faceting
ggplot2::ggplot(
  data = sales_data,
  mapping = ggplot2::aes(x = month, y = revenue)
) +
  ggplot2::geom_line() +
  ggplot2::facet_wrap(
    facets = vars(region),
    ncol = 2,
    scales = "free_y"
  ) +
  ggplot2::scale_x_date(
    date_breaks = "3 months",
    date_labels = "%b %Y"
  ) +
  ggplot2::scale_y_continuous(
    labels = scales::dollar_format(),
    limits = c(0, NA)
  )
```

## Performance Tips

### Use Vectorization

```r
# CORRECT - vectorized operations (fast)
customer_data <- customer_data |>
  dplyr::mutate(
    revenue_per_day = total_revenue / 365,
    is_high_value = total_revenue > 10000,
    log_revenue = log(total_revenue + 1)
  )

# WRONG - loops for vectorizable operations (slow)
for (i in 1:nrow(customer_data)) {
  customer_data$revenue_per_day[i] <- customer_data$total_revenue[i] / 365
  customer_data$is_high_value[i] <- customer_data$total_revenue[i] > 10000
}
```

### Efficient Grouping Operations

```r
# CORRECT - efficient grouped operations
summary_stats <- customer_data |>
  dplyr::group_by(segment, region) |>
  dplyr::summarize(
    mean_revenue = mean(revenue),
    median_revenue = median(revenue),
    total_customers = dplyr::n(),
    .groups = "drop"
  )

# For very large datasets, consider data.table
library(data.table)
customer_dt <- data.table::as.data.table(customer_data)
summary_stats_dt <- customer_dt[,
  .(
    mean_revenue = mean(revenue),
    median_revenue = median(revenue),
    total_customers = .N
  ),
  by = .(segment, region)
]
```

### Avoid Growing Objects in Loops

```r
# WRONG - growing vector in loop (very slow)
results <- c()
for (i in 1:10000) {
  results <- c(results, calculate_value(i))
}

# CORRECT - pre-allocate vector
results <- vector("numeric", length = 10000)
for (i in 1:10000) {
  results[i] <- calculate_value(i)
}

# BEST - use vectorization or map
results <- purrr::map_dbl(1:10000, calculate_value)
# or
results <- sapply(1:10000, calculate_value)
```

### When to Use data.table

Consider `data.table` for:
- Very large datasets (millions of rows)
- Repeated grouping operations
- Memory-constrained environments
- When performance is critical

```r
# data.table syntax for performance-critical operations
library(data.table)

# Convert to data.table
dt <- data.table::as.data.table(large_dataset)

# Efficient operations
result <- dt[
  status == "active" & revenue > 0,  # Filter
  .(
    mean_revenue = mean(revenue),
    total_customers = .N
  ),
  by = .(segment, region)  # Group by
][
  order(-mean_revenue)  # Sort
]
```

## Code Formatting Tools

### styler Package

Use `styler` to automatically format code:

```r
# Format a single file
styler::style_file("analysis.R")

# Format all R files in a directory
styler::style_dir("R/")

# Format a package
styler::style_pkg()
```

### lintr Package

Check code quality with `lintr`:

```r
# Lint a single file
lintr::lint("analysis.R")

# Lint all files in a directory
lintr::lint_dir("R/")

# Lint a package
lintr::lint_package()
```

### Configure lintr

Create `.lintr` file in project root:

```
linters: linters_with_defaults(
  line_length_linter(120),
  object_name_linter = NULL,  # If using custom naming
  commented_code_linter = NULL
)
```

## Summary Checklist

Before committing code, verify:

- [ ] All external functions use `::` namespace qualification
- [ ] Native pipe `|>` preferred over `%>%` (R >= 4.1)
- [ ] Space before pipe, pipe at end of line
- [ ] One operation per line in pipelines
- [ ] Long pipelines (>8 ops) broken into named intermediate steps
- [ ] Lines under 80 characters when reasonable
- [ ] 2-space indentation (no tabs)
- [ ] Named arguments after first positional argument
- [ ] ggplot2 uses `+` at end of line
- [ ] Code formatted with `styler::style_file()`
- [ ] No linter warnings from `lintr::lint()`
- [ ] Vectorized operations preferred over loops
- [ ] Pre-allocated vectors when loops necessary
