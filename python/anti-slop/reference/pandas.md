# pandas Best Practices

pandas code often becomes "slop" when it relies on procedural mutation, generic names, and inefficient operations. Follow these standards for production-quality data science code.

## Core Principles

1. **Descriptive Names**: Never use `df` or `data`. Use `customer_data`, `monthly_sales`, etc.
2. **Method Chaining**: Prefer declarative chains over procedural updates.
3. **Explicit Copies**: Use `.copy()` when creating a subset or modifying data to avoid `SettingWithCopyWarning`.
4. **Avoid Mutation**: Minimize `inplace=True` usage (deprecated in many cases).
5. **Use `.query()` and `.eval()`**: For cleaner, readable filtering.

## Naming and Structure

```python
# Bad
df = pd.read_csv("data.csv")
df['x'] = df['y'] * 10
result = df.groupby('cat').sum()

# Good
customer_data = pd.read_csv("data/customers.csv")

# Create a clear derived dataset
customer_summary = (
    customer_data
    .assign(total_revenue=lambda x: x['revenue'] + x['bonus'])
    .groupby('category')
    .agg(
        mean_revenue=('total_revenue', 'mean'),
        customer_count=('id', 'count')
    )
    .reset_index()
)
```

## Method Chaining Patterns

Method chaining makes the data transformation pipeline explicit and readable.

```python
processed_sales = (
    raw_sales
    .rename(columns=str.lower)
    .query("amount > 0")
    .assign(
        tax_amount=lambda x: x['amount'] * 0.2,
        total_amount=lambda x: x['amount'] + x['tax_amount'],
        sale_date=lambda x: pd.to_datetime(x['timestamp'])
    )
    .sort_values('sale_date', ascending=False)
    .drop(columns=['timestamp'])
)
```

*Note: Use parentheses `()` to allow multi-line chains without backslashes.*

## Selection and Filtering

### Use `.loc` and `.iloc`
Be explicit about row and column selection.

```python
# Good: Explicit row and column selection
active_customer_emails = customer_data.loc[
    customer_data['is_active'] == True, 
    ['email', 'name']
]

# Bad: Ambiguous selection
emails = df[df.active == True][['email', 'name']]
```

### Use `.query()` for Complex Filters
It's often more readable than boolean indexing.

```python
# Good
threshold = 1000
high_value_segments = customer_data.query("revenue > @threshold & status == 'gold'")

# Bad
high_value_segments = customer_data[(customer_data['revenue'] > 1000) & (customer_data['status'] == 'gold')]
```

## Creating Derived Columns

Use `.assign()` for creating new columns in a chain.

```python
# Use lambda to reference the dataframe within the chain
clean_data = (
    data
    .assign(
        is_valuable=lambda x: x['revenue'] > x['revenue'].median(),
        days_since_last_order=lambda x: (pd.Timestamp.now() - x['last_order']).dt.days
    )
)
```

## Grouping and Aggregating

Use named aggregations for clear, descriptive output column names.

```python
# Good: Named aggregation
segment_stats = (
    customer_data
    .groupby('segment')
    .agg(
        avg_revenue=('revenue', 'mean'),
        max_age=('age', 'max'),
        unique_products=('product_id', 'nunique')
    )
)

# Bad: Multi-index columns that are hard to work with
stats = df.groupby('segment')['revenue'].agg(['mean', 'max'])
```

## Performance Pitfalls

### Never Iterrow
Iterating over rows with `iterrows()` or `itertuples()` is extremely slow. Use vectorized operations.

```python
# Bad (Slow)
for index, row in df.iterrows():
    df.at[index, 'total'] = row['a'] + row['b']

# Good (Fast)
df['total'] = df['a'] + df['b']
```

### Use Categorical Data
For columns with low cardinality (few unique values), use the `category` dtype to save memory and improve speed.

```python
customer_data['status'] = customer_data['status'].astype('category')
```

## Working with Types

Explicitly set types during loading or processing to prevent inference errors.

```python
customer_data = pd.read_csv(
    "customers.csv",
    dtype={
        'customer_id': 'int64',
        'zip_code': 'str',  # Prevents dropping leading zeros
        'status': 'category'
    },
    parse_dates=['signup_date']
)
```

## Copying and Subsetting

Always use `.copy()` when you intend to modify a subset of a larger dataframe.

```python
# Good: Independent dataframe
active_users = customer_data.query("status == 'active'").copy()
active_users['last_check'] = pd.Timestamp.now()

# Bad: Might trigger SettingWithCopyWarning
active_users = customer_data[customer_data['status'] == 'active']
active_users['last_check'] = pd.Timestamp.now()
```
