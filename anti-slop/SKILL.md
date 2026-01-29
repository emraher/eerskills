---
name: anti-slop
description: >
  Meta-skill that enforces quality standards across code, text, and design.
  Automatically applies appropriate domain skills based on file type.
  Detects and prevents generic AI-generated patterns.
includes:
  - r/anti-slop
  - python/anti-slop
  - julia/anti-slop
  - cpp/anti-slop
  - text/anti-slop
  - design/anti-slop
  - quarto/anti-slop
  - toolkit
version: 2.0.0
---

# Anti-Slop Meta-Skill

## Purpose

The anti-slop meta-skill is a coordinator that automatically applies the appropriate domain-specific anti-slop skill based on file type and context. It provides a unified entry point for quality enforcement across all content types.

## When to Use This Skill

Use the anti-slop meta-skill when:
- ✓ You want automatic routing to the correct domain skill
- ✓ Working with mixed content types (code + docs + design)
- ✓ Need comprehensive quality review across project
- ✓ User explicitly requests "anti-slop" without specifying domain
- ✓ Establishing quality standards for entire project

Use specific domain skills when:
- You know exactly which domain applies
- Deep expertise in one area needed
- Custom configuration for specific file types

## Quick Overview

This meta-skill automatically routes to:

| File Type | Routes To | Focus Area |
|-----------|-----------|------------|
| `*.R`, `*.Rmd` | r/anti-slop | Namespace qualification, explicit returns, snake_case |
| `*.py` | python/anti-slop | Type hints, descriptive names, PEP 8 |
| `*.jl` | julia/anti-slop | Type annotations, dispatch patterns |
| `*.cpp`, `*.h` | cpp/anti-slop | RAII, const correctness, modern C++ |
| `*.md`, `*.txt` | text/anti-slop | Direct language, no buzzwords, structural clarity |
| `*.qmd`, `*.ipynb` | quarto/anti-slop | Cross-references, reproducibility, proper YAML |
| Design files | design/anti-slop | Data viz quality, avoiding generic UI patterns |
| Automated checks | toolkit | Detection scripts, CI/CD integration |

## Domain Skill Summaries

### r/anti-slop
**Focus**: Production-quality R code

**Key rules**:
- ALWAYS namespace qualify with `::`
- ALWAYS explicit `return()` statements
- ALWAYS `snake_case` naming
- NO generic names (`df`, `data`, `result`)
- Native pipe `|>` preferred over `%>%`

**Quick example**:
```r
# Bad
df <- data %>% filter(x > 0)

# Good
customer_data <- customer_data |>
  dplyr::filter(status == "active")
return(customer_data)
```

**Use when**: Writing or reviewing R code, R packages, or R analysis scripts.

---

### python/anti-slop
**Focus**: Type-safe, professional Python

**Key rules**:
- ALWAYS use type hints
- ALWAYS descriptive variable names
- Follow PEP 8 conventions
- NO generic names (`data`, `result`, `temp`)
- Explicit error handling

**Quick example**:
```python
# Bad
def process(data):
    result = data + 1
    return result

# Good
def calculate_adjusted_score(raw_scores: list[float]) -> list[float]:
    adjusted_scores = [score + 1.0 for score in raw_scores]
    return adjusted_scores
```

**Use when**: Writing or reviewing Python code, modules, or packages.

---

### julia/anti-slop
**Focus**: Type-stable, idiomatic Julia

**Key rules**:
- Type annotations on function signatures
- Multiple dispatch patterns
- Descriptive variable names
- Explicit return types

**Quick example**:
```julia
# Bad
function process(data)
    result = data .+ 1
    return result
end

# Good
function calculate_adjusted_scores(raw_scores::Vector{Float64})::Vector{Float64}
    adjusted_scores = raw_scores .+ 1.0
    return adjusted_scores
end
```

**Use when**: Writing or reviewing Julia code for scientific computing.

---

### cpp/anti-slop
**Focus**: Modern C++ with RAII and type safety

**Key rules**:
- RAII for resource management
- `const` correctness everywhere
- Smart pointers over raw pointers
- Modern C++ (C++11/14/17/20)
- Descriptive names

**Quick example**:
```cpp
// Bad
double* process(double* data, int size) {
    double* result = new double[size];
    // ...
    return result;
}

// Good
std::vector<double> calculate_adjusted_scores(
    const std::vector<double>& raw_scores
) {
    std::vector<double> adjusted_scores;
    adjusted_scores.reserve(raw_scores.size());
    // ...
    return adjusted_scores;
}
```

