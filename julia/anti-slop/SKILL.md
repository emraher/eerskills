---
name: julia-anti-slop
description: >
  Enforce high-performance Julia conventions for scientific computing. 
  Prevents generic AI patterns through type stability, multiple dispatch 
  best practices, and DataFrames.jl standards.
applies_to:
  - "**/*.jl"
tags: [julia, scientific-computing, type-stability, data-frames]
related_skills:
  - r/anti-slop
  - python/anti-slop
version: 2.0.0
---

# Julia Anti-Slop Skill for Scientific Computing

## When to Use This Skill

Use julia-anti-slop when:
- ✓ Writing new Julia code for scientific computing or data science
- ✓ Reviewing AI-generated Julia code before committing
- ✓ Refactoring existing code for performance and type stability
- ✓ Building high-performance packages or models
- ✓ Transitioning from R or Python to Julia
- ✓ Enforcing Julia community coding standards

Do NOT use when:
- Writing quick exploratory scripts where performance is irrelevant
- Working with legacy code that cannot be modified
- Using Julia for general-purpose web development (though standards still apply)

## Quick Example

**Before (AI Slop)**:
```julia
# Process data
function process(data)
    result = []
    for x in data
        push!(result, x * 2.0)
    end
    return result
end
```

**After (Anti-Slop)**:
```julia
"""
    calculate_scaled_values(raw_inputs::AbstractVector{T}) where T<:Real

Calculate scaled values by doubling raw inputs. Returns a new vector of same type.
"""
function calculate_scaled_values(raw_inputs::AbstractVector{T})::Vector{T} where T<:Real
    # Pre-allocate for performance
    scaled_results = similar(raw_inputs)
    
    # Broadcast operation is faster and type-stable
    scaled_results .= raw_inputs .* 2.0
    
    return scaled_results
end
```

**What changed**:
- ✓ Descriptive name (`calculate_scaled_values` not `process`)
- ✓ Type annotations on function signature (`AbstractVector{T}`)
- ✓ Explicit return type (`Vector{T}`)
- ✓ Pre-allocation (`similar`) instead of growing an array
- ✓ Broadcasting (`.`) for performance and clarity
- ✓ Comprehensive docstring

## When to Use What

| If you need to... | Do this | Details |
|-------------------|---------|---------|
| Name variables | `snake_case`, descriptive names | reference/naming.md |
| Define functions | Use type annotations + multiple dispatch | reference/dispatch.md |
| Handle data | Use `DataFrames.jl` with `@chain` | reference/dataframes.md |
| Optimize code | Ensure type stability (`@code_warntype`) | reference/performance.md |
| Plot data | Use `Plots.jl` or `Makie.jl` | reference/plotting.md |
| Manage projects | Use `Pkg` with `Project.toml` | reference/reproducibility.md |

## Core Workflow

### 5-Step Quality Check

1. **Type stability** - Check with `@code_warntype`
   ```julia
   @code_warntype my_function(args...)
   ```

2. **Function signatures** - Use specific or parametric types
   ```julia
   # Good
   function solve(x::AbstractVector{T}) where T<:Real
   
   # Bad
   function solve(x)
   ```

3. **Pre-allocation** - Avoid growing arrays in loops
   ```julia
   results = zeros(n)
   for i in 1:n
       results[i] = compute(i)
   end
   ```

4. **Broadcasting** - Use native `.` syntax for vectorization
   ```julia
   y = @. exp(x) * sin(x)
   ```

5. **In-place operations** - Use `!` suffix for functions that modify inputs
   ```julia
   sort!(my_vector)
   normalize!(data_matrix)
   ```

## Quick Reference Checklist

Before committing Julia code, verify:

