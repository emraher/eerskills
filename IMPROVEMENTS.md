# Skill Improvement Recommendations

## Executive Summary

Your anti-slop skills are comprehensive but structured differently from Posit's skills. Here's how to improve them while maintaining compatibility with Posit's approach and making them more effective for Claude Code.

## Key Differences: Your Skills vs Posit Skills

### Current Structure (Your Skills)
- **Pattern-focused**: Heavy on what to avoid, detection patterns, examples
- **Reference-style**: Comprehensive lists of antipatterns and rules
- **Script-driven**: Includes active detection/cleanup tools
- **Defensive**: "Don't do this" orientation

### Posit Structure
- **Task-focused**: "When to Use What" decision tables
- **Progressive disclosure**: Brief main file → detailed reference files
- **Workflow-driven**: Common workflows with ready-to-use templates
- **Constructive**: "Do this instead" orientation with examples

## Recommended Improvements

### 1. Add "When to Use This Skill" Section

**Current**: Skills launch with pattern lists immediately
**Better**: Start with clear decision criteria

```markdown
## When to Use This Skill

Use r-anti-slop when:
- [ ] Writing new R code for data analysis or packages
- [ ] Reviewing AI-generated R code before committing
- [ ] Refactoring existing code for production quality
- [ ] Preparing R package for CRAN submission
- [ ] Teaching or enforcing R code standards

Do NOT use when:
- Writing quick exploratory scripts (though standards still help)
- Working with legacy code that can't be changed
```

### 2. Restructure with Progressive Disclosure

**Current**: Everything in one massive SKILL.md file
**Proposed**: Main file + reference directory

```
r/anti-slop/
├── SKILL.md                    # Core workflow (500-800 lines)
├── reference/
│   ├── naming.md              # Deep dive: naming conventions
│   ├── documentation.md       # roxygen2, vignettes, README
│   ├── tidyverse.md           # Tidyverse-specific patterns
│   ├── statistical-rigor.md   # Validation, uncertainty, reproducibility
│   └── forbidden-patterns.md  # Comprehensive antipattern catalog
```

**Main SKILL.md Structure:**
```markdown
## When to Use What

| Task | Quick Reference | Details |
|------|----------------|---------|
| Name variables | Use snake_case, no `df`/`data` | See reference/naming.md |
| Document functions | Specific @param, @return | See reference/documentation.md |
| Write pipe chains | `\|>` preferred, break >8 ops | See reference/tidyverse.md |

## Core Workflow

1. Check namespace qualification (all external functions use `::`)
2. Add explicit returns (never implicit)
3. Validate naming (snake_case, no generic names)
4. Review documentation (no circular descriptions)
5. Run styler + lintr

## Quick Reference Checklist

- [ ] All external functions qualified with `::`
- [ ] All functions have explicit `return()`
- [ ] All objects use `snake_case`
... (10-15 most critical items)

## Common Workflows

### Workflow: Clean Up AI-Generated R Script
[Step-by-step example]

### Workflow: Prepare Package for CRAN
[Step-by-step example]

## Resources & Advanced Topics
- reference/naming.md - Complete naming conventions
- reference/documentation.md - roxygen2 and vignette standards
...
```

### 3. Create "When to Use What" Decision Tables

Add to each skill's main file:

**Example for r/anti-slop:**
```markdown
## When to Use What

| If you need to... | Use this approach | Details |
|-------------------|-------------------|---------|
| Filter data | `dplyr::filter(data, condition)` | reference/tidyverse.md |
| Name data frames | Descriptive name (e.g., `customer_data`) | reference/naming.md |
| Document parameters | Specific structure & expectations | reference/documentation.md |
| Handle missing data | Explicit strategy + report loss | reference/statistical-rigor.md |
| Write pipe chains | Break at 8+ operations | reference/tidyverse.md |
```

**Example for text/anti-slop:**
```markdown
## When to Use What

| If you see... | Replace with... | Details |
|---------------|-----------------|---------|
| "delve into" | "examine" or delete | Humanizer Pattern #7 |
| "navigate the complexities" | Specific challenge | Humanizer Pattern #1 |
| "in order to" | "to" | Filler Constructions |
| Meta-commentary | Direct statement | Unnecessary Meta-Commentary |
```

