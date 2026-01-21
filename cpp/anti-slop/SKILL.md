---
name: cpp-anti-slop
description: >
  Best practices for Rcpp and C++ extensions. Enforces memory safety, const-correctness,
  and Rcpp sugar usage for performance-critical code.
---

# C++ Anti-Slop Skill for Rcpp

## Purpose
Prevents generic AI-generated C++ code by enforcing Rcpp best practices for performance-critical R extensions. Focuses on writing fast, safe C++ that integrates seamlessly with R.

## Core Principles

### 1. Rcpp First
- Use Rcpp's sugar for R-like syntax
- Leverage Rcpp data structures (NumericVector, DataFrame, etc.)
- Let Rcpp handle R's memory management
- Expose via `// [[Rcpp::export]]`

### 2. Modern C++ (C++11/14/17)
- Use `auto` for type deduction
- Range-based for loops
- Smart pointers for manual memory management
- STL algorithms over raw loops

### 3. Safety and Clarity
- Const-correctness
- Reference passing for large objects
- Bounds checking in development
- Clear variable names

## Basic Rcpp Function Structure

```cpp
#include <Rcpp.h>
using namespace Rcpp;

// CORRECT - complete, documented, type-safe
//' Calculate Mean of Numeric Vector
//'
//' @param x NumericVector input
//' @return double mean value
//' @examples
//' calculate_mean(c(1, 2, 3, 4, 5))
//' @export
// [[Rcpp::export]]
double calculate_mean(NumericVector x) {
    int n = x.size();
    
    if (n == 0) {
        stop("Input vector cannot be empty");
    }
    
    double sum = 0.0;
    for (int i = 0; i < n; i++) {
        if (NumericVector::is_na(x[i])) {
            stop("NA values not allowed");
        }
        sum += x[i];
    }
    
    return sum / n;
}

// WRONG - no documentation, no validation, unclear
// [[Rcpp::export]]
double calc(NumericVector v) {
    double s = 0;
    for (int i = 0; i < v.size(); i++) s += v[i];
    return s / v.size();
}
```

## Rcpp Data Types

```cpp
#include <Rcpp.h>
using namespace Rcpp;

// CORRECT - use appropriate Rcpp types
// [[Rcpp::export]]
List process_data(
    NumericVector numeric_col,
    IntegerVector integer_col,
    CharacterVector string_col,
    LogicalVector logical_col
) {
    int n = numeric_col.size();
    
    // Create output vectors
    NumericVector result_numeric(n);
    IntegerVector result_integer(n);
    
    // Process data
    for (int i = 0; i < n; i++) {
        result_numeric[i] = numeric_col[i] * 2.0;
        result_integer[i] = integer_col[i] + 1;
    }
    
    // Return named list
    return List::create(
        Named("numeric") = result_numeric,
        Named("integer") = result_integer,
        Named("input_string") = string_col[0]
    );
}

// Common Rcpp types
// NumericVector  -> double[]
// IntegerVector  -> int[]
// CharacterVector -> string[]
// LogicalVector  -> bool[]
// NumericMatrix  -> matrix of double
// DataFrame      -> R data.frame
// List           -> R list
// S4             -> S4 object
```

## Pass by Reference

```cpp
#include <Rcpp.h>
using namespace Rcpp;

// CORRECT - const reference for read-only, reference for modification
// [[Rcpp::export]]
double sum_product(const NumericVector& x, const NumericVector& y) {
    // const reference - no copy, can't modify
    int n = x.size();
    
    if (n != y.size()) {
        stop("Vectors must have same length");
    }
    
    double result = 0.0;
    for (int i = 0; i < n; i++) {
        result += x[i] * y[i];
    }
    
    return result;
}

// Modify in place
void standardize_inplace(NumericVector& x) {
    double mean_val = mean(x);
    double sd_val = sd(x);
    
    for (int i = 0; i < x.size(); i++) {
        x[i] = (x[i] - mean_val) / sd_val;
    }
}

// WRONG - pass by value (copies data unnecessarily)
double sum_product_slow(NumericVector x, NumericVector y) {
    // Copies both vectors
    // ...
}
```

## Rcpp Sugar

