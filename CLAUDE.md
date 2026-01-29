# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

**Anti-Slop Skills** - A quality enforcement layer that detects and prevents generic AI-generated patterns across code, text, and design.

### What Makes This Different

Pattern detection and quality enforcement system, not a how-to guide.

- **Learning resources** (books, courses, documentation, skill libraries) teach how to use tools and structure projects
- **Anti-slop skills** detect and prevent generic AI-generated patterns
- **Together** they provide complete coverage: learning + quality

Works alongside any learning resource.

## Skill Structure (v2.0.0)

All skills now follow a consistent progressive disclosure pattern:

**Main SKILL.md** (350-500 lines):
- "When to Use This Skill" (clear decision criteria)
- Quick before/after examples
- "When to Use What" decision tables
- Core workflow (3-5 steps)
- Quick reference checklists
- 3+ common workflows with realistic scenarios
- Complementary use sections

**reference/** directory:
- Deep dives on specific topics
- Comprehensive pattern catalogs
- Advanced techniques
- Domain-specific guidance

### Core Skills (v2.0.0)

**Meta-skill:**
- `anti-slop/` - Coordinator that auto-loads domain skills by file type (✅ v2.0.0)

**Active detection:**
- `toolkit/` - Detection scripts (`detect_slop.py`, `detect_slop.R`, `clean_slop.py`) (✅ v2.0.0)

**Code quality:**
- `r/anti-slop/` - R code enforcement (namespace `::`, explicit `return()`, no `df`/`data`) (✅ v2.0.0)
- `python/anti-slop/` - Python enforcement (type hints, docstrings, PEP 8) (✅ v2.0.0)
- `julia/anti-slop/` - Julia scientific computing standards (🔄 v1.0.0, needs restructure)
- `cpp/anti-slop/` - C++/Rcpp performance code standards (🔄 v1.0.0, needs restructure)

**Content quality:**
- `text/anti-slop/` - Technical writing (remove transitions, buzzwords, filler) (✅ v2.0.0)
- `external/humanizer/` - Wikipedia 24-pattern checklist (add personality, remove AI signatures) (✅ v2.0.0, submodule)
- `external/elements-of-style/` - Strunk's timeless writing principles for clear, concise prose (✅ v2.0.0, submodule)
- `quarto/anti-slop/` - Reproducible research documents (no template-derived content) (✅ v2.0.0)

**Design quality:**
- `design/anti-slop/` - Visual patterns ("AI startup" aesthetic detection) (✅ v2.0.0)

## Common Commands

### Detection Scripts

**Detect slop in text files** (returns score 0-100):
```bash
python toolkit/scripts/detect_slop.py <file.md> [--verbose]
```

**Detect slop in R code**:
```bash
Rscript toolkit/scripts/detect_slop.R <file.R> [--verbose]
Rscript toolkit/scripts/detect_slop.R R/ [--verbose]  # entire directory
```

**Clean up text files** (with backup):
```bash
python toolkit/scripts/clean_slop.py <file.md>                    # preview
python toolkit/scripts/clean_slop.py <file.md> --save             # apply
python toolkit/scripts/clean_slop.py <file.md> --save --aggressive # more aggressive
```

### Code Formatting

**R:**
```r
styler::style_file("script.R")
styler::style_dir("R/")
lintr::lint("script.R")
```

**Python:**
```bash
black script.py
ruff check script.py
ruff format script.py
mypy script.py
```

## Skill-Specific Patterns

### R Anti-Slop (r/anti-slop/SKILL.md)

**Mandatory rules:**
1. Always use `::` for external packages → `dplyr::filter()` not `filter()`
2. Always explicit `return()` → never implicit
3. Always `snake_case` → no `df`, `data`, `result`
4. Native pipe `|>` preferred over `%>%`
5. Break long pipes at 8+ operations

**Detection:**
```bash
Rscript toolkit/scripts/detect_slop.R script.R --verbose
```

**Reference files:**
- `reference/naming.md` - Naming conventions, forbidden patterns (🔄 in progress)
- `reference/tidyverse.md` - Pipes, formatting, ggplot2 (🔄 in progress)
- `reference/documentation.md` - Roxygen2, vignettes, no circular docs (🔄 in progress)
- `reference/statistical-rigor.md` - Validation, reproducibility (🔄 in progress)
- `reference/forbidden-patterns.md` - Complete antipattern catalog (🔄 in progress)

### Python Anti-Slop (python/anti-slop/SKILL.md)

**Mandatory rules:**
1. Type hints required for all functions
2. Docstrings required (NumPy/Google style)
3. Import organization: stdlib → third-party → local
4. Use `.copy()` when modifying DataFrames
5. No mutable default arguments

**Quick check:**
```bash
black script.py && ruff check script.py && mypy script.py
```

**Reference files** (planned):
- `reference/type-hints.md` - Type system best practices
- `reference/pandas.md` - DataFrame operations, method chaining
- `reference/testing.md` - Pytest patterns, fixtures, mocking

### Text Anti-Slop (text/anti-slop/SKILL.md)

**Remove immediately:**
- "delve into" → delete or "examine"
- "navigate the complexities" → specific challenge or delete
- "in order to" → "to"
- "It's important to note that" → delete, state the point
- Meta-commentary ("In this document...")

**Detection:**
```bash
python toolkit/scripts/detect_slop.py README.md --verbose
python toolkit/scripts/clean_slop.py README.md --save
```

**Reference files** (planned):
- `reference/transitions.md` - Overused connecting phrases
- `reference/buzzwords.md` - Corporate jargon catalog
- `reference/structure.md` - Document organization patterns

### Design Anti-Slop (design/anti-slop/SKILL.md)

**High-confidence slop patterns:**
- Purple/pink/cyan gradient backgrounds
- Floating 3D geometric shapes
- "Empower your business" headlines
- Three-column feature cards (exactly three)
- "Get Started" CTAs
- Inter font for everything

**Audit workflow:**
1. Screenshot key sections
2. Compare against generic AI patterns
3. Identify specific slop instances
4. Redesign based on content/brand needs

**Reference files** (planned):
- `reference/visual.md` - Color, typography, spacing patterns
- `reference/layout.md` - Grid systems, component layouts
- `reference/ux-writing.md` - Microcopy and CTA patterns

### Quarto Anti-Slop (quarto/anti-slop/SKILL.md)

**Prevents:**
- Template-derived YAML configs
- Generic research document structure
- Copy-paste reproducibility sections
- Missing session info

**Enforces:**
- PDF-first for papers, HTML for reports
- Proper cross-references
- Specific abstracts (not "This paper investigates...")
- Reproducible computation

**Reference files** (planned):
- `reference/yaml-config.md` - Document and project YAML options
- `reference/reproducibility.md` - Computation, caching, environments
- `reference/visualization.md` - Plot standards, figure sizing

## Scoring Guide

Detection scripts output scores (0-100, higher is worse):

| Score | Meaning | Action |
|-------|---------|--------|
| 0-20 | Low slop (authentic) | Minor tweaks |
| 20-40 | Moderate (some patterns) | Review flagged items |
| 40-60 | High (many patterns) | Significant cleanup |
| 60+ | Severe (heavily generic) | Consider rewriting |

## Integration with Other Skills

### Complementary with Learning Resources

Quality enforcement layer that works alongside any learning resource:

| Task | Learn From | Anti-Slop Skill | Use Together |
|------|------------|-----------------|--------------|
| Write R package functions | R Packages book, cli docs | r/anti-slop | Learn structure + enforce quality |
| Create Quarto docs | Quarto docs | quarto/anti-slop | Learn syntax + detect slop |
| Write package docs | Documentation guides | text/anti-slop | Learn format + enforce clarity |
| Technical writing | Style guides | humanizer | Learn conventions + add voice |

### Workflow Example

**Creating an R package function:**
1. Learn from R Packages book or package documentation
2. Write implementation
3. Run `Rscript toolkit/scripts/detect_slop.R` before committing
4. Apply `r/anti-slop` standards: namespace `::`, explicit `return()`, descriptive names
5. Iterate until quality standards met

Anti-slop is independent quality enforcement, not tied to specific learning resources.

### Content Quality Workflow (Text)

For technical writing, use these three skills in sequence:

1. **text/anti-slop** → Remove AI patterns (transitions, buzzwords, filler)
2. **elements-of-style** → Apply Strunk's principles (active voice, concrete language, brevity)
3. **humanizer** → Add authentic voice and personality

**Example**:
```bash
# Step 1: Remove slop
python toolkit/scripts/clean_slop.py README.md --save

# Step 2: Apply Strunk's principles (Rules 10-13 most important)
# - Rule 10: Use active voice
# - Rule 11: Put statements in positive form
# - Rule 12: Use definite, specific, concrete language
# - Rule 13: Omit needless words

# Step 3: Add voice with humanizer
# Remove Wikipedia's 24 AI writing patterns, add personality
```

## File Organization

```
anti-slop-skills/
├── anti-slop/              # Meta-skill coordinator
│   └── SKILL.md
│
├── toolkit/                # Active detection scripts
│   ├── SKILL.md
│   └── scripts/
│       ├── detect_slop.py
│       ├── detect_slop.R
│       └── clean_slop.py
│
├── r/anti-slop/           # R quality enforcement
│   ├── SKILL.md
│   └── reference/
│
├── python/anti-slop/      # Python quality enforcement
│   ├── SKILL.md
│   └── reference/
│
├── text/anti-slop/        # Technical writing
│   ├── SKILL.md
│   └── reference/
│
├── design/anti-slop/      # Visual quality
│   ├── SKILL.md
│   └── reference/
│
├── quarto/anti-slop/      # Research documents
│   ├── SKILL.md
│   └── reference/
│
├── julia/anti-slop/       # Julia code
├── cpp/anti-slop/         # C++/Rcpp
│
├── external/              # External submodules
│   ├── humanizer/        # [SUBMODULE] Voice/personality
│   ├── elements-of-style/ # [SUBMODULE] Strunk's writing principles
│   └── cc-polymath/      # [SUBMODULE] Additional anti-slop patterns
│
├── docs/                  # Documentation
│   ├── INTEGRATION.md    # How to integrate with other skills
│   └── SUBMODULES.md     # Submodule management guide
│
└── CLAUDE.md              # Context for Claude Code
```

## Unique Value Propositions

Each skill enforces specific quality standards:

- **r/anti-slop**: No generic names (`df`, `data`), always `::`, explicit `return()`
- **python/anti-slop**: Type hints + docstrings required, PEP 8 compliance
- **text/anti-slop**: Remove transitions, buzzwords, filler, meta-commentary
- **humanizer**: Wikipedia's 24 AI writing patterns, add voice
- **elements-of-style**: Strunk's 18 rules for clear, concise writing
- **design/anti-slop**: Detect "AI startup" aesthetic, cookie-cutter layouts
- **quarto/anti-slop**: Ensure reproducibility, prevent template documents
- **toolkit**: Active automated detection with scoring

## Context Awareness

Not all patterns are always slop. Consider:
- **Audience**: Academic writing needs more hedging than blog posts
- **Purpose**: Legal docs need specific phrases
- **Domain**: Some patterns are industry conventions
- **Brand**: If brand uses purple, it's authentic (not generic)

The issue is **unconscious repetition** and **thoughtless copying**, not pattern existence.

## Working with This Repository

When implementing improvements:
1. Maintain progressive disclosure (main file → reference files)
2. Keep skills focused on quality enforcement, not how-to
3. Emphasize complementary relationship with learning resources
4. Use concrete examples (before/after)
5. Provide decision tables for quick reference
6. Include realistic workflows
7. Version all skill updates

## Current Implementation Status

**Phase 1: Core Restructure (95% Complete)**
- ✅ Main SKILL.md files restructured (8 of 8 main skills)
- ✅ Progressive disclosure pattern implemented
- ✅ Decision tables and workflows added
- ✅ Marketplace.json updated with v2.0.0 metadata
- 🔄 Reference files being created (R in progress, others planned)

**Phase 2: Integration (Mostly Complete)**
- ✅ CLAUDE.md updated
- ✅ docs/INTEGRATION.md created
- 📋 Testing with Claude Code pending

**Phase 3: Refinement (Pending)**
- 📋 Julia/C++ skills need restructure
- 📋 All reference files need creation
- 📋 User testing and feedback

## Notes for AI Assistants

When working in this repository:
- Apply the quality standards to your own output
- Use detection scripts proactively
- Reference specific patterns by file:line
- For prose, apply text/anti-slop + humanizer
- Default to specific and concrete over abstract
- These skills are independent quality enforcement, not dependent on Posit
- All v2.0.0 skills follow the new structure pattern
- Reference files are created progressively as needed
