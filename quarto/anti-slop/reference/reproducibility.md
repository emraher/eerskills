# Reproducibility in Quarto

A Quarto document is not just a report; it is a reproducible record of analysis.

## 1. Relative Paths

**Never** use absolute paths.

- **Bad**: `read.csv("/Users/me/data.csv")`
- **Good**: `read.csv("data/data.csv")`
- **Better**: Use the `here` package in R: `read.csv(here::here("data", "data.csv"))`

## 2. Environment Management

Your document should run in a defined environment.

### R (renv)
Use `renv` to capture package versions.
```r
renv::snapshot()
```

### Python (venv/conda)
Specify the kernel in the YAML or ensure the venv is active.
```yaml
jupyter: python3
```

## 3. Caching and Freezing

Long computations kill reproducibility because users avoid re-running them.

### Cache
Use `cache: true` for expensive chunks.
```yaml
execute:
  cache: true
```

### Freeze
Use `freeze: auto` for projects (websites/books). It re-renders only if the source file changed.
```yaml
execute:
  freeze: auto
```

## 4. Random Seeds

Always set a seed at the start of the document if you use random numbers.

**R**:
```r
set.seed(123)
```

**Python**:
```python
import numpy as np
np.random.seed(123)
```

## 5. Session Info

Always include a session info dump at the end of the document (often hidden or in an appendix).

**R**:
```r
sessionInfo()
```

**Python**:
```python
import session_info
session_info.show()
```

## 6. Self-Contained

The document should run from top to bottom without manual intervention.

- No `View(df)` calls.
- No `setwd()` calls (let Quarto/Project handle working dir).
- No hardcoded secrets (use environment variables/`.Renviron`).
