# Visualization Standards in Quarto

Figures in Quarto must be labeled, captioned, and cross-referenced.

## 1. Chunk Options

Use the `#|` hash-pipe syntax, not the legacy `{r, ...}` header.

```r
#| label: fig-revenue
#| fig-cap: "Quarterly revenue growth by region."
#| fig-width: 8
#| fig-height: 5
#| warning: false

ggplot(data, aes(x, y)) + geom_line()
```

## 2. Cross-Referencing

Never say "the figure below." Use the ID.

- **Markdown**: "As shown in @fig-revenue..."
- **Output**: "As shown in Figure 1..."

## 3. Tables

Tables also need labels and captions.

```r
#| label: tbl-summary
#| tbl-cap: "Summary statistics for 2024."

knitr::kable(head(data))
```

Reference with `@tbl-summary`.

## 4. Figure Sizing

Don't rely on defaults. Specify size for legibility.

- `fig-width`, `fig-height`: In inches.
- `out-width`: Percentage (e.g., "100%") for HTML scaling.
- `fig-dpi`: Resolution (300 for print/PDF, 96/72 for screen).

## 5. Alt Text

Always provide alt text for accessibility.

```r
#| fig-alt: "Line chart showing upward trend in revenue from Q1 to Q4."
```

## 6. Multiple Figures

Use layout options for subplots.

```r
#| label: fig-comparison
#| fig-cap: "Comparison of metrics."
#| layout-ncol: 2

plot(x)
plot(y)
```

## Slop vs. Professional

**Slop**:
- Unlabeled chunk.
- No caption.
- Default sizing (often too small text).
- "See figure below."

**Professional**:
- `#| label: fig-specific-name`
- Descriptive caption.
- Explicit sizing.
- "See @fig-specific-name."
