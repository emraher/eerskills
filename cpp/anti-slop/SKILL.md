---
name: cpp-anti-slop
description: >
  Enforce best practices for Rcpp and C++ extensions. 
  Prevents generic AI patterns through memory safety, const-correctness, 
  and Rcpp sugar usage for performance-critical code.
applies_to:
  - "**/*.cpp"
  - "**/*.h"
  - "**/*.hpp"
tags: [cpp, rcpp, performance, memory-safety, r-extensions]
related_skills:
  - r/anti-slop
version: 2.0.0
---

# C++ Anti-Slop Skill for Rcpp Extensions

## When to Use This Skill

Use cpp-anti-slop when:
- ✓ Writing C++ extensions for R using Rcpp
- ✓ Optimizing performance-critical bottlenecks in R packages
- ✓ Reviewing AI-generated C++ code for memory safety
- ✓ Refactoring legacy Rcpp code for modern standards
- ✓ Implementing complex algorithms that require low-level control
- ✓ Ensuring RAII and const-correctness in R-adjacent code

Do NOT use when:
- Writing general-purpose C++ apps unconnected to R (though standards apply)
- Performance is not a bottleneck (use R or Julia first)
- Working with legacy C code that cannot be wrapped in C++

## Quick Example

**Before (AI Slop)**:
```cpp
// Generic C-style processing
// [[Rcpp::export]]
NumericVector process(NumericVector x) {
    int n = x.size();
    double* res = new double[n]; // Manual memory management (unsafe!)
    for(int i=0; i<n; i++) {
        res[i] = x[i] * 2.0;
    }
    NumericVector out(n);
    for(int i=0; i<n; i++) out[i] = res[i];
    delete[] res;
    return out;
}
```

**After (Anti-Slop)**:
```cpp
#include <Rcpp.h>
using namespace Rcpp;

//' Calculate Doubled Values Efficiently
//'
//' @param raw_values Input numeric vector
//' @return Vector with all elements doubled
// [[Rcpp::export]]
NumericVector calculate_doubled_values(const NumericVector& raw_values) {
    // Rcpp sugar provides vectorized operations (no explicit loop needed)
    // No manual memory management; Rcpp handles allocation/cleanup
    return raw_values * 2.0;
}
```

**What changed**:
- ✓ Descriptive name (`calculate_doubled_values` not `process`)
- ✓ Pass by const reference (`const NumericVector&`) to avoid copies
- ✓ Leveraged Rcpp sugar for vectorized performance
- ✓ Eliminated unsafe manual memory management (`new`/`delete`)
- ✓ Proper roxygen2 documentation

## When to Use What

| If you need to... | Do this | Details |
|-------------------|---------|---------|
| Manage memory | Use RAII and Rcpp containers | reference/memory.md |
| Write fast loops | Use `const` references + Rcpp sugar | reference/performance.md |
| Interface with R | Use `// [[Rcpp::export]]` | reference/rcpp-api.md |
| Handle errors | Use `Rcpp::stop()` for R-friendly errors | reference/errors.md |
| Vectorize | Use Rcpp sugar functions | reference/sugar.md |
| Linear Algebra | Use `RcppArmadillo` | reference/armadillo.md |

## Core Workflow

### 5-Step Quality Check

1. **Memory Safety** - No manual `new`/`delete`; use Rcpp containers or smart pointers
   ```cpp
   // Good
   NumericVector results(n);
   
   // Bad
   double* results = new double[n];
   ```

2. **Const Correctness** - Mark read-only inputs as `const&`
   ```cpp
   double calculate_sum(const NumericVector& x)
   ```

3. **Rcpp Sugar** - Use vectorized R-like syntax where available
   ```cpp
   return mean(x) + sd(y);
   ```

4. **Input Validation** - Check dimensions and types early
   ```cpp
   if (x.size() != y.size()) {
       stop("Incompatible dimensions");
   }
   ```

5. **Modern C++** - Use `auto`, range-based for loops, and STL algorithms
   ```cpp
   for (const auto& val : x) { ... }
   ```

## Quick Reference Checklist

Before committing C++ code, verify:

- [ ] All exported functions have `// [[Rcpp::export]]`
- [ ] Large objects passed by `const&` to avoid copies
- [ ] No manual memory management (`new`/`delete`)
- [ ] Rcpp sugar used for vectorization where possible
- [ ] Informative error messages with `stop()`
- [ ] Headers organized: Rcpp → standard library → local
- [ ] No single-letter variables except for standard indices
- [ ] Roxygen2 documentation for all public functions
- [ ] Type safety ensured throughout the algorithm
- [ ] Properly pre-allocated containers

## Common Workflows

### Workflow 1: Optimize an R Loop in C++

**Context**: An R loop is too slow and needs a C++ implementation.

**Steps**:

1. **Create the skeleton**
   ```cpp
   #include <Rcpp.h>
   using namespace Rcpp;
   // [[Rcpp::export]]
   ```

2. **Define the signature with references**
   ```cpp
   NumericVector fast_algorithm(const NumericVector& input_data)
   ```

3. **Pre-allocate the result**
   ```cpp
   int n = input_data.size();
   NumericVector results = no_init(n); // Fast allocation
   ```

4. **Implement the logic with Rcpp sugar**
   ```cpp
   results = exp(input_data) / sum(input_data);
   ```

**Expected outcome**: Significantly faster execution with R-compatible output

---

### Workflow 2: Safe Memory Management

**Context**: Dealing with complex data structures without leaking memory.

**Steps**:

1. **Avoid raw pointers**
   ```cpp
   // Instead of double* arr, use:
   std::vector<double> dynamic_buffer;
   ```

2. **Use Rcpp containers for R-interop**
   ```cpp
   List output = List::create(Named("data") = results);
   ```

3. **Protect against exceptions**
   - Rcpp handles C++ exceptions and translates them to R errors automatically.

**Expected outcome**: Crash-proof code that cleans up after itself

---

### Workflow 3: Matrix Operations with Armadillo

**Context**: High-performance linear algebra.

**Steps**:

1. **Add the dependency**
   ```cpp
   // [[Rcpp::depends(RcppArmadillo)]]
   #include <RcppArmadillo.h>
   ```

2. **Use Armadillo types**
   ```cpp
   arma::mat compute_inverse(const arma::mat& X) {
       return inv(X);
   }
   ```

**Expected outcome**: BLAS/LAPACK optimized matrix calculations

## Mandatory Rules Summary

### 1. No Manual Memory Management
Always use Rcpp classes (`NumericVector`, `List`, `DataFrame`) or STL containers (`std::vector`, `std::unique_ptr`).

### 2. Pass by Reference
Avoid unnecessary copies. Pass large objects as `const Type&`.

### 3. R-Friendly Errors
Use `Rcpp::stop("message")` instead of `std::runtime_error` or `exit()`.

### 4. Rcpp Sugar
Favor `mean(x)` over manual loops for simple vector operations.

### 5. RAII Principles
Ensure resources are tied to object lifetime to prevent leaks.

## Resources & Advanced Topics

### Reference Files (Planned)

- **reference/memory.md** - RAII and container management
- **reference/performance.md** - Profiling and optimization
- **reference/rcpp-api.md** - Deep dive into Rcpp classes
- **reference/sugar.md** - Vectorized sugar functions
- **reference/armadillo.md** - Linear algebra with Armadillo

### Related Skills

- **r/anti-slop** - The primary consumer of Rcpp extensions

### Tools

- `microbenchmark` - For verifying performance gains in R
- `valgrind` - For memory leak detection
- `Rcpp::sourceCpp()` - For rapid development and testing
