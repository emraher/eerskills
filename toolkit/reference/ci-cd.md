# CI/CD Integration Guide

Automating anti-slop checks ensures that generic AI patterns don't sneak back into your codebase.

## GitHub Actions

Create `.github/workflows/anti-slop.yml`:

```yaml
name: Anti-Slop Quality Check

on:
  pull_request:
    branches: [main, master]
  push:
    branches: [main, master]

jobs:
  check-quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          submodules: recursive

      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.10'

      - name: Set up R (Optional)
        uses: r-lib/actions/setup-r@v2
        if: hashFiles('**/*.R') != ''

      - name: Run Text Slop Detector
        run: |
          # Find all markdown files
          find . -name "*.md" -not -path "*/node_modules/*" -print0 | xargs -0 python3 toolkit/scripts/detect_slop.py >> report.txt
          
          # Check for failures (adjust grep pattern based on strictness)
          if grep -q "Severe slop detected" report.txt; then
            echo "::error::Severe AI slop patterns detected."
            cat report.txt
            exit 1
          fi
          
          # Warning only
          if grep -q "High slop detected" report.txt; then
            echo "::warning::High levels of generic AI text detected."
          fi

      - name: Run R Slop Detector
        if: hashFiles('**/*.R') != ''
        run: |
          Rscript toolkit/scripts/detect_slop.R . --verbose
```

## GitLab CI

Add to `.gitlab-ci.yml`:

```yaml
anti-slop-check:
  image: python:3.10
  script:
    - find . -name "*.md" -exec python3 toolkit/scripts/detect_slop.py {} \;
  allow_failure: true
  rules:
    - if: $CI_MERGE_REQUEST_ID
```

## Pre-commit Hook

Run checks locally before every commit.

1. Create `.git/hooks/pre-commit` (or use a framework like `pre-commit`):

```bash
#!/bin/sh

echo "Running Anti-Slop Check..."

# Check modified markdown files
files=$(git diff --cached --name-only --diff-filter=ACM | grep '\.md$')

if [ -n "$files" ]; then
    for file in $files; do
        python3 toolkit/scripts/detect_slop.py "$file"
        if [ $? -ne 0 ]; then
            echo "❌ Slop detected in $file"
            exit 1
        fi
    done
fi

exit 0
```

2. Make it executable: `chmod +x .git/hooks/pre-commit`

## Custom Thresholds

You can modify the wrapper scripts or the calls to enforce strictness.

- **Strict**: Fail on any "High" or "Severe" finding.
- **Lenient**: Fail only on "Severe".
- **Audit**: Never fail, just log/comment.
