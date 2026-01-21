# Python Testing Patterns

Testing is essential for maintaining code quality. Production Python code should use `pytest` for testing, following these standards.

## Core Principles

1. **Specific Test Names**: Names should describe the scenario and expected outcome.
2. **Use Fixtures**: For clean setup and teardown of test data and resources.
3. **Test One Thing**: Each test function should focus on a specific behavior.
4. **No Slop in Tests**: Avoid `df`, `data`, etc., in test code. Use descriptive names for mock data.
5. **Type Check Tests**: Tests themselves should have type hints.

## Basic Test Structure

```python
# test_math_utils.py
from my_package.math_utils import calculate_growth

def test_calculate_growth_returns_correct_value() -> None:
    # Arrange
    initial = 100.0
    final = 110.0
    periods = 1
    
    # Act
    result = calculate_growth(initial, final, periods)
    
    # Assert
    assert result == 0.1

def test_calculate_growth_raises_error_for_zero_initial() -> None:
    import pytest
    
    with pytest.raises(ValueError, match="initial value must be positive"):
        calculate_growth(0.0, 110.0, 1)
```

## Using Fixtures

Fixtures provide a clean way to manage test dependencies and data.

```python
import pytest
import pandas as pd

@pytest.fixture
def sample_customer_data() -> pd.DataFrame:
    """Fixture providing a standard customer dataframe for testing."""
    return pd.DataFrame({
        "id": [1, 2, 3],
        "name": ["Alice", "Bob", "Charlie"],
        "revenue": [100.0, 200.0, 0.0],
        "status": ["active", "active", "inactive"]
    })

def test_filter_active_customers(sample_customer_data: pd.DataFrame) -> None:
    # Use the fixture data
    active_customers = filter_active_customers(sample_customer_data)
    
    assert len(active_customers) == 2
    assert "Charlie" not in active_customers["name"].values
```

## Parameterized Testing

Use `pytest.mark.parametrize` to test multiple inputs for the same function.

```python
@pytest.mark.parametrize("initial, final, expected", [
    (100.0, 121.0, 0.1),    # 2 periods at 10%
    (100.0, 100.0, 0.0),    # No growth
    (100.0, 50.0, -0.292),  # Decline (approx)
])
def test_calculate_growth_parametrized(initial: float, final: float, expected: float) -> None:
    result = calculate_growth(initial, final, periods=2)
    assert result == pytest.approx(expected, abs=1e-3)
```

## Mocking and Patching

Use `unittest.mock` (or `pytest-mock` plugin) to isolate the code under test.

```python
from unittest.mock import patch

def test_load_remote_config() -> None:
    # Mock the external API call
    with patch("my_package.api.get_json") as mock_get:
        mock_get.return_value = {"timeout": 30}
        
        config = load_remote_config("http://example.com")
        
        assert config["timeout"] == 30
        mock_get.assert_called_once_with("http://example.com")
```

## Data Science Testing

### Testing DataFrames
Use `pd.testing.assert_frame_equal` for robust comparison.

```python
from pandas.testing import assert_frame_equal

def test_transformation_pipeline(sample_customer_data: pd.DataFrame) -> None:
    result = run_pipeline(sample_customer_data)
    
    expected = pd.DataFrame({
        # ... expected structure ...
    })
    
    assert_frame_equal(result, expected)
```

### Testing Statistical Outputs
Use `pytest.approx` for floating point comparisons.

```python
def test_model_accuracy() -> None:
    accuracy = run_model_validation(data)
    assert accuracy == pytest.approx(0.95, abs=0.01)
```

## Directory Structure

Keep tests in a separate `tests/` directory mirroring your source structure.

```
my_package/
├── src/
│   └── my_module.py
└── tests/
    └── test_my_module.py
```

## Running Tests

```bash
# Run all tests
pytest

# Run tests with coverage
pytest --cov=src

# Run specific test file
pytest tests/test_my_module.py

# Run tests matching a pattern
pytest -k "calculate_growth"
```
