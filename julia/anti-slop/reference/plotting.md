# Julia Plotting Standards

Avoid generic, default plots. Use `Plots.jl` for standard visualization and `Makie.jl` for high-performance/3D needs.

## Core Principles

1. **Reproducible**: Scripted plots, not interactive GUI screenshots.
2. **Labeled**: Always include title, xlabel, ylabel, and legend.
3. **Data-Centric**: Choose the right geometry for the data distribution.
4. **Attribute Macros**: Use `@df` to plot directly from DataFrames.

## Plots.jl Workflow

```julia
using Plots, StatsPlots

# Good: Full configuration
@df data scatter(
    :age,
    :income,
    group = :gender,
    title = "Income by Age",
    xlabel = "Age (Years)",
    ylabel = "Income (\$)",
    legend = :topleft,
    alpha = 0.6,
    size = (800, 600),
    dpi = 300
)
```

## Layouts and Subplots

Compose complex figures using layouts.

```julia
p1 = plot(x, y)
p2 = histogram(x)
p3 = scatter(x, z)

plot(p1, p2, p3, layout = (3, 1)) # 3 rows, 1 column
# Or complex layout
plot(p1, p2, p3, layout = @layout [a{0.7h}; b c])
```

## Makie.jl (High Performance)

Use Makie for large datasets or GPU acceleration.

```julia
using CairoMakie

fig = Figure(resolution = (1200, 800))
ax = Axis(fig[1, 1], title = "Big Data")

scatter!(ax, large_x, large_y, markersize = 2)

save("plot.png", fig)
```

## Saving Plots

Explicitly save your outputs.

```julia
savefig("figure_1.png")
savefig("figure_1.pdf") # Vector graphics for papers
```

## Anti-Slop Checklist

- [ ] **No default titles**: "Plot 1" is unacceptable.
- [ ] **Units**: Axes labels must include units (e.g., "Time (s)").
- [ ] **Legends**: Remove if redundant, clarify if vague.
- [ ] **Colors**: Use colorblind-friendly palettes (e.g., `:viridis`).
- [ ] **Fonts**: Ensure font size is readable when resized.
