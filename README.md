# Anti-Slop Skills

**Version:** v2.0.0

Catch generic AI patterns before they ship. Works with any learning resource.

## The Problem

AI writes code like this:
```python
def process_data(data):
    """Process the data."""
    result = do_something(data)
    return result
```

Variables named `data` and `result`. Circular documentation. Functions that "process" things.

Anti-slop catches this before it reaches production.

## What You Get

**Learning resources** teach syntax. Books show patterns. Anti-slop enforces quality.

- Automated detection scripts that score your code (0-100)
- Domain-specific skills for R, Python, Julia, C++
- Text analysis that flags buzzwords and filler
- Design pattern detection for cookie-cutter layouts

## Installation

Clone and initialize:

```bash
git clone https://github.com/your-username/anti-slop-skills.git ~/.claude/skills/anti-slop-skills
cd ~/.claude/skills/anti-slop-skills
git submodule update --init --recursive
```

Verify you have the core directories:

```bash
ls -la
# anti-slop/, r/, python/, text/, design/, quarto/, toolkit/, external/
```

### Staying Updated

Pull latest changes:

```bash
git pull
git submodule update --remote --merge
```

That's it. Main repo + all submodules updated.

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
├── docs/                  # Documentation and guides
├── external/              # External skill repositories (submodules)
│   ├── humanizer/         # [SUBMODULE] Voice & personality
│   ├── cc-polymath/       # [SUBMODULE] Additional anti-slop patterns
│   └── elements-of-style/ # [SUBMODULE] Strunk's writing principles
├── CLAUDE.md              # Context for Claude Code
└── README.md              # This file
```

### Submodules (in external/)

External skill collections included as git submodules:

1. **external/humanizer/** - [blader/humanizer](https://github.com/blader/humanizer)
   - Wikipedia's 24-pattern checklist for removing AI writing signatures
   - Adds personality and voice to text

2. **external/elements-of-style/** - [emraher/the-elements-of-style](https://github.com/emraher/the-elements-of-style)
   - Strunk's 18 timeless writing principles
   - Clear, concise prose for documentation and technical writing

3. **external/cc-polymath/** - [rand/cc-polymath](https://github.com/rand/cc-polymath/tree/main/skills/anti-slop)
   - Additional anti-slop patterns and skills
   - Community-contributed quality enforcement

## What's Inside

**Code enforcement:**
- `r/anti-slop` - No more `df` and `data` variables. Always use `pkg::function()`. Explicit `return()` statements.
- `python/anti-slop` - Type hints required. Docstrings required. No mutable default arguments.
- `julia/anti-slop` - Type stability. Multiple dispatch best practices.
- `cpp/anti-slop` - Memory safety. Const-correctness for Rcpp.

**Writing cleanup:**
- `text/anti-slop` - Kills "delve into", "navigate the complexity", "in order to"
- `humanizer` - Wikipedia's 24 AI patterns. Adds actual voice.
- `elements-of-style` - Strunk's rules. Active voice. Omit needless words.
- `quarto/anti-slop` - No template documents. Reproducibility checks.

**Visual quality:**
- `design/anti-slop` - Detects purple gradients, floating 3D shapes, "Empower your business"

**Automation:**
- `toolkit` - Scripts that actually run: `detect_slop.py`, `detect_slop.R`, `clean_slop.py`

**Meta-coordinator:**
- `anti-slop` - Auto-loads the right skill based on file type

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

### What the Scores Mean

| Score | Translation | What to Do |
|-------|-------------|------------|
| 0-20 | Looks human | Ship it (maybe tweak a line or two) |
| 20-40 | Some AI fingerprints | Fix the flagged patterns |
| 40-60 | Generic as hell | Major surgery needed |
| 60+ | ChatGPT called | Start over |

## How to Use This

**Step 1:** Learn from whatever source you prefer (books, docs, tutorials)

**Step 2:** Write your code

**Step 3:** Catch the slop:

```bash
# Check text files
python toolkit/scripts/detect_slop.py README.md --verbose

# Check R code
Rscript toolkit/scripts/detect_slop.R R/

# Score: 0-20 is good, 60+ means rewrite it
```

**Step 4:** Apply the fixes using skill-specific guidance

**Real example** - you write an R function with a variable called `df`. Detection script flags it. You check `r/anti-slop/SKILL.md`, see the forbidden names list, rename it to `survey_data`. Run detection again. Clean.

This isn't a tutorial. It's the thing that catches what tutorials miss.

## Working with Submodules

For full details, see [docs/SUBMODULES.md](docs/SUBMODULES.md).

### Update a specific submodule

```bash
# Update just humanizer
cd external/humanizer && git pull origin main && cd ../..

# Update just elements-of-style
cd external/elements-of-style && git pull origin main && cd ../..


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

Found a pattern we're missing? Add it.

**For this repo:**
- Skills go in root directories: `r/`, `python/`, `text/`
- Follow v2.0.0 structure: main `SKILL.md` + `reference/` files
- Show before/after examples

**For submodules:**
- Humanizer: https://github.com/blader/humanizer
- Elements of Style: https://github.com/emraher/the-elements-of-style
- CC-Polymath: https://github.com/rand/cc-polymath

## Documentation

- **[docs/SUBMODULES.md](docs/SUBMODULES.md)** - Submodule management guide
- **CLAUDE.md** - Context for Claude Code
- Individual **SKILL.md** files in each skill directory

## License

See individual repositories for license information:
- Anti-slop skills: [LICENSE](./LICENSE)
- Humanizer: [blader/humanizer](https://github.com/blader/humanizer/blob/main/README.md#license)
- Elements of Style: Public Domain - [emraher/the-elements-of-style](https://github.com/emraher/the-elements-of-style/blob/main/LICENSE)
- CC-Polymath: [rand/cc-polymath](https://github.com/rand/cc-polymath/blob/main/LICENSE)

## Version History

- **v2.0.0** (2026-01-21) - Complete restructure with workflow-focused patterns
  - All main skills restructured (8/8 completed)
  - Progressive disclosure pattern implemented (main SKILL.md + reference/)
  - Decision tables and realistic workflows added
  - Integration guide created (INTEGRATION.md)
  - Submodules integrated (humanizer, cc-polymath, elements-of-style)
  - Automated detection scripts in toolkit/ updated

- **v1.0.0** - Initial release with pattern catalogs
