# Toolkit Tests

This directory contains unit tests for the anti-slop toolkit scripts.

## Running Tests

You can run the tests using `unittest`:

```bash
# Run all tests
python3 -m unittest discover toolkit/tests

# Run specific test file
python3 toolkit/tests/test_detect_slop.py
python3 toolkit/tests/test_clean_slop.py
```

## Test Structure

- **test_detect_slop.py**: Tests the detection logic (scoring, pattern matching).
- **test_clean_slop.py**: Tests the cleanup logic (replacements, aggressive mode).

These tests import the core logic from the `external/cc-polymath` submodule to ensure the wrapped scripts behave as expected.
