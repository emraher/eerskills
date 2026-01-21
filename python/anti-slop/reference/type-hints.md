# Python Type Hinting Guide

Type hints are a mandatory requirement for production-quality Python code. They improve readability, enable better IDE support, and catch bugs before runtime.

## Core Rules

1. **Mandatory Signatures**: Every function and method must have type hints for all parameters and the return value.
2. **Be Specific**: Use `List[str]` instead of just `List`, or `Optional[User]` instead of `Any`.
3. **Avoid `Any`**: Using `Any` defeats the purpose of type checking. Use specific types, `Union`, or generics.
4. **Use `Optional`**: Explicitly mark values that can be `None`.

## Basic Types

```python
def process_user(
    name: str,
    age: int,
    is_active: bool,
    score: float
) -> None:
    ...
```

## Collections (Python 3.9+)

Use built-in types for collections in modern Python.

```python
def analyze_scores(
    scores: list[float],
    metadata: dict[str, str],
    unique_ids: set[int]
) -> tuple[float, float]:
    ...
```

*Note: For Python < 3.9, import from `typing`: `from typing import List, Dict, Set, Tuple`.*

## Optional and Union Types

```python
from typing import Optional, Union

def get_user_name(user_id: int) -> Optional[str]:
    """Returns name if found, else None."""
    ...

def calculate_area(
    shape: Union[Circle, Square, Triangle]
) -> float:
    ...
```

## Data Science Types

### pandas and numpy

While `pd.DataFrame` is a common hint, it doesn't specify columns. Use comments or specific libraries like `pandera` if structural validation is needed, but always at least hint the base type.

```python
import pandas as pd
import numpy as np

def calculate_clv(
    customer_data: pd.DataFrame,
    rates: np.ndarray
) -> pd.Series:
    ...
```

## Complex Structures

### Type Aliases
Use aliases to simplify complex signatures.

```python
from typing import Dict, List, Tuple

# Define alias
UserRegistry = Dict[int, Tuple[str, List[str]]]

def update_registry(registry: UserRegistry) -> UserRegistry:
    ...
```

### TypedDict
Use `TypedDict` for dictionaries with a fixed set of keys and specific value types.

```python
from typing import TypedDict

class UserProfile(TypedDict):
    id: int
    username: str
    email: Optional[str]

def save_profile(profile: UserProfile) -> bool:
    ...
```

## Class Methods and `self`

You don't need to hint `self` or `cls`.

```python
class DataAnalyzer:
    def __init__(self, data: pd.DataFrame) -> None:
        self.data = data

    def get_summary(self) -> pd.Series:
        return self.data.describe()
```

## Forward References

If you need to hint a type defined later in the file, use a string or `from __future__ import annotations`.

```python
from __future__ import annotations

class Node:
    def __init__(self, value: int, parent: Optional[Node] = None) -> None:
        ...
```

## Generics

Use `TypeVar` for functions that work with multiple types but maintain a relationship between inputs and outputs.

```python
from typing import TypeVar, List

T = TypeVar('T')

def get_first_element(elements: List[T]) -> T:
    return elements[0]
```

## Validation Tools

Always run `mypy` to verify your type hints:

```bash
# Standard check
mypy script.py

# Strict check (recommended)
mypy --strict script.py
```

Common `mypy` error resolutions:
- **"Incompatible types in assignment"**: Ensure variable is hinted correctly at first use.
- **"Item 'None' of 'Optional' has no attribute"**: Add an explicit `is not None` check.
- **"Missing return statement"**: Ensure all code paths return the specified type.
