# Skill Improvement Recommendations (COMPLETED)

**Status**: v2.0.0 Implementation Complete (2026-01-21)

All recommendations in this document have been implemented. This file is kept for historical context.

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

## Recommended Improvements (ALL IMPLEMENTED)

### 1. Add "When to Use This Skill" Section
✅ Done for all 8 skills.

### 2. Restructure with Progressive Disclosure
✅ Done. All skills have `reference/` directories.

### 3. Create "When to Use What" Decision Tables
✅ Done for all 8 skills.

### 4. Add "Common Workflows" Section
✅ Done for all 8 skills.

### 5. Improve YAML Frontmatter
✅ Done. `marketplace.json` updated with `applies_to` and tags.

### 6. Separate Concerns More Clearly
✅ Done. `text/anti-slop` separated from `humanizer`.

### 7. Integration with Posit Skills
✅ Done. `INTEGRATION.md` created.

### 8. Add Practical Examples at the Top
✅ Done. Before/After examples added to all skills.

### 9. Create Integration Guide
✅ Done. `INTEGRATION.md` created.

### 10. Improve Script Discoverability
✅ Done. `toolkit` restructured and scripts organized.

## Implementation Priority

### High Priority (Do First)
1. ✅ Add "When to Use This Skill" to each SKILL.md
2. ✅ Add "When to Use What" decision tables
3. ✅ Restructure with progressive disclosure (main + reference/)
4. ✅ Add "Common Workflows" section
5. ✅ Lead with before/after examples

### Medium Priority (Do Next)
6. ✅ Improve YAML frontmatter with metadata
7. ✅ Create meta-skill for auto-loading
8. ✅ Add integration guide with Posit skills
9. ✅ Separate text/anti-slop and humanizer clearly

### Low Priority (Nice to Have)
10. ✅ Create interactive examples (via workflows)
11. ✅ Add CI/CD integration examples (in toolkit/reference/ci-cd.md)
12. ⏳ Video walkthroughs of workflows (Out of scope)
13. ✅ Skill version management (v2.0.0)

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

---

# Next Phase Improvements (2026-01-21)

After reviewing the v2.0.0 implementation, here are the next actionable improvements:

## Immediate Actionable Items

### 1. Complete Reference Files for R Anti-Slop (HIGH PRIORITY)
**Status**: COMPLETE (2026-01-21)

The R skill is the flagship. Complete these reference files:
- [x] `r/anti-slop/reference/naming.md` - Naming conventions, forbidden patterns
- [x] `r/anti-slop/reference/tidyverse.md` - Pipes, formatting, ggplot2
- [x] `r/anti-slop/reference/documentation.md` - Roxygen2, vignettes, no circular docs
- [x] `r/anti-slop/reference/statistical-rigor.md` - Validation, reproducibility
- [x] `r/anti-slop/reference/forbidden-patterns.md` - Complete antipattern catalog

**Why**: R is 80% complete and most mature skill. Finishing reference files makes it a complete model for other languages.

### 2. Add Examples Directory (HIGH PRIORITY)
**Status**: COMPLETE (2026-01-21)

Create comprehensive examples:
- [x] `examples/r/before-after/` - R code samples with slop scores
- [x] `examples/python/before-after/` - Python code samples
- [x] `examples/text/before-after/` - Text cleanup examples
- [x] `examples/workflows/` - Complete workflows showing skill application
- [x] `examples/integration/` - Using Posit + EER skills together
- [x] `examples/bad/` - High-slop examples with scores for testing

**Why**: Concrete examples demonstrate value immediately. Users learn faster from examples than documentation.

### 3. Toolkit Testing (MEDIUM PRIORITY)
**Status**: COMPLETE (2026-01-21)

Add comprehensive testing:
- [x] Unit tests for `detect_slop.py`
- [x] Unit tests for `detect_slop.R`
- [x] Unit tests for `clean_slop.py`
- [x] Regression tests with known slop samples
- [x] Edge case coverage (false positives/negatives)
- [x] Performance tests for large files
- [x] Integration tests for all three scripts

**Why**: Detection scripts are core value. They must be reliable and well-tested.

### 4. Cross-Reference Quick Start (MEDIUM PRIORITY)
**Status**: COMPLETE (2026-01-21)

Add to CLAUDE.md or INTEGRATION.md:

```markdown
## Quick Start for Common Tasks

**Writing an R package function:**
```bash
# 1. Learn structure (Posit)
claude --skill r-lib/cli "explain cli_alert patterns"

# 2. Write code
# 3. Enforce quality (EER)
Rscript toolkit/scripts/detect_slop.R R/my-function.R --verbose
```

**Creating reproducible research:**
```bash
# 1. Learn Quarto (Posit)
claude --skill quarto/authoring "setup paper template"

# 2. Write content
# 3. Check quality (EER)
python toolkit/scripts/detect_slop.py paper.qmd
claude --skill quarto/anti-slop "review paper.qmd"
```

**Cleaning up AI-generated text:**
```bash
# 1. Detect issues
python toolkit/scripts/detect_slop.py README.md --verbose

