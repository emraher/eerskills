# Python Code Formatting and Standards

Consistent formatting reduces cognitive load and prevents "stylistic slop." Follow these standards for production Python code.

## Tooling

Always use automated tools to enforce formatting. This removes debate and ensures consistency.

### 1. ruff (Recommended)
`ruff` is an extremely fast Python linter and formatter that replaces many older tools (flake8, isort, black).

```bash
# Linting and automatic fixing
ruff check --fix

# Formatting
ruff format
```

### 2. black
If not using `ruff` for formatting, use `black`, the "uncompromising code formatter."

```bash
black script.py
```

## Core Standards (PEP 8+)

### 1. Line Length
Limit lines to **88 characters** (the `black` default) or **79 characters** (traditional PEP 8).

### 2. Indentation
Always use **4 spaces** per indentation level. Never use tabs.

### 3. Whitespace

- Use one blank line between functions and two blank lines between classes.
- Avoid extraneous whitespace inside parentheses, brackets, or braces.
- Use a single space around operators (`=`, `+`, `-`, etc.).

### 4. String Quotes
Use **double quotes `"`** for strings unless the string contains double quotes.

```python
# Good
name = "Alice"
greeting = 'He said, "Hello."' 

# Bad
name = 'Alice'
```

### 5. Multi-line Constructs
Prefer parentheses over backslashes for line continuation.

```python
# Good
my_list = [
    "first_item",
    "second_item",
    "third_item",
]

# Good (Method Chaining)
result = (
    data
    .query("x > 0")
    .groupby("cat")
    .mean()
)

# Bad
my_list = ["first_item", \
           "second_item"]
```

## Naming Standards (Summary)

| Entity | Pattern | Example |
|--------|---------|---------|
| Variables | `snake_case` | `user_id` |
| Functions | `snake_case` | `calculate_total()` |
| Classes | `PascalCase` | `CustomerProfile` |
| Constants | `ALL_CAPS` | `MAX_RETRIES` |
| Modules | `snake_case` | `data_utils.py` |

## Documentation Standards

Use **NumPy** or **Google** docstring formats for all public functions and classes.

### NumPy Style (Recommended for Data Science)
```python
def calculate_rate(numerator: float, denominator: float) -> float:
    """
    Calculate the rate between two numbers.

    Parameters
    ----------
    numerator : float
        The number to be divided
    denominator : float
        The number to divide by

    Returns
    -------
    float
        The calculated rate

    Raises
    ------
    ValueError
        If denominator is zero
    """
    if denominator == 0:
        raise ValueError("denominator cannot be zero")
    return numerator / denominator
```

## Integration with CI/CD

Formatting checks should be mandatory in your CI/CD pipeline:

```yaml
# .github/workflows/lint.yml
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: astral-sh/ruff-action@v1
        with:
          args: "check"
      - uses: astral-sh/ruff-action@v1
        with:
          args: "format --check"
```
