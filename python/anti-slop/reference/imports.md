# Python Import Organization

Proper import organization reduces circular dependencies, improves readability, and distinguishes between internal and external dependencies.

## Core Rules

1. **Top of File**: All imports must be at the very top of the module, after any module-level docstrings but before module-level constants.
2. **One Per Line**: Generally, imports should be on separate lines, except when importing multiple items from the same sub-package.
3. **Alphabetical Order**: Within each group, imports should be sorted alphabetically.
4. **Absolute Imports**: Prefer absolute imports over relative imports.
5. **Avoid `import *`**: Never use wildcard imports. They pollute the namespace and make it unclear where names come from.

## Import Grouping

Group imports in the following order, with a single blank line between each group:

1. **Standard Library Imports** (e.g., `os`, `sys`, `pathlib`, `typing`)
2. **Third-Party Imports** (e.g., `pandas`, `numpy`, `sklearn`)
3. **Local Application/Library Imports** (internal modules)

### Example Structure

```python
"""Module-level docstring describing the purpose of the file."""

# 1. Standard library
import logging
import os
from pathlib import Path
from typing import Dict, List, Optional

# 2. Third-party
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from sklearn.ensemble import RandomForestClassifier

# 3. Local
from project_utils.config import load_settings
from project_utils.data_cleaning import normalize_names
from project_utils.models import BaseModel
```

## Import Style

### Direct Import vs. From Import

- **Packages/Modules**: Use `import module` or `import package.module`.
- **Classes/Functions**: Use `from module import ClassName` or `from module import function_name`.

```python
# Good: Clear where the name comes from
from typing import List
import pandas as pd

# Good for large packages
import sklearn.metrics as metrics
```

### Aliasing

Only alias when it's a standard convention or to avoid name collisions.

- **Standard Aliases**:
  - `import pandas as pd`
  - `import numpy as np`
  - `import matplotlib.pyplot as plt`
  - `import tensorflow as tf`
  - `import torch.nn as nn`

- **Avoid Non-Standard Aliases**:
  - `import pandas as p` (Bad)
  - `import numpy as n` (Bad)

## Circular Imports

If you encounter a circular import, reconsider your architecture. Common solutions:

1. **Move common code**: Extract the shared dependency into a third, lower-level module.
2. **Move imports into functions**: Import inside the function only when needed (last resort).
3. **Type hinting only**: Use `TYPE_CHECKING` for imports only needed for hints.

```python
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from my_package.models import User  # Only imported during type checking
```

## Lazy Loading

For large dependencies that are rarely used, you can import them within a function to save startup time.

```python
def generate_complex_plot(data: pd.DataFrame) -> None:
    # Heavy dependency imported only when function is called
    import plotly.express as px
    
    fig = px.scatter(data, x='a', y='b')
    fig.show()
```

## Validation Tools

Use `isort` or `ruff` to automatically organize your imports:

```bash
# Using isort
isort script.py

# Using ruff (faster)
ruff check --select I --fix script.py
```