```cpp
#include <Rcpp.h>
using namespace Rcpp;

// CORRECT - use Rcpp sugar for R-like operations
// [[Rcpp::export]]
NumericVector standardize_vector(const NumericVector& x) {
    // Rcpp sugar provides vectorized operations
    double mean_x = mean(x);
    double sd_x = sd(x);
    
    // Vectorized operations
    NumericVector result = (x - mean_x) / sd_x;
    
    return result;
}

// Other sugar functions:
// mean(), var(), sd(), min(), max(), sum(), prod()
// abs(), exp(), log(), sqrt(), floor(), ceiling()
// ifelse(), any(), all()
// head(), tail(), rev(), seq_len(), seq_along()

// [[Rcpp::export]]
NumericVector clip_values(const NumericVector& x, double lower, double upper) {
    // Use ifelse for vectorized conditional
    NumericVector result = ifelse(x < lower, lower, 
                                   ifelse(x > upper, upper, x));
    return result;
}
```

## Error Handling

```cpp
#include <Rcpp.h>
using namespace Rcpp;

// CORRECT - validate inputs, provide informative errors
// [[Rcpp::export]]
double safe_division(double numerator, double denominator) {
    if (denominator == 0.0) {
        stop("Division by zero: denominator cannot be zero");
    }
    
    if (std::isnan(numerator) || std::isnan(denominator)) {
        stop("NaN values not allowed in division");
    }
    
    return numerator / denominator;
}

// [[Rcpp::export]]
NumericMatrix matrix_multiply(const NumericMatrix& A, const NumericMatrix& B) {
    int n = A.nrow();
    int m = A.ncol();
    int p = B.ncol();
    
    // Validate dimensions
    if (m != B.nrow()) {
        stop("Matrix dimensions incompatible: A cols (" + 
             std::to_string(m) + ") != B rows (" + 
             std::to_string(B.nrow()) + ")");
    }
    
    NumericMatrix result(n, p);
    
    // Matrix multiplication
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < p; j++) {
            double sum = 0.0;
            for (int k = 0; k < m; k++) {
                sum += A(i, k) * B(k, j);
            }
            result(i, j) = sum;
        }
    }
    
    return result;
}
```

## Performance Patterns

### Vectorization with RcppArmadillo

```cpp
// When you need linear algebra, use RcppArmadillo
#include <RcppArmadillo.h>
// [[Rcpp::depends(RcppArmadillo)]]

using namespace arma;

// [[Rcpp::export]]
arma::vec fast_matrix_vector_multiply(const arma::mat& A, const arma::vec& x) {
    return A * x;  // Optimized BLAS/LAPACK
}

// [[Rcpp::export]]
arma::mat fast_inverse(const arma::mat& A) {
    return inv(A);  // Efficient matrix inverse
}

// Solve linear system Ax = b
// [[Rcpp::export]]
arma::vec solve_system(const arma::mat& A, const arma::vec& b) {
    return solve(A, b);  // Better than inv(A) * b
}
```

### Parallelization with RcppParallel

```cpp
#include <Rcpp.h>
#include <RcppParallel.h>
// [[Rcpp::depends(RcppParallel)]]

using namespace Rcpp;
using namespace RcppParallel;

// Worker for parallel computation
struct SumSquares : public Worker {
    // Input vector
    const RVector<double> input;
    
    // Output value
    double sum_squares;
    
    // Constructor
    SumSquares(const NumericVector input) 
        : input(input), sum_squares(0) {}
    
    // Copy constructor for split
    SumSquares(const SumSquares& other, Split) 
        : input(other.input), sum_squares(0) {}
    
    // Accumulate sum of squares
    void operator()(std::size_t begin, std::size_t end) {
        sum_squares += std::accumulate(
            input.begin() + begin,
            input.begin() + end,
            0.0,
            [](double sum, double x) { return sum + x * x; }
        );
    }
    
    // Join results
    void join(const SumSquares& rhs) {
        sum_squares += rhs.sum_squares;
    }
};

// [[Rcpp::export]]
double parallel_sum_squares(NumericVector x) {
    SumSquares worker(x);
    parallelReduce(0, x.size(), worker);
    return worker.sum_squares;
}
```

