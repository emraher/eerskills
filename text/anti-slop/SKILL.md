---
name: text-anti-slop
description: >
  Comprehensive text quality enforcement. Coordinates three complementary systems:
  (1) removes AI slop patterns (transitions, buzzwords, meta-commentary),
  (2) applies Strunk's writing principles (active voice, concrete language, brevity),
  (3) adds authentic human voice (Wikipedia's 24 AI patterns + personality).
  Use for any prose humans will read—documentation, READMEs, blog posts, technical content.
applies_to:
  - "**/*.md"
  - "**/*.txt"
  - "**/*.rst"
tags: [writing, documentation, technical-writing, clarity, quality]
related_skills:
  - external/humanizer
  - external/elements-of-style
  - r/anti-slop
  - python/anti-slop
  - quarto/anti-slop
version: 3.0.0
---

# Text Anti-Slop: Comprehensive Writing Quality Coordinator

## What This Skill Does

This skill **coordinates three complementary writing quality systems** in a single pass:

1. **Pattern Removal** (text/anti-slop core) → Remove transitions, buzzwords, meta-commentary, filler
2. **Strunk's Principles** (elements-of-style) → Active voice, positive form, concrete language, brevity
3. **Human Voice** (humanizer) → Remove Wikipedia's 24 AI patterns, add personality

**One invocation = complete text quality enforcement.**

## When to Use This

Use this skill when writing or reviewing:
- ✓ Technical docs, READMEs, guides, tutorials
- ✓ AI-generated documentation (before anyone sees it)
- ✓ Blog posts, articles, technical explanations
- ✓ Package documentation (roxygen, docstrings)
- ✓ Commit messages, PR descriptions
- ✓ Anything going to users or teammates

Skip this for:
- Creative fiction (different rules)
- Legal documents (specific phrasings required)
- Marketing copy (persuasion has its own game)
- Style guide compliance (AP, Chicago override this)

## Quick Example

**Before (AI Slop)**:
> In this document, we will delve into the complexities of API design. It's important to note that in today's fast-paced landscape, leveraging best practices is a testament to your commitment to quality. We'll navigate through various approaches—REST, GraphQL, and gRPC—ultimately providing you with actionable insights to empower your development workflow. Additionally, the ecosystem boasts vibrant community support.

**After (Anti-Slop)**:
> This guide covers three API design patterns: REST, GraphQL, and gRPC. Each section shows code examples and trade-offs. I'll be honest—I keep coming back to REST for most projects. It's boring, but that's the point.

**What changed**:
1. **Pattern Removal**: Deleted "delve into", "navigate", "leverage", "empower", meta-commentary
2. **Strunk's Principles**: Active voice ("guide covers" not "will be provided"), concrete language (specific patterns not "approaches"), omit needless words
3. **Human Voice**: Added first person ("I'll be honest"), opinion, personality, removed "boasts vibrant"

## Three-Layer System

### Layer 1: Pattern Removal (Core Anti-Slop)

**Removes immediately**:
- **Transitions**: "delve into", "navigate complexities", "in today's landscape"
- **Buzzwords**: "leverage", "empower", "unlock", "synergy", "paradigm shift"
- **Meta-commentary**: "In this section...", "Let's explore...", "As we'll see..."
- **Filler**: "in order to" → "to", "due to the fact that" → "because"

**Detection script**: `python3 toolkit/scripts/detect_slop.py file.md --verbose`

### Layer 2: Strunk's Principles (Elements of Style)

**Applies 18 rules** (from external/elements-of-style), especially:

- **Rule 10: Active voice**
  - Bad: "The function was implemented by the team"
  - Good: "The team implemented the function"

- **Rule 11: Positive form**
  - Bad: "The API is not very reliable"
  - Good: "The API fails frequently"

- **Rule 12: Concrete language**
  - Bad: "The system provides various capabilities"
  - Good: "The system validates emails, stores users, and sends alerts"

- **Rule 13: Omit needless words**
  - Bad: "In order to utilize the functionality"
  - Good: "To use this feature"

**Source**: external/elements-of-style/skills/writing-clearly-and-concisely/elements-of-style.md

### Layer 3: Human Voice (Humanizer)

**Removes 24+ Wikipedia AI patterns** (from external/humanizer), including:

- **Inflated symbolism**: "stands as a testament", "marks a pivotal moment"
- **Promotional language**: "boasts", "vibrant", "nestled", "stunning"
- **-ing analyses**: "highlighting its importance, showcasing the benefits"
- **AI vocabulary**: "delve", "landscape" (abstract), "tapestry", "intricate"
- **Copula avoidance**: "serves as" → "is"
- **Rule of three**: Forcing everything into groups of 3

**Adds personality**:
- First person when appropriate ("I keep thinking about...")
- Opinions ("This is clever but feels fragile")
- Varied rhythm (short punchy. Then longer flowing sentences.)
- Acknowledgment of uncertainty ("I genuinely don't know")

**Source**: external/humanizer/SKILL.md

## When to Use What

| If you see... | Remove/Replace | Layer | Details |
|---------------|----------------|-------|---------|
| "delve into" | "examine" or delete | 1 + 3 | Core pattern + AI vocab |
| "leverage" | "use" | 1 | Buzzword |
| "in order to" | "to" | 1 + 2 | Filler + Rule 13 |
| Passive voice | Active voice | 2 | Rule 10 |
| "not reliable" | "unreliable" or "fails" | 2 | Rule 11 (positive form) |
| "various things" | Specific list | 2 | Rule 12 (concrete) |
| "stands as a testament" | Delete or be specific | 3 | Inflated symbolism |
| "boasts 500 features" | "has 500 features" | 3 | Promotional + copula |
| Every sentence same length | Vary rhythm | 3 | Add personality |

## Core Workflow

### Comprehensive 4-Step Process

**Step 1: Pattern Detection & Removal**
```markdown
# Run detection first
python3 toolkit/scripts/detect_slop.py README.md --verbose

# Before (score: 65 - high slop)
In this document, we will delve into the complexities of configuration
management. It's important to note that in today's fast-paced world,
leveraging automated solutions is crucial for success.

# After (Layer 1 applied)
This guide covers configuration management. Automated solutions
reduce manual errors.
```

**Step 2: Apply Strunk's Principles**
```markdown
# Before (passive, vague)
Configuration files are stored by the system in /etc/config.
Various validation checks are performed.

# After (Layer 2: Rules 10, 12)
The system stores configuration files in /etc/config.
The validator checks syntax, required fields, and data types.
```

**Step 3: Add Human Voice**
```markdown
# Before (soulless but clean)
The system performs validation. Some users report issues.
The implications remain unclear.

# After (Layer 3: personality + opinion)
The validator catches 90% of errors—but I keep seeing users
trip over the same edge case with nested arrays. Not sure if
that's a docs problem or a design problem. Probably both.
```

**Step 4: Verify & Iterate**
```bash
# Check final score
python3 toolkit/scripts/detect_slop.py README.md --verbose

# Target: < 20 (low slop)
# If > 20, review flagged patterns and refine
```

## Quick Reference Checklist

Before publishing, verify all three layers:

### Layer 1: Pattern Removal
- [ ] No meta-commentary ("In this guide...", "Let's explore...")
- [ ] No high-risk transitions ("delve into", "navigate complexities")
- [ ] No corporate buzzwords ("leverage", "synergistic", "paradigm shift")
- [ ] No wordy constructions ("in order to" → "to")

### Layer 2: Strunk's Principles
- [ ] Active voice (Rule 10)
- [ ] Positive statements (Rule 11: "fails" not "not reliable")
- [ ] Concrete language (Rule 12: specifics not "various things")
- [ ] No needless words (Rule 13: ruthlessly cut)
- [ ] Related words together (Rule 16)

### Layer 3: Human Voice
- [ ] No inflated symbolism ("testament", "pivotal moment")
- [ ] No promotional language ("boasts", "vibrant", "stunning")
- [ ] No AI vocabulary overuse ("delve", "landscape", "tapestry")
- [ ] No copula avoidance ("is" not "serves as")
- [ ] Varied sentence rhythm
- [ ] Personality present (first person, opinions, mixed feelings)

## Common Workflows

### Workflow 1: Clean AI-Generated Documentation

**Context**: AI generated a README with heavy slop patterns.

**Apply all three layers**:

```markdown
# Before (score: 72 - severe slop)
In today's fast-paced landscape of software development, configuration
management stands as a testament to the importance of automation.
This comprehensive guide will delve into the intricacies of our
cutting-edge solution, which boasts vibrant features and serves as
an essential tool for developers. Leveraging advanced techniques,
it enables teams to unlock their full potential.

# After Layer 1 (pattern removal)
This guide covers configuration management automation. Our tool
includes multiple features for development teams.

# After Layer 2 (Strunk's principles)
This tool automates configuration management. It validates syntax,
tracks changes, and rolls back errors.

# After Layer 3 (add voice)
This tool automates config management—validates syntax, tracks
changes, rolls back errors. I've been using it for six months.
The rollback feature saved me twice. The syntax validator? Still
learning its edge cases.

# Final score: 12 (low slop)
```

---

### Workflow 2: Technical Blog Post

**Context**: Writing a blog post about API design.

**Progressive refinement**:

```markdown
# Draft (needs all three layers)
In this article, we will delve into the complexities of API design
patterns. Additionally, it's important to note that REST, GraphQL,
and gRPC each serve as viable approaches, showcasing the vibrant
landscape of modern development. Ultimately, the choice was made
to leverage REST due to its simplicity.

# After Layer 1 (remove slop)
This article covers API design patterns. REST, GraphQL, and gRPC
are approaches in modern development. We chose REST for its
simplicity.

# After Layer 2 (Strunk's rules)
This post compares three API patterns: REST, GraphQL, and gRPC.
We chose REST because it's simple.

# After Layer 3 (add personality)
I keep coming back to REST. Everyone gets excited about GraphQL—
underfetching! type safety!—and they're not wrong. But for this
project? REST just works. Sometimes boring is the right answer.
```

---

### Workflow 3: Package Documentation

**Context**: Writing roxygen2 docs for an R package function.

**Apply focused layers**:

```markdown
# Before (AI-generated roxygen)
#' Process Data Function
#'
#' This function is designed to process data in a comprehensive manner.
#' It serves as an essential tool for data manipulation, enabling users
#' to leverage advanced techniques. The function boasts robust error
#' handling capabilities.
#'
#' @param data A data frame that contains the data to be processed
#' @return A processed data frame will be returned
#' @export

# After all three layers
#' Validate and normalize customer records
#'
#' Checks required fields (name, email, phone), normalizes phone
#' numbers to E.164 format, and flags duplicates by email.
#'
#' @param data Data frame with columns: name, email, phone
#' @return Data frame with validated records, invalid rows removed
#' @export
```

**What improved**:
- Layer 1: Removed "comprehensive manner", "enabling users", "boasts"
- Layer 2: Active voice ("Checks" not "will be returned"), concrete ("E.164 format" not "advanced techniques")
- Layer 3: Removed copula avoidance ("is designed to"), specific instead of promotional

---

## Mandatory Rules Summary

### Layer 1: Pattern Removal

**1. No Meta-Commentary**
- Bad: "In this section..." "Let's explore..." "As we'll see..."
- Good: Just say the thing.

**2. Lead with the Point**
- Bad: Preamble → context → point
- Good: Point → details

**3. Simple Not Wordy**
- "in order to" → "to"
- "due to the fact that" → "because"
- "has the ability to" → "can"

### Layer 2: Strunk's Principles (Most Critical)

**Rule 10: Active Voice**
- Bad: "The bug was fixed by the team"
- Good: "The team fixed the bug"

**Rule 11: Positive Form**
- Bad: "not uncommon", "not very reliable"
- Good: "common", "unreliable" or "fails frequently"

**Rule 12: Concrete Language**
- Bad: "various capabilities", "multiple features"
- Good: List specific capabilities

**Rule 13: Omit Needless Words**
- Ruthlessly cut. Every word must earn its place.

### Layer 3: Human Voice

**1. Remove AI Signatures**
- "stands as a testament", "marks a pivotal moment" → delete or be specific
- "boasts", "vibrant", "nestled" → neutral language
- "serves as", "stands as" → "is"

**2. Add Personality**
- First person when appropriate
- Opinions and reactions
- Varied rhythm
- Acknowledge uncertainty

## Resources & Reference Files

### Detection & Cleanup Scripts

```bash
# Detect slop patterns (0-100 score)
python3 toolkit/scripts/detect_slop.py README.md --verbose

# Automated cleanup (with backup)
python3 toolkit/scripts/clean_slop.py README.md --save
python3 toolkit/scripts/clean_slop.py README.md --save --aggressive
```

### External References

This skill coordinates these external resources:

1. **external/humanizer/SKILL.md** (~2,500 tokens)
   - Wikipedia's 24 AI writing patterns
   - Personality and voice guidance
   - Before/after examples

2. **external/elements-of-style/skills/writing-clearly-and-concisely/elements-of-style.md** (~1,400 tokens)
   - Strunk's 18 writing rules
   - Grammar and composition principles
   - Technical writing examples

3. **Text/anti-slop core patterns** (this file)
   - Transitions catalog
   - Buzzword detection
   - Meta-commentary patterns
   - Filler phrase replacements

### Reference Files (Planned)

- **reference/transitions.md** - Overused transition phrases to avoid
- **reference/buzzwords.md** - Corporate jargon catalog and replacements
- **reference/filler.md** - Wordy constructions and alternatives
- **reference/meta-commentary.md** - Self-referential patterns to delete
- **reference/structure.md** - Document organization principles

## Scoring Guide

Detection scripts output scores (0-100, higher is worse):

| Score | Meaning | Action |
|-------|---------|--------|
| 0-20 | Low slop (authentic) | Minor tweaks |
| 20-40 | Moderate (some patterns) | Review flagged items |
| 40-60 | High (many patterns) | Significant cleanup |
| 60+ | Severe (heavily generic) | Apply all three layers |

**Target**: < 20 for all published content

## Context Awareness

Not all patterns are always slop. Consider:

- **Audience**: Academic writing may need more hedging than blog posts
- **Purpose**: Legal docs need specific phrases; marketing needs energy
- **Length**: Longer pieces need some transitions (but not "delve")
- **Domain**: Technical docs have different norms than creative writing
- **Brand**: If your brand voice uses first person, lean into it

The issue is **overuse** and **unconscious AI-generated repetition**, not pattern existence.

## How This Differs from Individual Skills

### Using Skills Separately (Old Workflow)
```
1. Invoke text/anti-slop (patterns only)
2. Invoke elements-of-style (Strunk's rules)
3. Invoke humanizer (voice and personality)
→ Three separate invocations, easy to skip steps
```

### Using This Coordinator (New Workflow)
```
1. Invoke text/anti-slop (applies all three automatically)
→ One invocation, comprehensive coverage
```

**Benefits**:
- Consistent application across all writing
- Can't accidentally skip layers
- Patterns reinforce each other (e.g., Rule 13 + filler removal)
- Single quality score

**Trade-off**:
- Less granular control if you only want one layer
- (If you need that, invoke external skills directly)

## Integration with Code Quality Skills

For domain-specific documentation:

| Content Type | Use This Skill + | Also Apply |
|--------------|------------------|------------|
| R package docs | text/anti-slop (all 3 layers) | r/anti-slop (namespace, returns) |
| Python docstrings | text/anti-slop (all 3 layers) | python/anti-slop (type hints, PEP 8) |
| Quarto documents | text/anti-slop (all 3 layers) | quarto/anti-slop (reproducibility) |
| General markdown | text/anti-slop (all 3 layers) | (sufficient alone) |

**Workflow example** (R package documentation):
1. Write roxygen2 docs
2. Apply text/anti-slop (removes patterns, applies Strunk, adds voice)
3. Apply r/anti-slop (enforces R-specific quality: `::`, explicit `return()`)
4. Run detection: `Rscript toolkit/scripts/detect_slop.R R/`
5. Target score < 20

## Version History

- **v3.0.0** (2026-01): Restructured as comprehensive coordinator, integrates humanizer + elements-of-style
- **v2.0.0** (2025-12): Progressive disclosure pattern, decision tables
- **v1.0.0**: Original text/anti-slop (patterns only)

## Bottom Line

**Writing for humans?** This skill applies three complementary systems automatically:
1. Removes AI slop patterns
2. Applies Strunk's timeless principles
3. Adds authentic human voice

One invocation. Complete coverage. Professional results.