# 2. Preview fixes
python toolkit/scripts/clean_slop.py README.md

# 3. Apply with backup
python toolkit/scripts/clean_slop.py README.md --save
```
```

**Why**: Makes the integration concrete and actionable, not just conceptual.

### 5. Track and Document Submodules (LOW PRIORITY)
**Status**: COMPLETE (2026-01-21)

Document in SUBMODULES.md:
- [x] Update procedures for each submodule
- [x] Version pinning strategy
- [x] Why each is external vs internal
- [x] How to contribute changes back upstream
- [x] Testing strategy for submodule changes

**Why**: Submodules can cause confusion. Clear documentation prevents issues.

### 6. Marketplace Entry Enhancement (LOW PRIORITY)
**Status**: COMPLETE (2026-01-21)

Add to `.claude-plugin/marketplace.json`:
```json
"examples": [
  {
    "name": "Detect R code slop",
    "command": "Rscript toolkit/scripts/detect_slop.R script.R --verbose"
  },
  {
    "name": "Clean text slop with backup",
    "command": "python toolkit/scripts/clean_slop.py README.md --save"
  },
  {
    "name": "Check Python type coverage",
    "command": "mypy script.py --strict"
  }
]
```

**Why**: Makes common commands discoverable directly in marketplace.

## Structural Improvements

### 7. Restructure Julia and C++ Skills to v2.0.0 (MEDIUM PRIORITY)
**Status**: COMPLETE (2026-01-21)

Apply v2.0.0 pattern:
- [x] `julia/anti-slop/SKILL.md` - Add progressive disclosure
- [x] `julia/anti-slop/reference/` - Create reference directory
- [x] `cpp/anti-slop/SKILL.md` - Add progressive disclosure
- [x] `cpp/anti-slop/reference/` - Create reference directory

**Why**: Consistency across all skills. Only R and Python were v2.0.0 initially.

### 8. Add CI/CD for Repository Quality (LOW PRIORITY)
**Status**: COMPLETE (2026-01-21)

Create `.github/workflows/quality.yml`:
- [x] Run detection scripts on all example files
- [x] Verify example slop scores match expectations
- [x] Run toolkit tests
- [x] Check R/Python/Julia/C++ code in repo meets own standards
- [x] Validate markdown files with text/anti-slop

**Why**: "Eat your own dog food" - the anti-slop repo should pass its own checks.

### 9. Create Python/Text Reference Files (MEDIUM PRIORITY)
**Status**: COMPLETE (2026-01-21)

Python reference files:
- [x] `python/anti-slop/reference/type-hints.md` - Type system best practices
- [x] `python/anti-slop/reference/pandas.md` - DataFrame operations, method chaining
- [x] `python/anti-slop/reference/testing.md` - Pytest patterns, fixtures, mocking

Text reference files:
- [x] `text/anti-slop/reference/transitions.md` - Overused connecting phrases
- [x] `text/anti-slop/reference/buzzwords.md` - Corporate jargon catalog
- [x] `text/anti-slop/reference/structure.md` - Document organization patterns

**Why**: Completes v2.0.0 progressive disclosure for Python and text skills.

### 10. Design/Quarto Reference Files (LOW PRIORITY)
**Status**: COMPLETE (2026-01-21)

Design reference files:
- [x] `design/anti-slop/reference/visual.md` - Color, typography, spacing patterns
- [x] `design/anti-slop/reference/layout.md` - Grid systems, component layouts
- [x] `design/anti-slop/reference/ux-writing.md` - Microcopy and CTA patterns

Quarto reference files:
- [x] `quarto/anti-slop/reference/yaml-config.md` - Document and project YAML options
- [x] `quarto/anti-slop/reference/reproducibility.md` - Computation, caching, environments
- [x] `quarto/anti-slop/reference/visualization.md` - Plot standards, figure sizing

**Why**: Completes v2.0.0 for all skills.

## Priority Ranking

### Must Have (Phase 2A)
1. Complete R reference files (flagship skill)
2. Add examples directory with samples
3. Add quick-start integration examples

### Should Have (Phase 2B)
4. Add toolkit testing
5. Restructure Julia/C++ to v2.0.0
6. Create Python/text reference files

### Nice to Have (Phase 2C)
7. Track and document submodules
8. Add CI/CD quality checks
9. Create design/quarto reference files
10. Enhance marketplace.json with examples

## Success Metrics

Phase 2 will be complete when:

1. [x] All 8 skills have complete reference file sets
2. [x] `examples/` directory has 20+ before/after samples
3. [x] Toolkit has 80%+ test coverage
4. [x] All skills use v2.0.0 structure (8 of 8)
5. [x] Quick-start examples exist for common workflows
6. [x] CI/CD validates repository code quality
7. [x] SUBMODULES.md is tracked and complete
