# Quarto YAML Configuration

The YAML header controls the execution and rendering of your document. "Slop" YAML is often minimal, incorrect, or copied from legacy RMarkdown templates.

## Essential Metadata

Always include these fields for professional documents.

```yaml
---
title: "Document Title"
subtitle: "Optional Subtitle"
date: last-modified
author:
  - name: Your Name
    affiliation: Organization
    orcid: 0000-0000-0000-0000
description: "Brief summary of the document contents."
categories: [analysis, r, report]
---
```

## Execution Options

Control how code runs.

```yaml
execute:
  echo: false        # Don't show code (default for papers)
  warning: false     # Don't show warnings
  message: false     # Don't show messages
  cache: true        # Cache results
  freeze: auto       # Freeze for static site generation
```

## Output Formats

### HTML (Reports)
```yaml
format:
  html:
    theme: cosmo
    toc: true
    toc-depth: 3
    code-fold: true
    code-tools: true
    embed-resources: true  # Self-contained file
```

### PDF (Papers)
```yaml
format:
  pdf:
    documentclass: article
    keep-tex: true
    number-sections: true
    colorlinks: true
```

## Bibliography

Use BibTeX for referencing.

```yaml
bibliography: references.bib
csl: apa.csl  # Optional style
link-citations: true
```

## Cross-Referencing

Enable cross-refs for figures, tables, and equations.

```yaml
crossref:
  fig-title: Figure
  tbl-title: Table
  eq-title: Equation
```

## Project-Level Config

For `_quarto.yml` (projects/books/websites):

```yaml
project:
  type: website
  output-dir: docs

website:
  navbar:
    left:
      - href: index.qmd
        text: Home
```

## Slop vs. Professional

**Slop**:
```yaml
---
title: "Untitled"
output: html_document
---
```

**Professional**:
```yaml
---
title: "Q3 Sales Analysis"
author: "Data Science Team"
date: today
format:
  html:
    embed-resources: true
    toc: true
execute:
  warning: false
---
```
