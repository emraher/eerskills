# Python Error Handling Patterns

Robust error handling is critical for production code. Generic AI-generated code often uses "silent failures" or over-broad `except:` blocks. Follow these standards.

## Core Principles

1. **Be Specific**: Catch only the exceptions you expect and can handle.
2. **Fail Fast**: Validate inputs at the start of functions.
3. **Provide Context**: Include relevant values and state in error messages.
4. **Never Pass Silently**: Avoid bare `except: pass` blocks.
5. **Use Custom Exceptions**: For domain-specific error logic.

## Input Validation

Don't wait for a deep nested function to fail. Check inputs immediately.

```python
def calculate_growth_rate(initial: float, final: float, periods: int) -> float:
    # Explicit validation
    if initial <= 0:
        raise ValueError(f"initial value must be positive, got {initial}")
    
    if periods < 1:
        raise ValueError(f"periods must be at least 1, got {periods}")
        
    return (final / initial) ** (1 / periods) - 1
```

## Exception Handling

### Specific Catching
Always specify the exception type.

```python
# Good: We know how to handle missing files
try:
    with open("config.json") as f:
        config = json.load(f)
except FileNotFoundError:
    config = DEFAULT_CONFIG
except json.JSONDecodeError as e:
    raise ValueError(f"Invalid JSON in config: {str(e)}")

# Bad: Broad exception catches things we didn't expect (like KeyboardInterrupt)
try:
    # ... code ...
except Exception as e:
    print("Something went wrong")
```

### Providing Context
Messages should help the user or developer understand *why* it failed.

```python
# Good
raise FileNotFoundError(
    f"Configuration file not found at {path}. "
    f"Please check your path or set the CONFIG_PATH env var."
)

# Bad
raise FileNotFoundError("File not found")
```

## Cleaning Up Resources

Use `with` statements (Context Managers) whenever possible. If not possible, use `try...finally`.

```python
# Good: Context manager handles closing even on error
with open("data.txt") as f:
    data = f.read()

# Manual cleanup
db = connect_db()
try:
    process_data(db)
finally:
    db.disconnect()  # Guaranteed to run
```

## Chaining Exceptions

When catching one exception and raising another, use `from` to preserve the traceback.

```python
try:
    data = pd.read_csv(file_path)
except pd.errors.ParserError as e:
    # Preserve the original error context
    raise ValueError(f"Failed to parse customer data from {file_path}") from e
```

## Custom Exceptions

Create custom classes for domain-specific errors.

```python
class DataValidationError(Exception):
    """Raised when data structure is invalid."""
    pass

class InsufficientPermissionsError(Exception):
    """Raised when user lacks required permissions."""
    def __init__(self, user_id: int, required_level: str):
        self.user_id = user_id
        self.required_level = required_level
        super().__init__(f"User {user_id} lacks {required_level} access")
```

## Logging Errors

In production, log the full traceback, but provide a user-friendly message.

```python
import logging

logger = logging.getLogger(__name__)

try:
    process_transaction(id=123)
except TransactionError as e:
    logger.exception("Transaction processing failed for ID 123")  # Logs full stack
    # Re-raise or handle
```

## Patterns to Avoid

### The Silent Killer
```python
# NEVER DO THIS
try:
    do_something()
except:
    pass
```

### Broad Exception with Generic Message
```python
# Bad
try:
    calculate()
except Exception:
    raise ValueError("Calculation failed")  # Lost the original reason
```

### Error Codes instead of Exceptions
```python
# Bad (C-style)
result = process_data()
if result == -1:
    print("Error")

# Good (Pythonic)
try:
    process_data()
except DataError:
    # handle error
```