### 4. Add "Common Workflows" Section

Replace scattered "Scenario X" examples with structured workflows:

```markdown
## Common Workflows

### Workflow: Review AI-Generated R Analysis Script

**Context**: You have an AI-generated analysis script with generic patterns.

**Steps**:
1. **Detect patterns**
   ```bash
   Rscript toolkit/scripts/detect_slop.R analysis.R --verbose
   ```

2. **Fix high-priority issues first**
   - [ ] Replace `df`, `data`, `result` with descriptive names
   - [ ] Add namespace qualification (`dplyr::`, `ggplot2::`)
   - [ ] Add explicit `return()` statements

3. **Improve code structure**
   - [ ] Break long pipes (>8 ops) with intermediate variables
   - [ ] Remove obvious comments ("Load library")
   - [ ] Simplify single-pipe constructs

4. **Validate and format**
   ```r
   styler::style_file("analysis.R")
   lintr::lint("analysis.R")
   ```

**Expected outcome**: Score drops from 60+ to <20

---

### Workflow: Humanize Technical Documentation

**Context**: AI-generated README or vignette feels generic.

**Steps**:
1. **Run detection**
   ```bash
   python toolkit/scripts/detect_slop.py README.md --verbose
   ```

2. **Apply automated cleanup**
   ```bash
   python toolkit/scripts/clean_slop.py README.md --save
   ```

3. **Manual review against humanizer checklist**
   - [ ] Remove significance inflation (Pattern #1)
   - [ ] Replace AI vocabulary (Pattern #7)
   - [ ] Fix copula avoidance (Pattern #8)
   - [ ] Add personality and voice

4. **Verify improvements**
   - Rerun detection (should score <30)
   - Read aloud to check natural flow
   - Ensure specific examples, not abstract claims

**Expected outcome**: Natural, human-sounding documentation
```

### 5. Improve YAML Frontmatter

**Current**:
```yaml
---
name: r-anti-slop
description: >
  Tidyverse-first R programming with strict namespace qualification...
---
```

**Better** (following Posit pattern):
```yaml
---
name: r-anti-slop
description: >
  Enforce production-quality R code standards. Prevents generic AI patterns
  through namespace qualification, explicit returns, and tidyverse conventions.
  Use when writing or reviewing R code for data analysis or packages.
applies_to:
  - "**/*.R"
  - "**/*.Rmd"
  - "**/*.qmd"
tags: [r, tidyverse, code-quality, data-science]
related_skills:
  - quarto/anti-slop
  - text/anti-slop
version: 1.0.0
---
```

### 6. Separate Concerns More Clearly

**Current issue**: text/anti-slop includes both general writing AND humanizer patterns
**Proposed split**:

```
text/
├── anti-slop/
│   ├── SKILL.md              # General technical writing patterns
│   └── reference/
│       ├── transitions.md     # Overused phrases
│       ├── buzzwords.md       # Corporate jargon
│       └── structure.md       # Document organization
└── humanizer/
    ├── SKILL.md              # Wikipedia 24-pattern checklist
    └── reference/
        ├── content.md        # Patterns 1-6
        ├── language.md       # Patterns 7-12
        ├── style.md          # Patterns 13-18
        └── communication.md  # Patterns 19-24
```

### 7. Integration with Posit Skills

Create a unified skill namespace that works with both:

```
~/.claude/skills/
├── posit/                    # Posit skills (git submodule)
│   ├── r-lib/
│   ├── quarto/
│   └── open-source/
└── eer/                      # Your skills
    ├── anti-slop/           # Meta-skill that loads domain skills
    ├── r/
    ├── python/
    ├── text/
    └── design/
```

