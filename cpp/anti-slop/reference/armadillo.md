# RcppArmadillo (Linear Algebra)

For matrix math, use Armadillo via `RcppArmadillo`. It provides a clean syntax similar to Matlab/R and uses BLAS/LAPACK for speed.

## Setup

```cpp
// [[Rcpp::depends(RcppArmadillo)]]
#include <RcppArmadillo.h>
using namespace arma;
```

## Types

- `arma::vec` (column vector)
- `arma::rowvec` (row vector)
- `arma::mat` (matrix)

## Interop with Rcpp

RcppArmadillo automatically handles conversion (with copying).

```cpp
// [[Rcpp::export]]
arma::mat matrix_mult(const arma::mat& A, const arma::mat& B) {
    return A * B;
}
```

## Common Operations

### Matrix Multiplication
```cpp
mat C = A * B;
```

### Element-wise Operations
Use `%` for element-wise mult (Schur product).

```cpp
mat C = A % B;
```

### Solving Systems
Solve `Ax = b` for `x`.

```cpp
vec x = solve(A, b);
```

### Inversion
Use `inv()` only if you need the actual inverse. `solve()` is faster and more stable for systems.

```cpp
mat Ai = inv(A);
```

### Decompositions

```cpp
mat U, V;
vec s;
svd(U, s, V, X); // Singular Value Decomposition
```

### Statistics

```cpp
vec m = mean(X, 0); // Column means
mat C = cov(X);     // Covariance matrix
```

## Performance Tips

1. **Avoid Copies**: Pass by `const arma::mat&`.
2. **Advanced Constructors**: You can wrap existing memory (R memory) without copying using `advanced` constructors, but be very careful about memory lifecycle.
3. **In-place**: Many functions have an in-place version (e.g., `ones(size)` vs `X.ones()`).
