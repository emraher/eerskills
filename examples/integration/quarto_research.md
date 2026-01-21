# Integration Example: Creating a Reproducible Research Paper

This example demonstrates how to use Posit's Quarto skills alongside EER's Anti-Slop skills.

## Step 1: Initialize Project (Posit)
Use `posit/quarto/authoring` to set up the document structure and YAML.

## Step 2: Implement Analysis (Posit)
Use `posit/r-lib/cli` for error handling and `posit/r-lib/testing` for data validation.

## Step 3: Enforce Quality (EER)
Use `r/anti-slop` and `quarto/anti-slop` to clean the implementation.

### Before Cleanup (AI Slop)
```r
# Load data
df <- read_csv("data.csv")

# Plot
ggplot(df, aes(x, y)) + geom_point()
```

### After Cleanup (Anti-Slop)
```r
# Load and validate mortality data
mortality_data <- readr::read_csv(here::here("data", "raw", "mortality.csv"))

# Visualize rates by county
ggplot2::ggplot(
  data = mortality_data,
  mapping = ggplot2::aes(x = age_group, y = death_rate)
) +
  ggplot2::geom_boxplot() +
  ggplot2::theme_minimal()
```

## Step 4: Final Review (EER)
Run detection scripts:
```bash
python toolkit/scripts/detect_slop.py paper.qmd
Rscript toolkit/scripts/detect_slop.R R/analysis.R
```
