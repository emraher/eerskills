# Julia Performance Patterns

Julia is designed to be fast, but "slop" code often misses the mark by ignoring type stability and memory allocation. Follow these patterns to ensure high performance.

## 1. Type Stability

Type stability is the most critical factor for Julia performance. A function is type-stable if the return type can be predicted from the argument types alone.

### The Golden Rule
**Check your hot loops with `@code_warntype`.**

```julia
# Bad: Type unstable
function sum_values(x)
    total = 0  # Initialized as Int
    for val in x
        total += val # If x contains Floats, total changes type
    end
    return total
end

# Good: Type stable
function sum_values(x::AbstractVector{T}) where T
    total = zero(T) # Initialized as same type as elements
    for val in x
        total += val
    end
    return total
end
```

### Red Flags in `@code_warntype`
- **Red text**: Indicates type instability.
- **`Union{...}`**: The compiler can't decide on a single type.
- **`Any`**: The compiler knows nothing. Extremely slow.

## 2. Global Variables

**Never** use untyped global variables in performance-critical code.

```julia
# Bad
const threshold = 5.0 # Untyped global (in older Julia versions)
# Or
threshold = 5.0

function filter_values(x)
    return filter(v -> v > threshold, x) # Accessing global is slow
end

# Good: Pass as argument
function filter_values(x, thresh)
    return filter(v -> v > thresh, x)
end

# Good: Constant global with type (modern Julia infers const well, but be careful)
const THRESHOLD = 5.0
```

## 3. Pre-allocation

Avoid growing arrays inside loops (`push!`). It triggers frequent memory allocations.

```julia
# Bad
results = []
for i in 1:n
    push!(results, complex_calc(i))
end

# Good
results = Vector{Float64}(undef, n)
for i in 1:n
    results[i] = complex_calc(i)
end

# Better (if applicable)
results = map(complex_calc, 1:n)
```

## 4. Column-Major Order

Julia arrays are stored in column-major order (like Fortran/R, unlike C/Python). Iterate over columns first.

```julia
# Bad (Row-major traversal)
for r in 1:rows
    for c in 1:cols
        sum += matrix[r, c]
    end
end

# Good (Column-major traversal)
for c in 1:cols
    for r in 1:rows
        sum += matrix[r, c]
    end
end
```

## 5. Broadcasting (`.`)

Use broadcasting (dot syntax) instead of explicit loops for element-wise operations. It fuses operations and avoids temporary arrays.

```julia
# Bad: Creates temporary array for x^2, then another for + 1
y = x^2 + 1 

# Good: Fuses into a single loop
y = x.^2 .+ 1 

# Macro version (cleaner for long expressions)
y = @. x^2 + 1
```

## 6. Views

Slicing an array creates a copy. Use `@view` or `view()` to reference existing memory.

```julia
# Bad: Copies the column
col = matrix[:, 1]

# Good: References the column
col = @view matrix[:, 1]
```

## 7. Benchmarking

Use `BenchmarkTools.jl` for accurate timing. Don't use `@time` for micro-benchmarks.

```julia
using BenchmarkTools

# Run benchmark
@benchmark my_function($data)
```

**Note**: Interpolate variables with `$` to avoid benchmarking the global variable lookup.
