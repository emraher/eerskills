#!/usr/bin/env Rscript

#' AI Slop Detector for R Code
#'
#' Analyzes R source files for common AI-generated code patterns.
#'
#' Usage:
#'   Rscript detect_slop.R <file.R> [--verbose]
#'   Rscript detect_slop.R <directory> [--verbose]

# Parse command line arguments
args <- commandArgs(trailingOnly = TRUE)

if (length(args) < 1) {
  cat("Usage: Rscript detect_slop.R <file.R|directory> [--verbose]\n")
  cat("Analyzes R code files for AI-generated content patterns\n")
  quit(status = 1)
}

target_path <- args[1]
verbose <- "--verbose" %in% args || "-v" %in% args

if (!file.exists(target_path)) {
  cat(sprintf("Error: '%s' not found\n", target_path))
  quit(status = 1)
}

# Pattern definitions ----

# Generic variable names (weighted by specificity)
GENERIC_VAR_PATTERNS <- list(
  high_risk = c(
    "^df[0-9]*$",       # df, df1, df2
    "^dat[a]?[0-9]*$",  # dat, data, data1
    "^temp[0-9]*$",     # temp, temp1
    "^res(ult)?[0-9]*$", # res, result, result1
    "^out(put)?[0-9]*$", # out, output
    "^my_[a-z_]+$",     # my_data, my_function
    "^ret(val)?$"       # ret, retval
  ),
  medium_risk = c(
    "^[xyzij]$",        # single letters (outside loops)
    "^[nm]$",           # n, m as counts
    "^tmp$",
    "^val(ue)?[0-9]*$"
  )
)

# Generic function names
GENERIC_FUNC_PATTERNS <- c(
  "^process_",
  "^do_",
  "^handle_",
  "^helper",
  "^my_",
  "^run_",
  "^execute_",
  "^perform_"
)

# Obvious comments that restate code
OBVIOUS_COMMENT_PATTERNS <- c(
  "^#\\s*(load|import)\\s+(the\\s+)?(librar|package)",
  "^#\\s*read\\s+(the\\s+)?data",
  "^#\\s*filter\\s+(the\\s+)?data",
  "^#\\s*create\\s+(a\\s+)?(plot|graph|figure)",
  "^#\\s*define\\s+(a\\s+)?function",
  "^#\\s*set\\s+(the\\s+)?seed",
  "^#\\s*install\\s+package",
  "^#\\s*print\\s+(the\\s+)?result",
  "^#\\s*return\\s+(the\\s+)?result",
  "^#\\s*initialize",
  "^#\\s*loop\\s+(through|over)",
  "^#\\s*check\\s+if"
)

# Section dividers
SECTION_DIVIDER_PATTERNS <- c(
  "^#{3,}\\s*$",           # ######
  "^#[=-]{3,}",            # #==== or #----
  "^#\\s*[=-]{3,}",        # # ====
  "^#\\s*[A-Z ]{5,}\\s*$"  # # SECTION NAME
)

# Roxygen slop patterns
ROXYGEN_SLOP_PATTERNS <- c(
  "@description\\s+This\\s+function",
  "@param\\s+\\w+\\s+The\\s+\\w+\\.$",      # @param x The x.
  "@param\\s+data\\s+The\\s+data",
  "@param\\s+\\w+\\s+A\\s+(number|value|string)\\.$",
  "@return\\s+(The\\s+)?result",
  "@return\\s+Returns\\s+the",
  "@return\\s+A\\s+value"
)

# Analysis functions ----

