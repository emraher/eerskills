# DataFrames.jl Standards

`DataFrames.jl` is the standard for tabular data in Julia. To avoid "slop," use modern macros, consistent pipelining, and type-safe operations.

## Core Principles

1. **Use Macros**: `@subset`, `@transform`, `@combine` are safer and faster than standard functions.
2. **Chain Operations**: Use `@chain` (from `Chain.jl` or `DataFramesMeta.jl`) for readability.
3. **Type Stability**: Ensure your transformations don't introduce type instability (e.g., mixing `Int` and `Float`).
4. **Symbol Columns**: Use `:colname` instead of string `"colname"`.

## The Modern Workflow

Use `DataFramesMeta.jl` or `Chain.jl` patterns.

```julia
using DataFrames, DataFramesMeta

# Good: Readable chain
result = @chain data begin
    @subset(:age .> 18)
    @transform(:income_k = :income / 1000)
    @groupby(:region)
    @combine(:mean_income = mean(:income_k))
    @orderby(-:mean_income)
end
```

## Selecting and Transforming

### Selection
```julia
# Select columns
select(df, :col1, :col2)
select(df, Not(:col3))
select(df, r"^temp") # Regex selection
```

### Transformation
Use `@rtransform` for row-wise operations (easier syntax than broadcasting).

```julia
# Row-wise transform (no dot needed inside)
@rtransform(df, :total = :price * :qty)

# Standard transform (needs dot for broadcasting)
@transform(df, :total = :price .* :qty)
```

## Missing Values

Julia uses `missing` (not `NA` or `NaN`).

### Handling Missing
```julia
# Drop rows with any missing values
dropmissing(df)

# Fill missing values
coalesce.(df.col, 0) # Replace missing with 0
```

### Skipmissing
Functions like `mean` will return `missing` if any input is missing.

```julia
mean(skipmissing(df.col))
```

## Join Operations

Be explicit about join keys and types.

```julia
leftjoin(df1, df2, on = :id)
innerjoin(df1, df2, on = [:date, :region])
```

## Performance Tips

1. **CategoricalArrays**: For low-cardinality strings (like factors in R).
   ```julia
   df.status = categorical(df.status)
   ```

2. **In-place modification**: Use `select!` or `transform!` to avoid copying large dataframes.
   ```julia
   select!(df, Not(:temp_col))
   ```

3. **Type specification on load**:
   ```julia
   CSV.read("data.csv", DataFrame, types=Dict(:id => Int64))
   ```

## Slop vs. Idiomatic

**Slop (Pythonic/R-style loops)**:
```julia
# Bad
df[!, :new] = zeros(nrow(df))
for i in 1:nrow(df)
    df[i, :new] = df[i, :old] * 2
end
```

**Idiomatic**:
```julia
# Good
@transform(df, :new = :old * 2)
```