## Working with DataFrames

```cpp
#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
DataFrame process_dataframe(DataFrame df) {
    // Extract columns
    NumericVector values = df["value"];
    CharacterVector categories = df["category"];
    
    int n = values.size();
    
    // Create new columns
    NumericVector log_values(n);
    IntegerVector category_codes(n);
    
    // Process
    for (int i = 0; i < n; i++) {
        log_values[i] = std::log(values[i] + 1);
        
        std::string cat = Rcpp::as<std::string>(categories[i]);
        if (cat == "A") {
            category_codes[i] = 1;
        } else if (cat == "B") {
            category_codes[i] = 2;
        } else {
            category_codes[i] = 0;
        }
    }
    
    // Return new DataFrame
    return DataFrame::create(
        Named("value") = values,
        Named("category") = categories,
        Named("log_value") = log_values,
        Named("category_code") = category_codes
    );
}
```

## C++11/14/17 Features

```cpp
#include <Rcpp.h>
using namespace Rcpp;

// CORRECT - use modern C++ features
// [[Rcpp::plugins(cpp11)]]

// Auto type deduction
// [[Rcpp::export]]
double sum_vector_modern(const NumericVector& x) {
    auto n = x.size();  // auto deduced as int
    auto sum = 0.0;     // auto deduced as double
    
    // Range-based for loop
    for (const auto& val : x) {
        sum += val;
    }
    
    return sum;
}

// Lambda functions
// [[Rcpp::export]]
NumericVector apply_function(const NumericVector& x) {
    int n = x.size();
    NumericVector result(n);
    
    // Lambda for transformation
    auto transform_func = [](double val) {
        return std::log(val + 1) * 2.0;
    };
    
    for (int i = 0; i < n; i++) {
        result[i] = transform_func(x[i]);
    }
    
    return result;
}

// Smart pointers for manual memory management
#include <memory>

class DataProcessor {
private:
    std::unique_ptr<double[]> buffer;
    int size;
    
public:
    DataProcessor(int n) : size(n) {
        buffer = std::make_unique<double[]>(n);
    }
    
    // Automatically cleaned up, no manual delete needed
};
```

## Common Performance Pitfalls

```cpp
#include <Rcpp.h>
using namespace Rcpp;

// WRONG - reallocating in loop
NumericVector bad_cumsum(const NumericVector& x) {
    NumericVector result;  // Starts empty
    double sum = 0.0;
    
    for (int i = 0; i < x.size(); i++) {
        sum += x[i];
        result.push_back(sum);  // Reallocates every iteration!
    }
    
    return result;
}

// CORRECT - pre-allocate
NumericVector good_cumsum(const NumericVector& x) {
    int n = x.size();
    NumericVector result(n);  // Pre-allocated
    double sum = 0.0;
    
    for (int i = 0; i < n; i++) {
        sum += x[i];
        result[i] = sum;  // Just assignment
    }
    
    return result;
}

// WRONG - copying vectors
double bad_sum(NumericVector x) {  // Copies input!
    // ...
}

// CORRECT - const reference
double good_sum(const NumericVector& x) {  // No copy
    // ...
}

// WRONG - unnecessary conversions
String process_string(const CharacterVector& cv) {
    std::string s = Rcpp::as<std::string>(cv[0]);  // Conversion
    String result = s;  // Another conversion
    return result;
}

// CORRECT - direct operations
String process_string_efficient(const CharacterVector& cv) {
    return cv[0];  // Direct return
}
```

## Rcpp Attributes

```cpp
#include <Rcpp.h>
using namespace Rcpp;

// Export function to R
// [[Rcpp::export]]
double my_function(double x) {
    return x * 2.0;
}

// Specify C++ standard
// [[Rcpp::plugins(cpp11)]]

// Depend on other packages
// [[Rcpp::depends(RcppArmadillo)]]
// [[Rcpp::depends(RcppParallel)]]

// Include additional headers
// [[Rcpp::interfaces(r, cpp)]]

// Set package namespace (in package development)
//' @export
// [[Rcpp::export]]
double package_function(double x) {
    return x;
}
```

