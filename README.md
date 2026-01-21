# Anti-Slop Skills

A quality enforcement layer that detects and prevents generic AI-generated patterns across code, text, and design.

## Version

**v2.0.0** - Complete restructure with workflow-focused patterns

## What Makes This Different

This is NOT a how-to guide. This is a **pattern detection and quality enforcement system**.

- **Learning resources** (books, courses, Posit skills) teach you how to use tools and structure projects
- **Anti-slop skills** detect and prevent generic AI garbage
- **Together** they provide complete coverage: learning + quality

These skills work alongside ANY learning resource, including Posit skills.

## Quick Start

### Installation

1. **Clone this repository**:
   ```bash
   git clone https://github.com/your-username/anti-slop-skills.git ~/.claude/skills/anti-slop-skills
   cd ~/.claude/skills/anti-slop-skills
   ```

2. **Initialize submodules** (external skill collections):
   ```bash
   git submodule update --init --recursive
   ```

3. **Verify installation**:
   ```bash
   ls -la
   # Should see: anti-slop/, r/, python/, text/, design/, quarto/, toolkit/, external/

   ls -la external/
   # Should see: humanizer/, cc-polymath/, posit-skills/
   ```

### Update All Skills

To pull the latest updates from all repositories (your skills + submodules):

```bash
# Update main repository
git pull

# Update all submodules (humanizer, cc-polymath, posit-skills)
git submodule update --remote --merge
```

## Repository Structure

```
anti-slop-skills/
├── anti-slop/              # Meta-skill coordinator
├── r/anti-slop/           # R code quality
├── python/anti-slop/      # Python code quality
├── text/anti-slop/        # Technical writing
├── design/anti-slop/      # Visual quality
├── quarto/anti-slop/      # Reproducible research
├── toolkit/               # Automated detection scripts
├── external/              # External skill repositories (submodules)
│   ├── humanizer/         # [SUBMODULE] Voice & personality
│   ├── cc-polymath/       # [SUBMODULE] Additional anti-slop patterns
│   └── posit-skills/      # [SUBMODULE] Posit's official skills
├── INTEGRATION.md         # How to use with other skills
├── CLAUDE.md              # Context for Claude Code
└── README.md              # This file
```

### Submodules (in external/)

This repository includes three external repositories as git submodules in the `external/` directory:

1. **external/humanizer/** - [blader/humanizer](https://github.com/blader/humanizer)
   - Wikipedia's 24-pattern checklist for removing AI writing signatures
   - Adds personality and voice to text

2. **external/cc-polymath/** - [rand/cc-polymath](https://github.com/rand/cc-polymath/tree/main/skills/anti-slop)
   - Additional anti-slop patterns and skills
   - Community-contributed quality enforcement

3. **external/posit-skills/** - [posit-dev/skills](https://github.com/posit-dev/skills)
   - Official Posit skills for R, Quarto, and open-source development
   - Complementary how-to resources

## Core Skills

### Code Quality
- **r/anti-slop** - R code enforcement (namespace `::`, explicit `return()`, no `df`/`data`)
- **python/anti-slop** - Python enforcement (type hints, docstrings, PEP 8)
- **julia/anti-slop** - Julia scientific computing standards
- **cpp/anti-slop** - C++/Rcpp performance code standards

### Content Quality
- **text/anti-slop** - Technical writing (remove transitions, buzzwords, filler)
- **external/humanizer** - Wikipedia 24-pattern checklist (add personality, remove AI signatures)
- **quarto/anti-slop** - Reproducible research documents

### Design Quality
- **design/anti-slop** - Visual patterns ("AI startup" aesthetic detection)

### Automation
- **toolkit** - Detection scripts (`detect_slop.py`, `detect_slop.R`, `clean_slop.py`)

### Meta
- **anti-slop** - Coordinator that auto-loads domain skills by file type

## Quick Commands

### Detection Scripts

```bash
# Detect slop in text files (returns score 0-100)
python toolkit/scripts/detect_slop.py <file.md> [--verbose]

# Detect slop in R code
Rscript toolkit/scripts/detect_slop.R <file.R> [--verbose]

# Clean up text files (with backup)
python toolkit/scripts/clean_slop.py <file.md> --save
```

### Scoring Guide

| Score | Meaning | Action |
|-------|---------|--------|
| 0-20 | Low slop (authentic) | Minor tweaks |
| 20-40 | Moderate (some patterns) | Review flagged items |
| 40-60 | High (many patterns) | Significant cleanup |
| 60+ | Severe (heavily generic) | Consider rewriting |

## Integration with Other Skills

See [INTEGRATION.md](INTEGRATION.md) for detailed guidance on using Anti-Slop skills alongside Posit skills and other learning resources.

### Quick Example

**Creating an R package function:**
1. Use Posit's `r-lib/cli` to learn cli package structure
2. Use `r/anti-slop` to ensure code isn't generic
3. Run `Rscript toolkit/scripts/detect_slop.R` before committing
4. Use Posit's `r-lib/testing` for test structure
5. Use `r/anti-slop` to avoid generic test patterns

The skills are **complementary equals**, not dependent/subordinate.

## Working with Submodules

### Update a specific submodule

```bash
# Update just humanizer
cd external/humanizer && git pull origin main && cd ../..

# Update just Posit skills
cd external/posit-skills && git pull origin main && cd ../..

# Update just cc-polymath
cd external/cc-polymath && git pull origin main && cd ../..
```

### Add new submodules

```bash
git submodule add <repository-url> <path>
git submodule update --init --recursive
```

### Remove a submodule

```bash
# Remove submodule
git submodule deinit <path>
git rm <path>
rm -rf .git/modules/<path>
```

## Contributing

### To Anti-Slop Skills (this repo)
- Main skills in root directories (r/, python/, text/, etc.)
- Follow v2.0.0 pattern (see IMPROVEMENTS.md)
- Progressive disclosure (main SKILL.md + reference/ files)

### To Submodules
- Submit issues/PRs to their respective repositories:
  - Humanizer: https://github.com/blader/humanizer
  - CC-Polymath: https://github.com/rand/cc-polymath
  - Posit Skills: https://github.com/posit-dev/skills

## Documentation

- **INTEGRATION.md** - Using Anti-Slop + Posit skills together
- **CLAUDE.md** - Context for Claude Code
- **PROGRESS_SUMMARY.md** - Implementation status
- **IMPROVEMENTS.md** - Design decisions and rationale

## License

See individual repositories for license information:
- Anti-slop skills: [LICENSE](./License)
- Humanizer: See [external/humanizer/LICENSE](https://github.com/blader/humanizer/tree/3b117912054aab527533523a173999df0bce862f?tab=readme-ov-file#license)
- CC-Polymath: See [external/cc-polymath/LICENSE](https://raw.githubusercontent.com/rand/cc-polymath/2d9a986a14237b1f38c11b2767bca832e5c2c7ba/LICENSE)
- Posit Skills: See [external/posit-skills/LICENSE](https://raw.githubusercontent.com/posit-dev/skills/5869b9b55459b018fa5f2bdc4e1291536623beb3/LICENSE)

## Version History

- **v2.0.0** (2026-01-21) - Complete restructure with workflow-focused patterns
  - All main skills restructured (8/8 completed)
  - Progressive disclosure pattern implemented (main SKILL.md + reference/)
  - Decision tables and realistic workflows added
  - Integration guide created (INTEGRATION.md)
  - Submodules integrated (humanizer, cc-polymath, posit-skills)
  - Automated detection scripts in toolkit/ updated

- **v1.0.0** - Initial release with pattern catalogs
