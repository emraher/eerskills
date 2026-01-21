# Reproducibility in Julia

Julia has best-in-class reproducibility tools built-in. Not using them is "slop."

## The Project Environment

Every project **must** have a `Project.toml` and `Manifest.toml`.

### 1. Create Environment
Never install packages into the global environment (v1.x).

```julia
using Pkg
Pkg.activate(".") # Activate current directory
```

### 2. Add Dependencies
```julia
Pkg.add("DataFrames")
Pkg.add("CSV")
```

### 3. Instantiate
This downloads the exact versions recorded in `Manifest.toml`.

```julia
Pkg.instantiate()
```

## Workflow for Reproducibility

1. **Start**: `git clone my-repo`
2. **Run**: `julia --project=.`
3. **Setup**: `] instantiate`
4. **Result**: Identical environment to the author's.

## Random Seeds

Always set seeds for stochastic workflows.

```julia
using Random
Random.seed!(1234)
```

## Revise.jl

For development, use `Revise.jl` to track changes without restarting.

```julia
using Revise
using MyPackage
```

## DrWatson.jl

For scientific projects, consider `DrWatson.jl`. It enforces naming conventions and parameter tracking.

```julia
using DrWatson
@quickactivate "MyProject"

# Saves file with parameters in name
safesave(datadir("simulations", savename(params, "jld2")), results)
```

## Slop vs. Professional

**Slop**:
- "Run `Pkg.add()` for these 10 packages..." in README.
- Scripts that depend on global package versions.
- No `Manifest.toml` committed.

**Professional**:
- `Manifest.toml` committed.
- "Run `Pkg.instantiate()`" in README.
- Self-contained environment.