detect_generic_variables <- function(lines, line_numbers) {
  findings <- list()

  # Find assignment patterns
  assignment_pattern <- "([a-zA-Z_][a-zA-Z0-9_.]*)\\s*(<-|=)\\s*"

  for (i in seq_along(lines)) {
    line <- lines[i]
    line_num <- line_numbers[i]

    # Skip comments and strings
    if (grepl("^\\s*#", line)) next

    matches <- gregexpr(assignment_pattern, line, perl = TRUE)
    if (matches[[1]][1] != -1) {
      matched_text <- regmatches(line, matches)[[1]]
      for (m in matched_text) {
        var_name <- sub("\\s*(<-|=)\\s*$", "", m)
        var_name <- trimws(var_name)

        for (pattern in GENERIC_VAR_PATTERNS$high_risk) {
          if (grepl(pattern, var_name, ignore.case = TRUE)) {
            findings[[length(findings) + 1]] <- list(
              line = line_num,
              text = trimws(line),
              match = var_name,
              severity = "high"
            )
          }
        }

        for (pattern in GENERIC_VAR_PATTERNS$medium_risk) {
          if (grepl(pattern, var_name, ignore.case = TRUE)) {
            # Don't flag loop variables
            if (!grepl("for\\s*\\(", line)) {
              findings[[length(findings) + 1]] <- list(
                line = line_num,
                text = trimws(line),
                match = var_name,
                severity = "medium"
              )
            }
          }
        }
      }
    }
  }

  findings
}

detect_generic_functions <- function(lines, line_numbers) {
  findings <- list()

  func_pattern <- "([a-zA-Z_][a-zA-Z0-9_.]*)\\s*<-\\s*function\\s*\\("

  for (i in seq_along(lines)) {
    line <- lines[i]
    line_num <- line_numbers[i]

    if (grepl(func_pattern, line)) {
      func_name <- sub("\\s*<-\\s*function.*", "", line)
      func_name <- trimws(func_name)

      for (pattern in GENERIC_FUNC_PATTERNS) {
        if (grepl(pattern, func_name, ignore.case = TRUE)) {
          findings[[length(findings) + 1]] <- list(
            line = line_num,
            text = trimws(line),
            match = func_name
          )
        }
      }
    }
  }

  findings
}

detect_obvious_comments <- function(lines, line_numbers) {
  findings <- list()

  for (i in seq_along(lines)) {
    line <- lines[i]
    line_num <- line_numbers[i]

    for (pattern in OBVIOUS_COMMENT_PATTERNS) {
      if (grepl(pattern, line, ignore.case = TRUE)) {
        findings[[length(findings) + 1]] <- list(
          line = line_num,
          text = trimws(line),
          match = "obvious comment"
        )
        break
      }
    }
  }

  findings
}

detect_section_dividers <- function(lines, line_numbers) {
  findings <- list()

  for (i in seq_along(lines)) {
    line <- lines[i]
    line_num <- line_numbers[i]

    for (pattern in SECTION_DIVIDER_PATTERNS) {
      if (grepl(pattern, line)) {
        # Allow RStudio section markers (ending with ----)
        if (!grepl("----\\s*$", line)) {
          findings[[length(findings) + 1]] <- list(
            line = line_num,
            text = trimws(line),
            match = "section divider"
          )
          break
        }
      }
    }
  }

  findings
}

detect_single_pipes <- function(lines, line_numbers) {
  findings <- list()

  # Pattern: x %>% f() on single line with no continuation
  single_pipe_pattern <- "^[^#]*%>%[^%]*$"

  for (i in seq_along(lines)) {
    line <- lines[i]
    line_num <- line_numbers[i]

    if (grepl(single_pipe_pattern, line)) {
      # Check it's truly a single pipe (not multi-line)
      pipe_count <- length(gregexpr("%>%", line)[[1]])
      if (pipe_count == 1) {
        # Check next line doesn't continue the pipe
        if (i == length(lines) || !grepl("^\\s*%>%", lines[i + 1])) {
          findings[[length(findings) + 1]] <- list(
            line = line_num,
            text = trimws(line),
            match = "single pipe"
          )
        }
      }
    }
  }

  findings
}

detect_roxygen_slop <- function(lines, line_numbers) {
  findings <- list()

  for (i in seq_along(lines)) {
    line <- lines[i]
    line_num <- line_numbers[i]

    if (grepl("^#'", line)) {
      for (pattern in ROXYGEN_SLOP_PATTERNS) {
        if (grepl(pattern, line, ignore.case = TRUE)) {
          findings[[length(findings) + 1]] <- list(
            line = line_num,
            text = trimws(line),
            match = "generic roxygen"
          )
          break
        }
      }
    }
  }

  findings
}

