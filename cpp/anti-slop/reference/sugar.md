# Rcpp Sugar

Sugar allows you to write C++ code that looks like R code. It provides vectorized operations that are compiled into efficient loops (mostly).

## Arithmetic Operators

Standard operators work element-wise on Rcpp vectors.

```cpp
NumericVector x, y;
NumericVector z = x + y;
NumericVector w = x * 2.0;
NumericVector a = -x;
```

## Comparison Operators

Produce `LogicalVector`.

```cpp
LogicalVector mask = x > 0;
LogicalVector eq = x == y;
```

## Logical Operators

Element-wise logic.

```cpp
LogicalVector res = (x > 0) & (x < 10);
LogicalVector any = !mask;
```

## Mathematical Functions

Most R math functions are available.

```cpp
exp(x)
log(x)
sqrt(x)
abs(x)
floor(x)
ceil(x)
round(x, digits)
```

## Statistical Functions

```cpp
sum(x)
mean(x)
min(x)
max(x)
sd(x)
var(x)
cumsum(x)
diff(x)
```

## Control Functions

```cpp
// Vectorized ifelse (like R's ifelse)
NumericVector y = ifelse(x > 0, x, 0);

// all / any
bool b = is_true(all(x > 0));
bool c = is_true(any(x < 0));
```

## Performance Note

Sugar expressions create temporary objects.

`x = y + z + w` might create a temp vector for `y+z`, then another for `temp+w`.

For complex chains on large data, manual loops can be faster (and use less memory). For standard usage, Sugar is fast enough and much more readable.
