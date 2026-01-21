# Performance Optimization in Rcpp

C++ is not automatically fast. Bad C++ can be slower than well-written R.

## 1. Loop Optimization

### Iterate Once
Don't loop multiple times if one pass suffices.

```cpp
// Bad
double sum_val = 0;
double sum_sq = 0;
for(int i=0; i<n; ++i) sum_val += x[i];
for(int i=0; i<n; ++i) sum_sq += x[i]*x[i];

// Good
for(int i=0; i<n; ++i) {
    sum_val += x[i];
    sum_sq += x[i]*x[i];
}
```

### Iterators
Use iterators or range-based loops for cleaner, often safer code.

```cpp
// Range-based (C++11)
for(double val : x) {
    total += val;
}

// Iterators
for(auto it = x.begin(); it != x.end(); ++it) {
    total += *it;
}
```

## 2. Const Correctness

Mark read-only parameters as `const`. This helps the compiler optimize and prevents bugs.

```cpp
// Good
double sum(const NumericVector& x) {
    // x cannot be modified here
}
```

## 3. Pass by Reference

Passing by value creates a copy (for STL containers) or overhead (for Rcpp objects). Pass complex objects by reference.

```cpp
// Bad (Copies std::vector)
double func(std::vector<double> v)

// Good
double func(const std::vector<double>& v)
```

## 4. Inlining

Small helper functions should be marked `inline` to avoid function call overhead.

```cpp
inline double square(double x) {
    return x * x;
}
```

## 5. Rcpp Sugar Performance

Sugar is convenient but can allocate temporary memory.

```cpp
// Allocates a temporary vector for x+y
res = x + y; 

// No allocation (faster)
for(int i=0; i<n; ++i) res[i] = x[i] + y[i];
```

**Rule**: Use Sugar for readability. Rewrite loops for critical bottlenecks if profiling shows Sugar allocation is the issue.

## 6. Calling R Functions from C++

Calling an R function (`Function f`) from C++ is extremely slow. Avoid it in loops.

```cpp
// Very Slow
for(int i=0; i<n; ++i) {
    res[i] = as<double>(r_func(x[i]));
}

// Better
// Rewrite the R function logic in C++
```

## 7. Profiling

Don't guess. Profile.

**In R**:
```r
library(profvis)
profvis({
    my_cpp_function(large_data)
})
```

**Microbenchmark**:
```r
library(microbenchmark)
microbenchmark(
    cpp = my_cpp_function(x),
    r = r_function(x)
)
```
