---
name: julia-anti-slop
description: >
  High-performance Julia conventions for scientific computing. Enforces type
  stability, multiple dispatch best practices, and DataFrames.jl usage.
---

# Julia Anti-Slop Skill for R Users

## Purpose
Prevents generic AI-generated Julia code by enforcing Julia community standards for scientific computing. Designed for R users leveraging Julia's performance for numerically intensive work.

## Core Principles

### 1. Multiple Dispatch Philosophy
Julia's type system and multiple dispatch are central:
- Write generic, type-stable functions
- Leverage multiple dispatch for extensibility
- Use type annotations for performance and clarity

### 2. Performance by Default
- Write fast code naturally
- Type stability for hot paths
- Benchmark and profile before optimizing

### 3. Familiar to R Users
- Similar statistical computing focus
- DataFrames.jl mirrors R's data.frame/tibble
- Plots.jl similar to ggplot2
- Pipe operator `|>` like R

## Naming Conventions

```julia
# CORRECT - snake_case for variables and functions, PascalCase for types
customer_data = CSV.read("customers.csv", DataFrame)
revenue_total = calculate_total_revenue(customer_data)

function calculate_growth_rate(initial_value::Real, final_value::Real, periods::Real)
    growth_rate = (final_value / initial_value)^(1 / periods) - 1
    return growth_rate
end

# Type definitions
struct CustomerRecord
    id::Int
    name::String
    revenue::Float64
end

# Constants
const MAX_ITERATIONS = 1000
const DEFAULT_THRESHOLD = 0.05

# WRONG - inconsistent conventions
CustomerData = CSV.read("customers.csv", DataFrame)  # PascalCase for variable
revenueTotal = calculateTotalRevenue(data)          # camelCase
```

## Type Annotations

```julia
# CORRECT - type annotations for performance and clarity
function calculate_summary_stats(
    data::DataFrame,
    column::Symbol;
    group_by::Union{Symbol, Nothing} = nothing
)::DataFrame
    """
    Calculate summary statistics for a column.
    
    # Arguments
    - `data::DataFrame`: Input dataframe
    - `column::Symbol`: Column name to summarize
    - `group_by::Symbol`: Optional grouping column
    
    # Returns
    - `DataFrame`: Summary statistics
    """
    if !isnothing(group_by)
        stats = combine(
            groupby(data, group_by),
            column => mean => :mean,
            column => std => :std,
            nrow => :count
        )
    else
        stats = DataFrame(
            mean = mean(data[!, column]),
            std = std(data[!, column]),
            count = nrow(data)
        )
    end
    
    return stats
end

# Parametric types for generic functions
function apply_function(f::Function, x::AbstractVector{T}) where T<:Real
    return f.(x)
end
```

## DataFrames.jl (like dplyr/tidyverse)

```julia
using DataFrames
using Chain

# CORRECT - pipe operator |> with @chain macro for readability
customer_summary = @chain customer_data begin
    @subset(:age .>= 18, :status .== "active")
    @transform(
        :revenue_category = cut(
            :revenue,
            [0, 1000, 5000, Inf],
            labels = ["low", "medium", "high"]
        )
    )
    groupby(:revenue_category)
    @combine(
        :mean_age = mean(:age),
        :total_revenue = sum(:revenue),
        :count = length(:customer_id)
    )
end

# Method chaining with |>
result = customer_data |
    x -> filter(:age => >=(18), x) |
    x -> select(x, :customer_id, :revenue, :age)

# WRONG - nested operations, hard to read
result = select(filter(x -> x.age >= 18, customer_data), [:customer_id, :revenue])
```

## Function Design

```julia
# CORRECT - comprehensive docstring, validation, return type
"""
    fit_linear_model(X::Matrix{<:Real}, y::Vector{<:Real}; fit_intercept::Bool=true)

Fit linear regression model using least squares.

# Arguments
- `X::Matrix`: Feature matrix (n × p)
- `y::Vector`: Target variable (length n)
- `fit_intercept::Bool=true`: Whether to fit intercept

# Returns
- `NamedTuple`: Results containing:
    - `coefficients`: Vector of coefficients
    - `intercept`: Intercept value
    - `r_squared`: R² statistic

# Examples
```julia
X = randn(100, 3)
y = X * [1.0, 2.0, 3.0] + randn(100)
results = fit_linear_model(X, y)
```
"""
function fit_linear_model(
    X::Matrix{<:Real},
    y::Vector{<:Real};
    fit_intercept::Bool = true
)
    # Validation
    n_obs, n_features = size(X)
    
    if length(y) != n_obs
        throw(DimensionMismatch(
            "X and y must have same number of observations. " *
            "Got X: $n_obs, y: $(length(y))"
        ))
    end
    
    # Add intercept if requested
    if fit_intercept
        X_design = hcat(ones(n_obs), X)
    else
        X_design = X
    end
    
    # Fit model (solve normal equations)
    coefficients = X_design \ y
    
    # Extract intercept
    if fit_intercept
        intercept = coefficients[1]
        coef_main = coefficients[2:end]
    else
        intercept = 0.0
        coef_main = coefficients
    end
    
    # Calculate R²
    y_pred = X_design * coefficients
    ss_total = sum((y .- mean(y)).^2)
    ss_resid = sum((y .- y_pred).^2)
    r_squared = 1 - ss_resid / ss_total
    
    # Return named tuple
    return (
        coefficients = coef_main,
        intercept = intercept,
        r_squared = r_squared,
        fitted = y_pred
    )
end
```