detect_long_pipe_chains <- function(lines, line_numbers) {
  findings <- list()
  chain_start <- NULL
  pipe_count <- 0

  for (i in seq_along(lines)) {
    line <- lines[i]

    if (grepl("%>%|\\|>", line)) {
      if (is.null(chain_start)) {
        chain_start <- i
      }
      pipe_count <- pipe_count + length(gregexpr("%>%|\\|>", line)[[1]])
    } else if (!grepl("^\\s*$", line) && !is.null(chain_start)) {
      # End of chain
      if (pipe_count > 8) {
        findings[[length(findings) + 1]] <- list(
          line = line_numbers[chain_start],
          text = sprintf("Pipe chain with %d operations", pipe_count),
          match = "long pipe chain"
        )
      }
      chain_start <- NULL
      pipe_count <- 0
    }
  }

  findings
}

# Main analysis ----

analyze_file <- function(filepath) {
  lines <- readLines(filepath, warn = FALSE)
  line_numbers <- seq_along(lines)

  results <- list(
    filepath = filepath,
    generic_vars = detect_generic_variables(lines, line_numbers),
    generic_funcs = detect_generic_functions(lines, line_numbers),
    obvious_comments = detect_obvious_comments(lines, line_numbers),
    section_dividers = detect_section_dividers(lines, line_numbers),
    single_pipes = detect_single_pipes(lines, line_numbers),
    roxygen_slop = detect_roxygen_slop(lines, line_numbers),
    long_pipes = detect_long_pipe_chains(lines, line_numbers)
  )

  # Calculate score
  word_count <- sum(lengths(strsplit(lines, "\\s+")))

  score <- 0
  score <- score + length(results$generic_vars) * 5
  score <- score + length(results$generic_funcs) * 10
  score <- score + length(results$obvious_comments) * 8
  score <- score + length(results$section_dividers) * 3

  score <- score + length(results$single_pipes) * 2
  score <- score + length(results$roxygen_slop) * 6
  score <- score + length(results$long_pipes) * 4

  # Normalize by code length
  if (word_count > 0) {
    score <- round((score / word_count) * 500)
  }
  results$score <- min(score, 100)

  results$summary <- if (results$score < 20) {
    "Low slop - code appears thoughtfully written"
  } else if (results$score < 40) {
    "Moderate slop - some generic patterns present"
  } else if (results$score < 60) {
    "High slop - many AI-generated patterns found"
  } else {
    "Severe slop - heavily generic code"
  }

  results
}