## Testing and Debugging

```r
# In R, test your Rcpp functions
library(Rcpp)
sourceCpp("my_functions.cpp")

# Test
x <- rnorm(1000)
result <- calculate_mean(x)

# Benchmark against R
library(microbenchmark)

microbenchmark(
    cpp = calculate_mean(x),
    r = mean(x),
    times = 100
)

# Check for memory leaks
library(profmem)

profmem({
    for (i in 1:1000) {
        result <- my_cpp_function(x)
    }
})
```

## Rcpp in Packages

```cpp
// In src/functions.cpp of R package

#include <Rcpp.h>
using namespace Rcpp;

//' Calculate Sum of Squares
//'
//' Fast C++ implementation of sum of squares
//'
//' @param x Numeric vector
//' @return Sum of squared values
//' @examples
//' sum_of_squares(c(1, 2, 3, 4, 5))
//' @export
// [[Rcpp::export]]
double sum_of_squares(const NumericVector& x) {
    double sum = 0.0;
    for (const auto& val : x) {
        sum += val * val;
    }
    return sum;
}

// Then in R package:
# In NAMESPACE (generated by roxygen2)
# useDynLib(packagename, .registration = TRUE)
# importFrom(Rcpp, sourceCpp)

# In DESCRIPTION
# LinkingTo: Rcpp
# Imports: Rcpp
```

## Forbidden Patterns

```cpp
// WRONG - no validation
// [[Rcpp::export]]
double divide(double x, double y) {
    return x / y;  // What if y == 0?
}

// WRONG - raw pointers with manual memory management
// [[Rcpp::export]]
NumericVector allocate_memory(int n) {
    double* arr = new double[n];  // Manual allocation
    // ... 
    // Easy to leak memory if exception thrown!
    delete[] arr;
    return result;
}

// CORRECT - let Rcpp handle memory
// [[Rcpp::export]]
NumericVector allocate_memory_safe(int n) {
    NumericVector result(n);  // Rcpp handles cleanup
    return result;
}

// WRONG - returning raw C++ STL types
// [[Rcpp::export]]
std::vector<double> return_vector() {
    std::vector<double> v = {1, 2, 3};
    return v;  // R can't use this directly
}

// CORRECT - return Rcpp types
// [[Rcpp::export]]
NumericVector return_vector_correct() {
    NumericVector v = NumericVector::create(1, 2, 3);
    return v;
}
```

## Summary Checklist

- [ ] Use `// [[Rcpp::export]]` for R-visible functions
- [ ] Roxygen2 documentation (`//'`) for all exported functions
- [ ] Input validation with informative `stop()` messages
- [ ] Pass large objects by const reference
- [ ] Pre-allocate vectors before loops
- [ ] Use Rcpp sugar for vectorized operations
- [ ] Consider RcppArmadillo for linear algebra
- [ ] Use RcppParallel for embarrassingly parallel tasks
- [ ] Specify C++ standard with `[[Rcpp::plugins(cpp11)]]`
- [ ] Return Rcpp types, not raw C++ STL types
- [ ] Test performance with microbenchmark
- [ ] Check for memory leaks

## When to Use Rcpp

✓ **Use Rcpp when:**
- Loops that can't be vectorized in R
- Complex algorithms with many iterations
- Need to call C/C++ libraries
- Working with large matrices (use RcppArmadillo)
- Performance bottlenecks identified by profiling

✗ **Don't use Rcpp when:**
- Problem can be vectorized in R
- R functions are already fast enough
- Development time outweighs performance gain
- Debugging complexity not worth speedup

## Integration with R

```r
# Standalone Rcpp file
library(Rcpp)

# Source C++ file
sourceCpp("functions.cpp")

# Now use functions in R
result <- calculate_mean(c(1, 2, 3, 4, 5))

# In package, functions automatically available
library(yourpackage)
result <- sum_of_squares(x)
```

Claude should produce Rcpp code that:
- Is properly documented with roxygen2
- Validates inputs rigorously
- Uses const references appropriately
- Pre-allocates memory
- Leverages Rcpp sugar
- Would integrate seamlessly with R
- Would pass package checks