## Error Handling

```julia
# CORRECT - specific error types, informative messages
function load_and_validate_data(file_path::String)::DataFrame
    """Load data and validate required columns."""
    
    # Check file exists
    if !isfile(file_path)
        throw(ArgumentError(
            "Data file not found: $file_path\n" *
            "Current directory: $(pwd())"
        ))
    end
    
    # Load data
    try
        data = CSV.read(file_path, DataFrame)
    catch e
        throw(ArgumentError(
            "Failed to parse CSV file: $file_path\n" *
            "Error: $(sprint(showerror, e))"
        ))
    end
    
    # Validate columns
    required_columns = [:customer_id, :date, :revenue]
    missing_columns = setdiff(required_columns, names(data, Symbol))
    
    if !isempty(missing_columns)
        throw(ArgumentError(
            "Missing required columns: $missing_columns\n" *
            "Available columns: $(names(data))"
        ))
    end
    
    return data
end

# Custom error types for specific domains
struct ValidationError <: Exception
    msg::String
end

Base.showerror(io::IO, e::ValidationError) = print(io, "ValidationError: ", e.msg)
```

## Statistical Analysis

```julia
using Statistics
using HypothesisTests

# CORRECT - report all test statistics with uncertainty
function compare_groups(
    group1::Vector{<:Real},
    group2::Vector{<:Real};
    α::Float64 = 0.05
)
    """
    Compare two groups using t-test.
    
    Returns NamedTuple with test statistics, CI, and p-value.
    """
    # Perform t-test
    test = EqualVarianceTTest(group1, group2)
    
    # Extract statistics
    t_stat = test.t
    p_value = pvalue(test)
    ci = confint(test, level = 1 - α)
    
    # Calculate means and SE
    mean1 = mean(group1)
    mean2 = mean(group2)
    diff = mean1 - mean2
    
    se1 = std(group1) / sqrt(length(group1))
    se2 = std(group2) / sqrt(length(group2))
    se_diff = sqrt(se1^2 + se2^2)
    
    return (
        mean_group1 = mean1,
        mean_group2 = mean2,
        difference = diff,
        std_error = se_diff,
        ci_lower = ci[1],
        ci_upper = ci[2],
        t_statistic = t_stat,
        p_value = p_value,
        significant = p_value < α
    )
end
```

## Plotting with Plots.jl

```julia
using Plots
using StatsPlots

# CORRECT - reproducible, customizable plotting
function plot_distribution_comparison(
    data::DataFrame,
    value_col::Symbol,
    group_col::Symbol;
    title::String = "Distribution Comparison"
)
    """Create comparison plot of distributions across groups."""
    
    # Create subplots
    p1 = @df data boxplot(
        string.(:group_col),
        :value_col,
        title = "Box Plot",
        xlabel = string(group_col),
        ylabel = string(value_col),
        legend = false
    )
    
    p2 = @df data violin(
        string.(:group_col),
        :value_col,
        title = "Violin Plot",
        xlabel = string(group_col),
        ylabel = string(value_col),
        legend = false
    )
    
    # Combine plots
    plot(p1, p2, layout = (1, 2), size = (1000, 400), plot_title = title)
end
```

## Performance Optimization

### Type Stability
```julia
# CORRECT - type-stable function
function fast_mean(x::Vector{Float64})::Float64
    total = 0.0
    for val in x
        total += val
    end
    return total / length(x)
end

# WRONG - type-unstable (check with @code_warntype)
function slow_mean(x)
    total = 0  # Type changes from Int to Float64
    for val in x
        total += val
    end
    return total / length(x)
end

# Check type stability
@code_warntype fast_mean(randn(100))
```

### Benchmark Before Optimizing
```julia
using BenchmarkTools

# Benchmark functions
x = randn(10_000)

@benchmark fast_mean($x)
@benchmark mean($x)  # Compare to built-in

# Profile code
using Profile

@profile begin
    for i in 1:1000
        fast_mean(x)
    end
end

Profile.print()
```

