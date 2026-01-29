# Integration Guide: Anti-Slop Skills & Posit Skills

## Overview

This guide explains how Anti-Slop skills integrate with Posit skills and other learning resources. These skill sets are **complementary equals**, not hierarchical.

## Key Distinction

### Posit Skills: How-To Resources
- Teach syntax, features, and patterns
- Provide implementation guidance
- Document best practices and conventions
- Examples: quarto/authoring, r-lib/cli, r-lib/testing

### Anti-Slop Skills: Quality Enforcement
- Prevent generic AI-generated patterns
- Enforce production-quality standards
- Catch common mistakes and antipatterns
- Provide automated detection tools

**Both are essential. Neither is subordinate.**

## Installation

### Installing Both Skill Sets

1. **Install Posit Skills** (if using official Posit skill repository):
   ```bash
   # Follow Posit skill installation instructions
   # Typically: clone repo and configure skill manager
   ```

2. **Install Anti-Slop Skills**:
   ```bash
   # Clone Anti-Slop skills repository
   git clone https://github.com/your-username/anti-slop-skills.git

   # Configure in your skill manager
   # Add path to anti-slop-skills directory
   ```

3. **Verify Installation**:
   ```bash
   # Check available skills
   skill list | grep -E "(posit|anti-slop)"
   ```

Both skill sets work independently and can be used together seamlessly.

## Quick Start for Common Tasks

**Writing an R package function:**
```bash
# 1. Learn structure (Posit)
claude --skill r-lib/cli "explain cli_alert patterns"

# 2. Write code
# 3. Enforce quality (Anti-Slop)
Rscript toolkit/scripts/detect_slop.R R/my-function.R --verbose
```

**Creating reproducible research:**
```bash
# 1. Learn Quarto (Posit)
claude --skill quarto/authoring "setup paper template"

# 2. Write content
# 3. Check quality (Anti-Slop)
python3 toolkit/scripts/detect_slop.py paper.qmd
claude --skill quarto/anti-slop "review paper.qmd"
```

**Cleaning up AI-generated text:**
```bash
# 1. Detect issues
python3 toolkit/scripts/detect_slop.py README.md --verbose

# 2. Preview fixes
python3 toolkit/scripts/clean_slop.py README.md

# 3. Apply with backup
python3 toolkit/scripts/clean_slop.py README.md --save
```

## Complementary Use Patterns

### Pattern 1: Learning + Enforcement

**Scenario**: Writing a new Quarto document

```
1. Learn syntax → posit/quarto/authoring
   - How to use #| syntax
   - Cross-reference features
   - Format options

2. Enforce quality → quarto/anti-slop
   - Complete YAML metadata
   - Proper cross-references
   - Reproducibility standards
```

**Example workflow**:
```bash
# Step 1: Learn Quarto syntax
skill invoke posit/quarto/authoring
# Ask: "How do I create a cross-reference to a figure?"

# Step 2: Review quality
skill invoke quarto/anti-slop
# Ask: "Check my Quarto document for reproducibility issues"
```

---

### Pattern 2: Implementation + Review

**Scenario**: Creating R package with error messages

```
1. Implement → posit/r-lib/cli
   - cli_abort() structure
   - Formatting with {.field}
   - Error message templates

2. Review → r/anti-slop
   - No generic error messages
   - Descriptive variable names
   - Namespace qualification
```

**Example workflow**:
```r
# Step 1: Learn cli structure (posit/r-lib/cli)
cli::cli_abort(
  "Can't process {.field {col}} with type {.type {type}}.",
  class = "error_invalid_type"
)

# Step 2: Review with r/anti-slop
# Checks: Is error message specific? Are variables named well?
# Enforces: Namespace qualification, explicit returns
```

---

### Pattern 3: Testing + Quality

**Scenario**: Writing tests for R package

```
1. Learn patterns → posit/r-lib/testing
   - testthat 3 structure
   - Snapshot testing
   - Fixture patterns

2. Enforce standards → r/anti-slop
   - Descriptive test names
   - No generic variables in tests
   - Proper setup/teardown
```