**Use when**: Writing or reviewing C++ code, especially for R packages (Rcpp).

---

### text/anti-slop
**Focus**: Direct, clear writing without AI patterns

**Key rules**:
- NO "delve into", "navigate complexities", "in today's world"
- NO meta-commentary ("it's important to note")
- NO buzzwords ("leverage", "synergistic")
- Simplify wordy phrases
- Be direct and specific

**Quick example**:
```markdown
# Bad
It's important to note that we will delve into the complexities
of data analysis in today's fast-paced world.

# Good
We analyze customer data to identify retention patterns.
```

**Use when**: Writing or reviewing documentation, README files, technical writing.

---

### design/anti-slop
**Focus**: Intentional design avoiding generic patterns

**Key rules**:
- NO generic gradients (purple/pink/cyan)
- NO template-driven layouts
- NO "Empower your business" copy
- Data visualization: proper labels, scales, colors
- Content-first design

**Quick example**:
```
Bad visualization:
- Default ggplot2 gray background
- Unlabeled axes
- Generic title: "Plot 1"

Good visualization:
- Clean white background with subtle gridlines
- Axes: "Revenue ($M)" and "Quarter (2023)"
- Title: "Q4 Revenue Growth Exceeds Projections"
```

**Use when**: Creating visualizations, designing interfaces, reviewing UI/UX.

---

### quarto/anti-slop
**Focus**: Reproducible research documents

**Key rules**:
- Complete YAML metadata (author, affiliation, date)
- Label ALL figures/tables/equations
- ALWAYS use cross-references (@fig-*, @tbl-*, @eq-*)
- Bibliography management with BibTeX
- Relative paths only
- Cache long computations

**Quick example**:
```yaml
# Bad
---
title: "Analysis"
output: pdf_document
---

Figure 1 shows results.

# Good
---
title: "Customer Retention Analysis"
author:
  - name: Jane Researcher
    affiliation: University Name
bibliography: references.bib
---

@fig-retention shows customer retention rates.

```{r}
#| label: fig-retention
#| fig-cap: "Retention by Cohort"
```
```

**Use when**: Creating Quarto/RMarkdown documents, academic papers, technical reports.

---

### toolkit
**Focus**: Automated detection and cleanup

**Key tools**:
- `detect_slop.py` - Text file detection
- `clean_slop.py` - Text file cleanup
- `detect_slop.R` - R code detection

**Quick example**:
```bash
# Detect slop
python scripts/detect_slop.py report.md --verbose

# Clean slop
python scripts/clean_slop.py report.md --save

# Check R code
Rscript scripts/detect_slop.R analysis.R
```

**Use when**: Automating quality checks, CI/CD integration, batch processing.

## Decision Tree

When anti-slop meta-skill is invoked, route based on:

```
1. Check file extension:
   - *.R, *.Rmd → r/anti-slop
   - *.py → python/anti-slop
   - *.jl → julia/anti-slop
   - *.cpp, *.h, *.hpp → cpp/anti-slop
   - *.md, *.txt, *.rst → text/anti-slop
   - *.qmd, *.ipynb → quarto/anti-slop
   - No file/mixed → prompt user

2. Check context:
   - Mentions "visualization" or "plot" → also consider design/anti-slop
   - Mentions "documentation" → text/anti-slop
   - Mentions "package" → language-specific + quarto/anti-slop for vignettes
   - Mentions "CI/CD" or "automated" → toolkit

3. Check user request:
   - "Review my code" → language-specific anti-slop
   - "Check documentation" → text/anti-slop or quarto/anti-slop
   - "Audit codebase" → toolkit
   - "Improve design" → design/anti-slop
```

## Integration with Learning Resources

The anti-slop skills are **quality enforcement tools** that work alongside any learning resource:

### Complementary Use with Other Resources

| Resource Type | Teaches | Anti-Slop Enforces |
|--------------|---------|-------------------|
| R books | Language features | Production-quality code |
| Python courses | Syntax & patterns | Type hints & naming |
| Design systems | UI components | Intentional choices |
| Writing guides | Structure | Direct language |

## When to Invoke Domain Skills Directly