**Create meta-skill** `anti-slop/SKILL.md`:
```markdown
---
name: anti-slop
description: >
  Meta-skill that enforces quality standards across code, text, and design.
  Automatically loads appropriate domain skills based on file type.
includes:
  - eer/r/anti-slop
  - eer/python/anti-slop
  - eer/text/anti-slop
  - eer/design/anti-slop
  - eer/quarto/anti-slop
---

# Anti-Slop Meta-Skill

This skill automatically applies quality standards based on what you're working on.

## Auto-Applied Skills

- `*.R, *.Rmd` → r/anti-slop + Posit's r-lib/testing + r-lib/cli
- `*.py` → python/anti-slop
- `*.md, *.txt` → text/anti-slop
- `*.qmd` → quarto/anti-slop + Posit's quarto/authoring
- Design reviews → design/anti-slop

## When to Use
Invoke when you want Claude to apply quality standards automatically.
```

### 8. Add Practical Examples at the Top

**Current**: Examples scattered throughout
**Better**: Lead with before/after

```markdown
## Quick Example

**Before (AI Slop)**:
```r
# Load the library
library(dplyr)

# Read the data
df <- read.csv("data.csv")

# Filter the data
result <- df %>% filter(x > 0)
```

**After (Anti-Slop)**:
```r
customer_data <- readr::read_csv("data/customers.csv")

active_customers <- customer_data |>
  dplyr::filter(status == "active", revenue > 0)

return(active_customers)
```

**What changed**:
- ✓ Descriptive names (`customer_data` not `df`)
- ✓ Namespace qualification (`dplyr::`, `readr::`)
- ✓ Native pipe (`|>` not `%>%`)
- ✓ No obvious comments
- ✓ Explicit return
```

### 9. Create Integration Guide

New file: `INTEGRATION.md`

```markdown
# Integrating EER Skills with Posit Skills

## Installation

### Both skill sets together
```bash
# Posit skills
git clone https://github.com/posit-dev/skills ~/.claude/skills/posit

# EER anti-slop skills
git clone [your-repo] ~/.claude/skills/eer
```

## Complementary Usage

| Task | Posit Skill | EER Skill | Use Together |
|------|-------------|-----------|--------------|
| Write R package tests | r-lib/testing | r/anti-slop | Yes - testing + quality |
| Create Quarto doc | quarto/authoring | quarto/anti-slop | Yes - structure + quality |
| Write roxygen docs | r-lib/cli | r/anti-slop | Yes - formatting + content |
| Release R package | open-source/release-post | text/anti-slop | Yes - post + humanization |

## Workflow Example

**Task**: Create and document an R package function

1. Use `r-lib/cli` to structure error messages
2. Use `r/anti-slop` to ensure code quality
3. Use `r-lib/testing` to write tests
4. Use `r-lib/cran-extrachecks` before CRAN submission
```

### 10. Improve Script Discoverability

**Current**: Scripts mentioned in toolkit/SKILL.md
**Better**: Make scripts first-class workflows

```markdown
## Automated Detection & Cleanup

### Quick Commands

```bash
# Detect slop in text files (returns score 0-100)
python toolkit/scripts/detect_slop.py file.md [--verbose]

# Clean text files (creates .backup)
python toolkit/scripts/clean_slop.py file.md --save

# Detect slop in R files
Rscript toolkit/scripts/detect_slop.R script.R [--verbose]
```

### Interpreting Scores

| Score | Meaning | Action |
|-------|---------|--------|
| 0-20 | Low slop | Minor tweaks |
| 20-40 | Moderate | Review flagged patterns |
| 40-60 | High | Significant cleanup needed |
| 60+ | Severe | Consider rewriting |

### Integration with CI/CD

```yaml
# .github/workflows/check-slop.yml
- name: Check for AI slop
  run: |
    python toolkit/scripts/detect_slop.py README.md
    if [ $? -gt 40 ]; then exit 1; fi
```
```

## Implementation Priority

### High Priority (Do First)
1. ✅ Add "When to Use This Skill" to each SKILL.md
2. ✅ Add "When to Use What" decision tables
3. ✅ Restructure with progressive disclosure (main + reference/)
4. ✅ Add "Common Workflows" section
5. ✅ Lead with before/after examples

### Medium Priority (Do Next)
6. ⏳ Improve YAML frontmatter with metadata
7. ⏳ Create meta-skill for auto-loading
8. ⏳ Add integration guide with Posit skills
9. ⏳ Separate text/anti-slop and humanizer clearly

