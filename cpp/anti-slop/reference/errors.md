# Error Handling in Rcpp

C++ exceptions must not propagate to the R runtime (it will crash R). Rcpp automatically catches C++ exceptions and turns them into R errors.

## The `stop()` Function

The standard way to signal an error is `Rcpp::stop()`. It behaves like `stop()` in R.

```cpp
// [[Rcpp::export]]
double divide(double x, double y) {
    if (y == 0) {
        stop("Division by zero");
    }
    return x / y;
}
```

## The `warning()` Function

Behaves like `warning()` in R.

```cpp
if (x < 0) {
    warning("Negative value detected");
}
```

## Exception Safety

If you allocate memory manually (`new`), you must catch exceptions to clean up.

**Unsafe**:
```cpp
double* ptr = new double[100];
stop("Error"); // 'ptr' leaks!
```

**Safe (RAII)**:
```cpp
std::vector<double> v(100);
stop("Error"); // 'v' destructor called automatically
```

## Standard C++ Exceptions

Rcpp wraps standard exceptions too.

```cpp
// [[Rcpp::export]]
int get_val(std::vector<int> v, int i) {
    return v.at(i); // Throws std::out_of_range
}
```

If `get_val` throws, R will see: `Error: vector::_M_range_check: __n (which is 10) >= this->size() (which is 5)`.

## Messages

Use `tfm::format` (TinyFormat) inside `stop` for formatted strings (like `sprintf`).

```cpp
stop("Invalid dimension: expected %d, got %d", expected, actual);
```
