# Memory Management in Rcpp

Manual memory management (`new`/`delete`) is the biggest source of crashes and bugs in C++. Rcpp provides safe wrappers. Use them.

## 1. The Rule of Zero

**Don't** manage memory manually. Use containers that manage their own memory.

- Use `Rcpp::NumericVector` instead of `double*` + size.
- Use `std::vector` if you need a raw C++ container.
- Use `std::unique_ptr` if you absolutely need a pointer.

## 2. Rcpp Objects and Garbage Collection

Rcpp objects (`NumericVector`, `List`, `Function`) are protected from R's garbage collector while they are in scope in your C++ function.

```cpp
// Good
NumericVector x(10); // Protected

// Bad
SEXP x = PROTECT(allocVector(REALSXP, 10)); // Raw C API logic - hard to get right
UNPROTECT(1);
```

## 3. Allocating Memory

### Pre-allocation
Always pre-allocate if you know the size.

```cpp
// Good
NumericVector res(n);
for(int i=0; i<n; ++i) res[i] = i;

// Bad (Slow re-allocation)
NumericVector res;
for(int i=0; i<n; ++i) res.push_back(i);
```

### no_init
For performance, use `no_init` to skip zero-initialization if you are about to overwrite everything anyway.

```cpp
NumericVector res = no_init(n);
```

## 4. STL vs Rcpp Containers

- **`Rcpp::NumericVector`**: Best for returning to R or using R sugar. Thin wrapper around R memory.
- **`std::vector<double>`**: Best for pure C++ algorithms or using external C++ libraries. Deep copy when converting to/from R.

**Conversion**:
```cpp
// Copy R vector to std::vector
std::vector<double> cpp_vec = as<std::vector<double>>(r_vec);

// Copy std::vector to R vector
return wrap(cpp_vec);
```

## 5. View Without Copying

If you need to read an R object without copying it, use Rcpp types. They are proxies.

```cpp
// This is a view/reference, not a copy!
void inspect(NumericVector x) {
    x[0] = 100; // Modifies the actual R object passed in!
}
```

**Warning**: Be careful modifying input arguments in place. It violates R's functional semantics. Usually, `clone()` if you need to modify.

```cpp
NumericVector safe_modify(NumericVector x) {
    NumericVector y = clone(x); // Deep copy
    y[0] = 100;
    return y;
}
```

## 6. Avoiding Leaks

If you use `new`, you **must** use `delete`. If an exception is thrown before `delete`, you leak memory.

**Slop**:
```cpp
double* data = new double[n];
do_something_that_might_throw(); // If this throws, 'data' leaks!
delete[] data;
```

**Professional**:
```cpp
std::vector<double> data(n);
do_something_that_might_throw(); // 'data' is automatically cleaned up
```
