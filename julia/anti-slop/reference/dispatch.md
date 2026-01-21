# Multiple Dispatch Patterns

Multiple dispatch is Julia's core paradigm. It allows you to define function behavior based on the types of *all* arguments, not just the first one (as in traditional OOP).

## Core Principles

1. **Define behaviors, not just data**: Functions define what happens when types interact.
2. **Use Abstract Types**: Write generic code that works on `AbstractVector` or `Number` rather than `Vector{Int}`.
3. **Methods, not Functions**: You add *methods* to existing functions.

## Defining Dispatch

```julia
abstract type Shape end

struct Circle <: Shape
    radius::Float64
end

struct Rectangle <: Shape
    width::Float64
    height::Float64
end

# Generic fallback (optional)
area(s::Shape) = error("Area not defined for $(typeof(s))")

# Specialized methods
area(c::Circle) = π * c.radius^2
area(r::Rectangle) = r.width * r.height
```

## Abstract Type Hierarchy

Write your core logic against abstract types to support future extensions.

```julia
# Bad: Overly specific
function sum_elements(x::Vector{Float64})
    # Only works for Vector{Float64}
end

# Good: Generic
function sum_elements(x::AbstractVector{T}) where T<:Number
    # Works for any vector of numbers (including custom types)
end
```

## Parametric Dispatch

Use type parameters to enforce constraints while remaining generic.

```julia
# Accepts two vectors of the SAME element type
function dot_product(x::Vector{T}, y::Vector{T}) where T<:Real
    # ...
end

# Accepts any two vectors
function dot_product(x::Vector, y::Vector)
    # ...
end
```

## Trait-Based Dispatch

Use "traits" (Holy Traits pattern) when type hierarchy isn't enough. This is advanced but powerful.

```julia
abstract type FlyingTrait end
struct CanFly <: FlyingTrait end
struct NoFly <: FlyingTrait end

# Define trait for types
fly_trait(::Bird) = CanFly()
fly_trait(::Penguin) = NoFly()

# Dispatch on trait
move(animal) = move(fly_trait(animal), animal)
move(::CanFly, animal) = "Flying high!"
move(::NoFly, animal) = "Walking..."
```

## Extending Base

You can add methods to built-in functions for your custom types.

```julia
import Base: +

struct Point
    x::Int
    y::Int
end

# Define addition for Points
+(p1::Point, p2::Point) = Point(p1.x + p2.x, p1.y + p2.y)
```

## Slop vs. Idiomatic

**Slop (Type Checking)**:
```julia
function process(x)
    if typeof(x) == Int
        # do int stuff
    elseif typeof(x) == String
        # do string stuff
    end
end
```

**Idiomatic (Dispatch)**:
```julia
process(x::Int) = # do int stuff
process(x::String) = # do string stuff
```