### Use r/anti-slop directly when:
- Working exclusively with R code
- Need R-specific rules (namespace qualification, pipes)
- Reviewing R package structure

### Use python/anti-slop directly when:
- Working exclusively with Python code
- Need type hinting enforcement
- Reviewing Python package structure

### Use text/anti-slop directly when:
- Working exclusively with prose
- Need humanizer checklist integration
- Cleaning documentation files

### Use quarto/anti-slop directly when:
- Creating reproducible research documents
- Need cross-referencing enforcement
- Preparing academic manuscripts

### Use toolkit directly when:
- Setting up CI/CD quality checks
- Batch processing multiple files
- Automating detection across codebase

## Common Workflows

### Workflow 1: Comprehensive Project Review

**Context**: Review entire project for quality standards.

**Steps**:
1. Run toolkit detection across all files
2. Review high-priority issues by domain
3. Apply domain-specific skills for refactoring
4. Verify with re-detection

```bash
# Detect across project
find . -name "*.md" -exec python scripts/detect_slop.py {} \;
find . -name "*.R" -exec Rscript scripts/detect_slop.R {} \;

# Apply domain skills as needed
# r/anti-slop for R files
# text/anti-slop for documentation
# quarto/anti-slop for analysis notebooks
```

---

### Workflow 2: Pre-Release Quality Check

**Context**: Ensure quality before public release.

**Steps**:
1. Code review with language-specific skills
2. Documentation review with text/anti-slop
3. Visualization review with design/anti-slop
4. Reproducibility check with quarto/anti-slop

**Checklist**:
- [ ] All code files score < 30 on slop detection
- [ ] Documentation has no high-risk phrases
- [ ] Visualizations have proper labels and titles
- [ ] Quarto docs render reproducibly

---

### Workflow 3: Establish Team Standards

**Context**: Create quality guidelines for team.

**Steps**:
1. Review all domain-specific anti-slop skills
2. Identify patterns most relevant to team
3. Set thresholds (e.g., max slop score = 40)
4. Integrate toolkit into CI/CD
5. Document exceptions

**Example standards document**:
```markdown
# Code Quality Standards

## R Code
- Use r/anti-slop standards
- Max slop score: 30
- Namespace qualification required
- Explicit returns required

## Documentation
- Use text/anti-slop standards
- Max slop score: 40
- No high-risk phrases
- Direct language required

## Analysis Documents
- Use quarto/anti-slop standards
- All cross-references required
- Bibliography required for papers
```

## Relationship with Other Skills

### Equal Standing, Not Subordinate

The anti-slop skills are **NOT** subordinate to any other skill set. They are:

1. **Complementary equals** - Work alongside Posit, books, courses
2. **Quality enforcers** - Prevent generic AI patterns
3. **Domain-specific** - Each skill has unique expertise
4. **Independently valuable** - Useful without other resources

### Integration Pattern

```
User writes code/docs
    ↓
Learning resource teaches syntax/features (Posit, books, etc.)
    ↓
Anti-slop enforces quality standards
    ↓
Production-ready output
```

Both steps are essential. Neither is subordinate.

## Resources

### All Domain Skills

- **[r/anti-slop](../r/anti-slop/SKILL.md)** - R code quality standards
- **[python/anti-slop](../python/anti-slop/SKILL.md)** - Python code quality standards
- **[julia/anti-slop](../julia/anti-slop/SKILL.md)** - Julia code quality standards
- **[cpp/anti-slop](../cpp/anti-slop/SKILL.md)** - C++ code quality standards
- **[text/anti-slop](../text/anti-slop/SKILL.md)** - Technical writing standards
- **[design/anti-slop](../design/anti-slop/SKILL.md)** - Visualization & UI standards
- **[quarto/anti-slop](../quarto/anti-slop/SKILL.md)** - Reproducible document standards
- **[toolkit](../toolkit/SKILL.md)** - Automated detection and cleanup tools

### Additional Resources

- **INTEGRATION.md** - Comprehensive guide to using anti-slop with other skills
- **toolkit/scripts/** - Detection and cleanup automation scripts

## Version History

### 2.0.0 (Current)
- Restructured as workflow-focused meta-skill
- Added clear decision tree for routing
- Emphasized complementary nature with learning resources
- Added comprehensive domain skill summaries
- Clarified equal standing with other skill sets

### 1.0.0
- Initial meta-skill implementation
- Basic domain skill coordination
