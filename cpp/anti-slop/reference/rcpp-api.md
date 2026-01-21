# Rcpp API Reference

Common Rcpp classes and how to use them.

## Vectors (R Interop)

- `NumericVector`: Vectors of doubles (`REALSXP`).
- `IntegerVector`: Vectors of integers (`INTSXP`).
- `CharacterVector`: Vectors of strings (`STRSXP`).
- `LogicalVector`: Vectors of booleans (`LGLSXP`).

### Common Methods
- `.size()`: Number of elements.
- `[i]`: Access element (0-based index).
- `.push_back(val)`: Append (avoid if possible, slow).

```cpp
NumericVector v = {1.0, 2.0, 3.0};
v[0] = 5.0;
```

## Matrix

- `NumericMatrix`: Matrix of doubles.
- `IntegerMatrix`: Matrix of integers.

```cpp
NumericMatrix m(3, 3); // 3x3 matrix (0-initialized)
int rows = m.nrow();
int cols = m.ncol();
m(0, 1) = 5.0; // Access row 0, col 1
```

## List

Heterogeneous container (like R list).

```cpp
List L = List::create(
    Named("name") = "Alice",
    Named("scores") = NumericVector::create(1, 2, 3)
);

// Access
std::string name = L["name"];
NumericVector scores = L["scores"];
```

## DataFrame

Wrapper around a List of vectors of same length.

```cpp
DataFrame create_df(int n) {
    NumericVector x(n);
    CharacterVector y(n);
    
    return DataFrame::create(
        Named("val") = x,
        Named("cat") = y
    );
}
```

## NA Handling

Checking for missing values.

- `NumericVector::is_na(x[i])`
- `IntegerVector::is_na(x[i])`

**Setting NA**:
- `NA_REAL`: For double
- `NA_INTEGER`: For int
- `NA_STRING`: For string

```cpp
if (NumericVector::is_na(v[i])) {
    v[i] = 0; // Impute
}
```

## Type Conversion (`as` and `wrap`)

- `as<Type>(sexp)`: Convert R object (SEXP) to C++ type.
- `wrap(obj)`: Convert C++ object to R object (SEXP).

```cpp
// Explicit conversion
std::vector<double> cpp_v = as<std::vector<double>>(r_v);

// Implicit conversion (return)
return cpp_v; // Automatically calls wrap()
```