- [ ] All functions have type annotations
- [ ] Functions are type-stable (verified with `@code_warntype`)
- [ ] No global variables in hot loops
- [ ] Arrays are pre-allocated where possible
- [ ] Use `!` for functions that mutate arguments
- [ ] Broadcasting (`.`) used instead of explicit loops where appropriate
- [ ] Docstrings follow Julia standard format
- [ ] No single-letter variables except for standard indices
- [ ] Multiple dispatch used to handle different types
- [ ] Project has `Project.toml` and `Manifest.toml`

## Common Workflows

### Workflow 1: Optimize AI-Generated Julia Code

**Context**: AI generated a function that is slow or type-unstable.

**Steps**:

1. **Identify instability**
   ```julia
   @code_warntype my_function(data)
   # Look for Any or Union types in red
   ```

2. **Add type constraints**
   ```julia
   # Before
   function process(x) ...
   
   # After
   function process(x::Vector{Float64}) ...
   ```

3. **Remove type-changing assignments**
   ```julia
   # Before
   val = 0  # Int
   val = 0.5 # Now Float64 - unstable!
   
   # After
   val = 0.0 # Float64 from the start
   ```

4. **Verify with BenchmarkTools**
   ```julia
   using BenchmarkTools
   @benchmark my_function(data)
   ```

**Expected outcome**: Type-stable, high-performance function

---

### Workflow 2: Build a Data Pipeline

**Context**: Processing a large CSV with `DataFrames.jl`.

**Steps**:

1. **Load data with explicit types**
   ```julia
   using CSV, DataFrames
   customer_data = CSV.read("data.csv", DataFrame, types=Dict(:id => Int64))
   ```

2. **Use `@chain` for transformations**
   ```julia
   using Chain
   summary = @chain customer_data begin
       filter(:age => >=(18), _)
       groupby(:region)
       combine(:revenue => sum => :total_revenue)
   end
   ```

3. **Ensure output type stability**
   ```julia
   function get_summary(df::DataFrame)::DataFrame
       # pipeline...
   end
   ```

**Expected outcome**: Readable, maintainable, and fast data pipeline

---

### Workflow 3: Prepare Package for Release

**Context**: Standardizing code for a Julia package.

**Steps**:

1. **Organize exports**
   ```julia
   module MyPackage
   export solve_problem, MyType
   # ...
   end
   ```

2. **Add comprehensive docstrings**
   ```julia
   """
       solve_problem(data::AbstractArray)
   
   Explain the algorithm and return types.
   """
   ```

3. **Verify Project.toml**
   ```julia
   # Ensure all dependencies are tracked
   using Pkg
   Pkg.status()
   ```

4. **Add tests**
   ```julia
   using Test
   @testset "MyPackage.jl" begin
       @test solve_problem([1, 2]) == 3
   end
   ```

**Expected outcome**: Professional Julia package following community standards

## Mandatory Rules Summary

### 1. Type Stability
Functions must not change the type of a variable within their scope. Check with `@code_warntype`.

### 2. Parametric Types
Use `AbstractVector{T} where T<:Real` instead of just `Vector` or `Any`.

### 3. Mutating Functions
Always append `!` to functions that modify their arguments (e.g., `sort!`, `push!`).

### 4. No Globals in Loops
Never access or modify global variables inside performance-critical loops.

### 5. Standard Naming
- Variables/Functions: `snake_case`
- Types/Modules: `PascalCase`

## Resources & Advanced Topics

### Reference Files (Planned)

- **reference/performance.md** - Type stability and benchmarking
- **reference/dispatch.md** - Multiple dispatch patterns
- **reference/dataframes.md** - Data manipulation standards
- **reference/plotting.md** - Visualization best practices
- **reference/reproducibility.md** - Pkg and environment management

### Related Skills

- **r/anti-slop** - For users moving from R to Julia
- **python/anti-slop** - For users moving from Python to Julia

### Tools

- `BenchmarkTools.jl` - Accurate benchmarking
- `Chain.jl` - Readable pipelines
- `Revise.jl` - Live code updates without restarting
- `LanguageServer.jl` - IDE support