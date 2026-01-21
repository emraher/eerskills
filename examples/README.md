# Anti-Slop Examples

This directory contains paired examples of "slop" (generic/AI-generated) and "clean" (production-quality) code and text. Use these to test the detection toolkit or as a reference for quality standards.

## How to Use

Run the toolkit detection scripts against these files to see the difference in scoring.

### Text Analysis

```bash
# Detect slop (High score expected)
python ../toolkit/scripts/detect_slop.py text/before-after/documentation_slop.md

# Detect clean (Low score expected)
python ../toolkit/scripts/detect_slop.py text/before-after/documentation_clean.md
```

### R Code Analysis

```bash
# Detect slop (High score expected)
Rscript ../toolkit/scripts/detect_slop.R r/before-after/analysis_slop.R

# Detect clean (Low score expected)
Rscript ../toolkit/scripts/detect_slop.R r/before-after/analysis_clean.R
```

### Python Analysis

Currently, the toolkit focuses on text and R code detection. For Python, compare `python/before-after/processing_slop.py` and `python/before-after/processing_clean.py` manually against the [python/anti-slop](../python/anti-slop/SKILL.md) standards.

## Structure

- **r/before-after/**: R analysis scripts (slop vs clean)
- **python/before-after/**: Python data processing scripts (slop vs clean)
- **text/before-after/**: Technical documentation examples (slop vs clean)
- **workflows/**: Complete workflows showing skill application
- **integration/**: Using Posit + EER skills together
- **bad/**: High-slop examples for testing