### Low Priority (Nice to Have)
10. ⏳ Create interactive examples
11. ⏳ Add CI/CD integration examples
12. ⏳ Video walkthroughs of workflows
13. ⏳ Skill version management

## File Structure Changes

### Proposed New Structure

```
eer-skills/
├── README.md                 # Overview + installation
├── CLAUDE.md                 # Context for Claude Code
├── INTEGRATION.md            # How to use with Posit skills
├── IMPROVEMENTS.md           # This file
│
├── .claude-plugin/
│   └── marketplace.json      # Plugin registry
│
├── anti-slop/               # NEW: Meta-skill
│   └── SKILL.md
│
├── r/anti-slop/
│   ├── SKILL.md             # Restructured (500-800 lines)
│   └── reference/           # NEW: Detailed references
│       ├── naming.md
│       ├── documentation.md
│       ├── tidyverse.md
│       ├── statistical-rigor.md
│       └── forbidden-patterns.md
│
├── python/anti-slop/
│   ├── SKILL.md             # Restructured
│   └── reference/
│       ├── type-hints.md
│       ├── pandas.md
│       └── testing.md
│
├── text/
│   ├── anti-slop/
│   │   ├── SKILL.md         # General writing (no humanizer)
│   │   └── reference/
│   │       ├── transitions.md
│   │       ├── buzzwords.md
│   │       └── structure.md
│   └── humanizer/           # Separate skill
│       ├── SKILL.md         # 24-pattern checklist
│       └── reference/
│           ├── content.md
│           ├── language.md
│           ├── style.md
│           └── communication.md
│
├── design/anti-slop/
│   ├── SKILL.md
│   └── reference/
│       ├── visual.md
│       ├── layout.md
│       └── ux-writing.md
│
├── quarto/anti-slop/
│   ├── SKILL.md
│   └── reference/
│       ├── yaml-config.md
│       ├── reproducibility.md
│       └── visualization.md
│
└── toolkit/
    ├── SKILL.md             # Restructured with workflows
    ├── scripts/
    │   ├── detect_slop.py
    │   ├── detect_slop.R
    │   └── clean_slop.py
    └── reference/
        └── ci-integration.md
```

## Writing Style Changes

### Current Style
- Comprehensive lists
- "Don't do this" focus
- Academic/reference tone
- Pattern catalogs

### Recommended Style (Following Posit)
- Quick-reference tables
- "Do this instead" focus
- Practical/action-oriented tone
- Progressive disclosure

### Example Transformation

**Before**:
```markdown
### Forbidden Patterns

**1. Generic variable names**
```r
# WRONG
df <- read.csv("data.csv")
df1 <- filter(df, x > 0)
result <- summarize(df1, mean(y))
```

**After**:
```markdown
## Common Workflows

### Workflow: Fix Generic Variable Names

**When**: AI generated code with `df`, `data`, `result`

**Steps**:
1. Identify what the data represents
2. Choose descriptive name (e.g., `customer_data`, `sales_records`)
3. Rename consistently throughout
4. Verify with `lintr::lint()`

**Example**:
```r
# Before
df <- readr::read_csv("customers.csv")
result <- dplyr::filter(df, active == TRUE)

# After
customer_data <- readr::read_csv("data/customers.csv")
active_customers <- customer_data |> dplyr::filter(active == TRUE)
```

**Resources**: See reference/naming.md for complete conventions
```

## Success Criteria

Your skills will be improved when:

1. ✅ Each SKILL.md has clear "When to Use" section
2. ✅ Main files are 500-800 lines (details in reference/)
3. ✅ Decision tables help users find what they need quickly
4. ✅ Common workflows provide ready-to-use templates
5. ✅ Skills integrate cleanly with Posit skills
6. ✅ Examples lead (show before explaining)
7. ✅ Constructive tone ("do this" vs "don't do this")
8. ✅ Progressive disclosure (quick → detailed)

## Next Steps

1. **Pilot restructure**: Start with one skill (r/anti-slop)
2. **Get feedback**: Test with Claude Code users
3. **Iterate**: Apply learnings to other skills
4. **Document integration**: Create INTEGRATION.md
5. **Publish**: Update marketplace.json with new structure