print_report <- function(results, verbose = FALSE) {
  cat("\n")
  cat(strrep("=", 70), "\n")
  cat(sprintf("R Code Slop Detection Report: %s\n", basename(results$filepath)))
  cat(strrep("=", 70), "\n\n")

  cat(sprintf("Overall Slop Score: %d/100\n", results$score))

  # Score indicator
  indicator <- if (results$score < 20) {
    "LOW"
  } else if (results$score < 40) {
    "MODERATE"
  } else if (results$score < 60) {
    "HIGH"
  } else {
    "SEVERE"
  }
  cat(sprintf("Assessment: [%s] %s\n\n", indicator, results$summary))

  # Generic variables
  high_vars <- Filter(function(x) x$severity == "high", results$generic_vars)
  if (length(high_vars) > 0) {
    cat(sprintf("GENERIC VARIABLE NAMES (%d found):\n", length(high_vars)))
    shown <- if (verbose) high_vars else head(high_vars, 5)
    for (f in shown) {
      cat(sprintf("  Line %d: '%s' in: %s\n",
                  f$line, f$match, substr(f$text, 1, 50)))
    }
    if (!verbose && length(high_vars) > 5) {
      cat(sprintf("  ... and %d more\n", length(high_vars) - 5))
    }
    cat("\n")
  }

  # Generic functions
  if (length(results$generic_funcs) > 0) {
    cat(sprintf("GENERIC FUNCTION NAMES (%d found):\n", length(results$generic_funcs)))
    for (f in results$generic_funcs) {
      cat(sprintf("  Line %d: '%s'\n", f$line, f$match))
    }
    cat("\n")
  }

  # Obvious comments
  if (length(results$obvious_comments) > 0) {
    cat(sprintf("OBVIOUS COMMENTS (%d found):\n", length(results$obvious_comments)))
    shown <- if (verbose) results$obvious_comments else head(results$obvious_comments, 5)
    for (f in shown) {
      cat(sprintf("  Line %d: %s\n", f$line, substr(f$text, 1, 60)))
    }
    if (!verbose && length(results$obvious_comments) > 5) {
      cat(sprintf("  ... and %d more\n", length(results$obvious_comments) - 5))
    }
    cat("\n")
  }

  # Roxygen slop
  if (length(results$roxygen_slop) > 0) {
    cat(sprintf("GENERIC ROXYGEN DOCS (%d found):\n", length(results$roxygen_slop)))
    shown <- if (verbose) results$roxygen_slop else head(results$roxygen_slop, 5)
    for (f in shown) {
      cat(sprintf("  Line %d: %s\n", f$line, substr(f$text, 1, 60)))
    }
    if (!verbose && length(results$roxygen_slop) > 5) {
      cat(sprintf("  ... and %d more\n", length(results$roxygen_slop) - 5))
    }
    cat("\n")
  }

  # Single pipes
  if (length(results$single_pipes) > 0) {
    cat(sprintf("UNNECESSARY SINGLE PIPES (%d found):\n", length(results$single_pipes)))
    if (verbose) {
      for (f in head(results$single_pipes, 5)) {
        cat(sprintf("  Line %d: %s\n", f$line, substr(f$text, 1, 60)))
      }
    } else {
      cat(sprintf("  Found in %d lines (use --verbose to see details)\n",
                  length(results$single_pipes)))
    }
    cat("\n")
  }

  # Long pipe chains
  if (length(results$long_pipes) > 0) {
    cat(sprintf("OVERLY LONG PIPE CHAINS (%d found):\n", length(results$long_pipes)))
    for (f in results$long_pipes) {
      cat(sprintf("  Line %d: %s\n", f$line, f$text))
    }
    cat("\n")
  }

  # Recommendations
  if (results$score > 20) {
    cat("RECOMMENDATIONS:\n")
    if (length(high_vars) > 0) {
      cat("  - Replace generic variable names (df, data, temp) with descriptive names\
n")
    }
    if (length(results$generic_funcs) > 0) {
      cat("  - Rename generic functions (process_*, do_*) to describe what they do\n")
    }
    if (length(results$obvious_comments) > 0) {
      cat("  - Remove comments that restate what code clearly does\n")
    }
    if (length(results$roxygen_slop) > 0) {
      cat("  - Improve roxygen docs: describe behavior, not syntax\n")
    }
    if (length(results$single_pipes) > 0) {
      cat("  - Remove single pipes: use f(x) instead of x %>% f()\n")
    }
    if (length(results$long_pipes) > 0) {
      cat("  - Break long pipe chains into meaningful intermediate variables\n")
    }
    cat("\n")
  }
}

# Run analysis ----

if (dir.exists(target_path)) {
  r_files <- list.files(target_path, pattern = "\\.[Rr]$",
                        recursive = TRUE, full.names = TRUE)
  if (length(r_files) == 0) {
    cat("No R files found in directory\n")
    quit(status = 1)
  }

  total_score <- 0
  for (filepath in r_files) {
    results <- analyze_file(filepath)
    print_report(results, verbose)
    total_score <- total_score + results$score
  }

  if (length(r_files) > 1) {
    avg_score <- round(total_score / length(r_files))
    cat(strrep("=", 70), "\n")
    cat(sprintf("SUMMARY: Analyzed %d files, average slop score: %d/100\n",
                length(r_files), avg_score))
    cat(strrep("=", 70), "\n")
  }
} else {
  results <- analyze_file(target_path)
  print_report(results, verbose)
}
