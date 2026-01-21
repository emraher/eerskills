# Python Naming Conventions

This reference covers naming standards to ensure code clarity and prevent generic AI-generated patterns.

## General Principles

1. **Be Specific**: Names should describe the content or purpose, not the data type.
2. **Avoid Slop**: Never use `df`, `data`, `result`, `temp`, or `obj`.
3. **Use snake_case**: All variables, functions, and modules should use lowercase with underscores.
4. **PascalCase for Classes**: Only classes use capitalized words without underscores.

## Forbidden Names vs. Alternatives

| Forbidden | Reason | Better Alternatives |
|-----------|--------|---------------------|
| `df` | Too generic | `customer_data`, `sales_records`, `filtered_results` |
| `data` | Everything is data | `raw_inputs`, `processed_features`, `payload` |
| `result` | Result of what? | `growth_rate`, `active_users`, `summary_stats` |
| `temp` | Too vague | `buffer`, `intermediate_val`, `cached_entry` |
| `obj` | Too generic | `model_instance`, `user_profile`, `request_body` |
| `item` | Use context | `row`, `element`, `user_id`, `product_code` |

## Variable Naming Patterns

### DataFrames and Collections
Always name based on the **entities** contained within.

```python
# Bad
df = pd.read_csv("customers.csv")
df2 = df[df['active'] == True]

# Good
customer_data = pd.read_csv("data/customers.csv")
active_customers = customer_data.query("active == True").copy()
```

### Boolean Variables
Use prefixes like `is_`, `has_`, or `should_`.

```python
# Bad
active = True
valid = False

# Good
is_active = True
has_permission = False
should_refresh_cache = True
```

### Counters and Accumulators
Be specific about what is being counted.

```python
# Bad
count = 0
total = 0

# Good
user_count = 0
total_revenue = 0.0
```

## Function Naming Patterns

Functions should start with a verb describing the action.

| Action | Pattern | Examples |
|--------|---------|----------|
| Retrieve data | `get_*`, `fetch_*`, `load_*` | `get_user_profile`, `load_config` |
| Process data | `calculate_*`, `compute_*`, `format_*` | `calculate_total_tax`, `format_date_string` |
| Validate | `is_*`, `validate_*`, `check_*` | `is_valid_email`, `validate_schema` |
| Modify | `update_*`, `set_*`, `remove_*` | `update_user_status`, `remove_expired_tokens` |

## Constants

Use ALL_CAPS for constants defined at the module level.

```python
MAX_RETRIES = 5
DEFAULT_TIMEOUT_SECONDS = 30
SUPPORTED_FILE_EXTENSIONS = [".csv", ".json", ".parquet"]
```

## Class Naming

Use PascalCase and ensure the name is a noun.

```python
# Good
class DatabaseConnection:
    ...

class CustomerProfile:
    ...

# Bad
class manage_data:  # snake_case
    ...

class RunningProcess:  # Participle instead of noun
    ...
```

## Contextual Naming in Loops

Avoid single-letter variables except for very standard index `i`, `j`, `k` in mathematical contexts.

```python
# Bad
for x in users:
    process(x)

# Good
for user in users:
    process_user(user)

# Also Good (unpacking)
for user_id, profile in user_registry.items():
    update_profile(user_id, profile)
```

## Avoiding Redundancy

Don't include the type in the name if it's already clear from the context or type hints.

```python
# Redundant
user_list = ["alice", "bob"]
customer_dict = {"id": 1}

# Better
users = ["alice", "bob"]
customer_metadata = {"id": 1}
```