### In-Place Operations
```julia
# Allocate less - use ! suffix for in-place operations
x = randn(1000)
y = similar(x)

# CORRECT - in-place
y .= sin.(x)  # Broadcasting with fusion
sort!(x)       # In-place sort

# WRONG - allocates new array
y = sin.(x)   # When y already allocated
```

## Reproducibility

```julia
# Set random seed
using Random
Random.seed!(20240121)

# For reproducible train/test splits
using MLJ

train_indices, test_indices = partition(
    eachindex(y),
    0.8,
    shuffle = true,
    rng = MersenneTwister(20240121)
)

# Document environment
using Pkg

# Save Project.toml and Manifest.toml for reproducibility
Pkg.status()  # Show package versions

# Generate at project start
Pkg.activate(".")
Pkg.instantiate()
```

## Forbidden Patterns

```julia
# WRONG - global variables in hot loops
global counter = 0
function increment_global()
    global counter += 1
end

# CORRECT - pass values explicitly
function increment(counter::Int)
    return counter + 1
end

# WRONG - type-unstable container
mixed_array = [1, 2.0, "three"]  # Any[] - very slow

# CORRECT - type-stable
int_array = [1, 2, 3]           # Vector{Int}
float_array = [1.0, 2.0, 3.0]   # Vector{Float64}

# WRONG - unnecessary memory allocation in loop
function allocate_in_loop(n)
    result = Float64[]
    for i in 1:n
        temp = zeros(100)  # Allocates every iteration
        push!(result, sum(temp))
    end
    return result
end

# CORRECT - pre-allocate
function preallocate(n)
    result = zeros(n)
    temp = zeros(100)
    for i in 1:n
        fill!(temp, 0)
        result[i] = sum(temp)
    end
    return result
end
```

## Interop with R

```julia
using RCall

# Call R from Julia
R"""
library(fixest)
model <- feols(y ~ x, data = df)
summary(model)
"""

# Pass data between R and Julia
@rput data  # Julia DataFrame to R
@rget results  # R object to Julia

# Use R packages
R"""
library(ggplot2)
ggplot(data, aes(x = x, y = y)) +
    geom_point()
"""
```

## Package Development

```julia
# Create package
using PkgTemplates

template = Template(;
    user = "username",
    authors = ["Author Name"],
    julia = v"1.6",
    plugins = [
        Git(; manifest = true),
        GitHubActions(),
        Documenter{GitHubActions}(),
        Codecov()
    ]
)

template("MyPackage")

# Structure
# MyPackage/
# ├── Project.toml
# ├── Manifest.toml
# ├── src/
# │   └── MyPackage.jl
# ├── test/
# │   └── runtests.jl
# └── docs/
#     └── make.jl
```

## Key Differences from R

| Concept | R | Julia |
|---------|---|-------|
| Indexing | 1-based | 1-based ✓ |
| Assignment | `<-` | `=` |
| Pipe | `|>` | `|>` ✓ |
| Missing values | `NA` | `missing` |
| Vectors | `c(1, 2, 3)` | `[1, 2, 3]` |
| Data frames | `data.frame`, `tibble` | `DataFrame` |
| True/False | `TRUE`/`FALSE` | `true`/`false` |
| Broadcasting | Automatic | `.` syntax |

## Summary Checklist

- [ ] Functions have type annotations
- [ ] Comprehensive docstrings
- [ ] Error handling with specific types
- [ ] Type-stable hot paths (@code_warntype)
- [ ] Use `!` suffix for in-place operations
- [ ] Random seeds set (Random.seed!)
- [ ] Project.toml and Manifest.toml for reproducibility
- [ ] Benchmark before optimizing (@benchmark)
- [ ] No type-unstable containers
- [ ] No global variables in loops

## Performance Tips for R Users

Julia is fast because:
1. **Just-in-time compilation** - first run compiles, subsequent runs are fast
2. **Type stability** - compiler knows types, generates efficient code
3. **Multiple dispatch** - specialized methods for different types
4. **No vectorization penalty** - loops are fast!

```julia
# In R, vectorize for speed
# x <- seq(1, 1000000)
# y <- x^2 + 2*x + 1

# In Julia, loops are fast - no need to vectorize
x = 1:1_000_000
y = similar(x, Float64)

for i in eachindex(x)
    y[i] = x[i]^2 + 2*x[i] + 1
end

# But broadcasting is cleaner and fast too
y = @. x^2 + 2*x + 1  # @. broadcasts all operations
```

Claude should produce Julia code that:
- Is type-stable for performance
- Has comprehensive docstrings
- Uses multiple dispatch appropriately
- Leverages Julia's strengths (speed, composability)
- Would pass code review in Julia community

```