**Example workflow**:
```r
# Step 1: Learn testthat patterns (posit/r-lib/testing)
test_that("calculate_rate() handles zero denominator", {
  # Test implementation
})

# Step 2: Review with r/anti-slop
# Checks: Test name specific? Variables descriptive?
# Enforces: No df/data/result in test code
```

---

### Pattern 4: Migration + Standards

**Scenario**: Converting RMarkdown to Quarto

```
1. Learn migration → posit/quarto/authoring
   - Syntax differences
   - YAML conversion
   - Chunk option changes

2. Enforce quality → quarto/anti-slop
   - Complete metadata
   - Update cross-references
   - Verify reproducibility
```

**Example workflow**:
```bash
# Step 1: Learn migration (posit/quarto/authoring)
# Convert chunk options from {r, fig.cap="..."} to #| fig-cap: "..."

# Step 2: Enforce standards (quarto/anti-slop)
# Check: YAML complete? Cross-refs updated? Paths relative?
```

## Comprehensive Integration Table

| Task | Posit Skill | Anti-Slop | Why Both? |
|------|-------------|---------------|-----------|
| **Write Quarto doc** | quarto/authoring (syntax) | quarto/anti-slop (quality) | Learn features + enforce standards |
| **Create R package** | r-lib/testing (patterns) | r/anti-slop (code quality) | Learn structure + prevent slop |
| **Format errors** | r-lib/cli (cli functions) | r/anti-slop (message quality) | Use cli correctly + avoid generic text |
| **Deprecate functions** | r-lib/lifecycle (workflow) | r/anti-slop (doc quality) | Follow lifecycle + clear docs |
| **CRAN submission** | r-lib/cran-extrachecks (requirements) | r/anti-slop (code standards) | Meet CRAN rules + production quality |
| **Write documentation** | posit/*/docs | text/anti-slop (prose quality) | Document features + direct language |
| **Create visualizations** | Any viz tutorial | design/anti-slop (quality) | Learn ggplot2 + intentional design |
| **Python typing** | Python docs | python/anti-slop (type enforcement) | Learn type hints + ensure usage |

## Example Workflows

### Workflow 1: Create Production R Package

**Goal**: Build R package ready for CRAN submission

**Integration steps**:

1. **Structure** (Posit skills):
   ```r
   # Use posit/r-lib/testing for test structure
   # Use posit/r-lib/cli for error messages
   # Use posit/r-lib/lifecycle for deprecations
   ```

2. **Quality** (Anti-Slop):
   ```r
   # Run r/anti-slop on all R code
   # Check namespace qualification
   # Verify explicit returns
   # Remove generic variable names
   ```

3. **Documentation** (Both):
   ```r
   # Learn roxygen from Posit resources
   # Enforce specific descriptions with r/anti-slop
   # No "@param data The data" patterns
   ```

4. **Final checks**:
   ```r
   # posit/r-lib/cran-extrachecks - CRAN requirements
   # r/anti-slop - Code quality standards
   # Both required for successful submission
   ```

**Expected outcome**: Package that meets CRAN standards AND maintains high code quality.

---

### Workflow 2: Create Academic Paper

**Goal**: Write reproducible research paper in Quarto

**Integration steps**:

1. **Learn Quarto** (posit/quarto/authoring):
   - Cross-reference syntax
   - Citation management
   - Multi-format output

2. **Enforce standards** (quarto/anti-slop):
   - Complete YAML metadata
   - Label all figures/tables
   - Use @fig-* cross-references
   - Proper bibliography setup

3. **Clean code** (r/anti-slop):
   - R code chunks with descriptive names
   - Namespace qualification in chunks
   - No generic variable names

4. **Clean prose** (text/anti-slop):
   - Remove "delve into" patterns
   - Direct language in methods
   - No meta-commentary

**Expected outcome**: Publication-ready manuscript with reproducible code.

---

### Workflow 3: Build Data Analysis Pipeline

**Goal**: Create robust, maintainable analysis pipeline

**Integration steps**:

1. **Learn patterns** (various resources):
   - Python typing (Python docs)
   - Error handling (language guides)
   - Testing patterns (pytest docs)

2. **Enforce quality** (Anti-Slop):
   - python/anti-slop for type hints
   - r/anti-slop for R components
   - text/anti-slop for documentation

3. **Automate checks** (toolkit):
   - CI/CD integration
   - Pre-commit hooks
   - Automated detection

**Expected outcome**: Production-quality pipeline with quality gates.

---

### Workflow 4: Create Data Visualization

**Goal**: Build publication-quality data visualization

**Integration steps**:

1. **Learn ggplot2/matplotlib** (tutorials, books):
   - Syntax and features
   - Geoms and themes
   - Customization options

2. **Enforce quality** (design/anti-slop):
   - Proper axis labels
   - Meaningful titles
   - Appropriate color scales
   - No generic defaults

3. **Document properly** (text/anti-slop):
   - Clear figure captions
   - Direct description
   - No generic "Plot 1" titles

**Expected outcome**: Professional visualization ready for publication.

## When to Use What

### Use Posit Skills When:
- ✓ Learning new syntax or features
- ✓ Understanding package structure
- ✓ Following specific conventions (tidyverse, etc.)
- ✓ Migrating between tools
- ✓ Implementing specific patterns

### Use Anti-Slop When:
- ✓ Reviewing code for generic patterns
- ✓ Enforcing production quality standards
- ✓ Preparing for public release
- ✓ Cleaning up AI-generated code
- ✓ Establishing team coding standards

### Use Both When:
- ✓ Creating new projects from scratch
- ✓ Refactoring existing code
- ✓ Preparing packages for distribution
- ✓ Writing reproducible research
- ✓ Teaching/enforcing best practices

## Common Questions

### Q: Do I need both skill sets?

**A**: Depends on your goals:
- **Learning**: Posit skills sufficient for syntax/features
- **Production**: Anti-slop ensures quality
- **Best practice**: Use both for complete coverage

### Q: Which should I use first?

**A**: Typically **learn first, enforce second**:
1. Learn syntax with Posit/books/docs
2. Write implementation
3. Review quality with anti-slop
4. Refactor as needed

But you can also use anti-slop first to understand standards before implementing.

### Q: Can I use anti-slop without Posit skills?

**A**: Yes! Anti-slop skills work with ANY learning resource:
- Books (R for Data Science, Python Crash Course)
- Online courses (DataCamp, Coursera)
- Official documentation
- Other skill repositories

### Q: Are there conflicts between skill sets?

**A**: No. They address different concerns:
- **Posit**: "How do I do X?"
- **Anti-slop**: "Is X done well?"

If apparent conflict arises, it's usually:
- Posit teaches general pattern
- Anti-slop enforces specific quality standard
- Both can be satisfied

### Q: How do I integrate into CI/CD?

**A**: Use toolkit for automation:
```yaml
# .github/workflows/quality.yml
jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Check code quality
        run: |
          # Use toolkit detection scripts
          python scripts/detect_slop.py docs/*.md
          Rscript scripts/detect_slop.R R/*.R
```

### Q: Can I contribute to anti-slop skills?

**A**: Yes! These are community resources:
- Report issues
- Suggest patterns to detect
- Contribute detection scripts
- Share integration patterns

## Best Practices

### 1. Don't Over-Enforce

**Good**:
- Use anti-slop for production code
- Set reasonable thresholds (score < 40)
- Allow exceptions for valid reasons

**Bad**:
- Enforce on exploratory notebooks
- Reject all generic names without context
- Ignore domain-specific conventions

### 2. Combine Learning Sources

**Good**:
- Learn from Posit + books + docs
- Enforce quality with anti-slop
- Adjust standards to project needs

**Bad**:
- Rely only on one resource
- Skip quality review entirely
- Blindly follow any single guide

### 3. Automate What You Can

**Good**:
- Use toolkit for routine checks
- Manual review for nuanced cases
- CI/CD for consistent enforcement

**Bad**:
- Manual checks for everything
- Blind automated cleanup
- No verification of changes

### 4. Document Exceptions

**Good**:
```r
# Generic name OK here - matches math notation
x <- seq(0, 10, by = 0.1)
y <- sin(x)
```

**Bad**:
```r
# Just ignore anti-slop warnings
df <- load_data()
```

### 5. Team Standards

**Good**:
- Establish clear thresholds
- Document acceptable patterns
- Regular standards review
- Training on both skill sets

**Bad**:
- No documented standards
- Inconsistent enforcement
- No team discussion
- Skills war between camps

## Troubleshooting Integration

### Issue: Conflicting Recommendations

**Symptoms**: Posit skill suggests one approach, anti-slop flags it

**Solution**:
1. Understand both recommendations
2. Check if anti-slop has false positive
3. Often both can be satisfied
4. Document if legitimate exception

**Example**:
```r
# Posit teaches: Use data argument consistently
my_function <- function(data) { }

# Anti-slop flags: Generic name 'data'

# Resolution: Both satisfied
my_function <- function(customer_data) { }
```

### Issue: Too Many Anti-Slop Warnings

**Symptoms**: Everything flagged, team frustrated

**Solution**:
1. Adjust thresholds (increase acceptable scores)
2. Check for domain-specific patterns
3. Whitelist acceptable exceptions
4. Focus on high-priority patterns first

### Issue: Skill Not Loading

**Symptoms**: Skill commands fail

**Solution**:
```bash
# Check skill paths
skill list --verbose

# Verify installation
ls -la /path/to/anti-slop-skills

# Check skill configuration
cat ~/.skill-manager/config
```

## Advanced Integration

### Custom Workflow Integration

Create project-specific integration:

```bash
#!/bin/bash
# project_quality_check.sh

# Learn phase (interactive)
echo "=== Learning Resources ==="
echo "Posit skills available for syntax/features"
echo "Reference: https://posit.co/resources/"

# Enforce phase (automated)
echo ""
echo "=== Quality Enforcement ==="

# Check R code
for file in R/*.R; do
  Rscript scripts/detect_slop.R "$file"
done

# Check documentation
for file in docs/*.md; do
  python scripts/detect_slop.py "$file"
done

# Check Quarto docs
for file in analysis/*.qmd; do
  quarto check "$file"  # Posit/Quarto check
  # Then manual review with quarto/anti-slop
done

echo ""
echo "=== Results ==="
echo "Review findings above and apply relevant skill guidance"
```

### IDE Integration

Configure your IDE to suggest both skills:

**VSCode**:
```json
{
  "skills.suggestOnType": true,
  "skills.providers": [
    "posit",
    "anti-slop"
  ]
}
```

**RStudio**:
```r
# .Rprofile
options(
  skill.providers = c("posit", "anti-slop"),
  skill.auto_suggest = TRUE
)
```

## Resources

### Anti-Slop Skills
- **Main repository**: https://github.com/your-username/anti-slop-skills
- **Documentation**: See individual SKILL.md files
- **Issues/contributions**: GitHub issues

### Posit Skills
- **Main repository**: (Posit official repository)
- **Documentation**: https://posit.co/resources/
- **Community**: RStudio Community

### Related Resources
- **R for Data Science**: https://r4ds.hadley.nz/
- **Python Data Science Handbook**: https://jakevdp.github.io/PythonDataScienceHandbook/
- **Quarto documentation**: https://quarto.org/
- **Tidyverse style guide**: https://style.tidyverse.org/

## Summary

Both skill sets are valuable and complementary:

| Aspect | Posit Skills | Anti-Slop |
|--------|--------------|---------------|
| **Purpose** | Teach syntax & features | Enforce quality standards |
| **When** | Learning new concepts | Reviewing/refactoring |
| **Focus** | How to implement | What to avoid |
| **Automation** | Documentation & guides | Detection scripts |
| **Relationship** | Equal partners, not hierarchical | Equal partners, not hierarchical |

**Best results**: Use both together throughout development lifecycle.

## Version History

### 1.0.0 (2024-01-21)
- Initial integration guide
- Comprehensive usage patterns
- Clear distinction between skill sets
- Emphasis on complementary equality
