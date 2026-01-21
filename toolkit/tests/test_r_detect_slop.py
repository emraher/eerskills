import unittest
import subprocess
import shutil
import os
from pathlib import Path
import tempfile

class TestRSlopDetector(unittest.TestCase):
    def setUp(self):
        # Locate the R script
        self.project_root = Path(__file__).resolve().parents[2]
        self.r_script = self.project_root / 'toolkit' / 'scripts' / 'detect_slop.R'
        
        # Check if Rscript is available
        if shutil.which('Rscript') is None:
            self.skipTest("Rscript not found in PATH")
            
        if not self.r_script.exists():
            self.fail(f"R detection script not found at {self.r_script}")

        self.test_dir = tempfile.TemporaryDirectory()

    def tearDown(self):
        self.test_dir.cleanup()

    def run_r_script(self, file_path):
        """Helper to run the R script and capture output."""
        result = subprocess.run(
            ['Rscript', str(self.r_script), str(file_path)],
            capture_output=True,
            text=True
        )
        return result

    def test_clean_r_code(self):
        """Test detection on clean R code."""
        code = """
        #' Calculate Mean
        #' @param values Numeric vector
        #' @return The mean
        calculate_mean <- function(values) {
          total <- sum(values)
          return(total / length(values))
        }
        
        customer_data <- read.csv("data.csv")
        """
        
        fpath = Path(self.test_dir.name) / "clean.R"
        fpath.write_text(code)
        
        result = self.run_r_script(fpath)
        self.assertEqual(result.returncode, 0)
        self.assertIn("Low slop", result.stdout)
        self.assertNotIn("GENERIC VARIABLE NAMES", result.stdout)

    def test_generic_variables(self):
        """Test detection of generic variable names."""
        code = """
        df <- read.csv("data.csv")
        data <- df
        temp <- 1
        result <- 2
        """
        
        fpath = Path(self.test_dir.name) / "vars.R"
        fpath.write_text(code)
        
        result = self.run_r_script(fpath)
        self.assertIn("GENERIC VARIABLE NAMES", result.stdout)
        self.assertIn("'df'", result.stdout)
        self.assertIn("'data'", result.stdout)
        self.assertIn("'temp'", result.stdout)

    def test_generic_functions(self):
        """Test detection of generic function names."""
        code = """
        process_data <- function(x) { x }
        do_thing <- function(y) { y }
        my_helper <- function(z) { z }
        """
        
        fpath = Path(self.test_dir.name) / "funcs.R"
        fpath.write_text(code)
        
        result = self.run_r_script(fpath)
        self.assertIn("GENERIC FUNCTION NAMES", result.stdout)
        self.assertIn("'process_data'", result.stdout)
        self.assertIn("'do_thing'", result.stdout)

    def test_obvious_comments(self):
        """Test detection of obvious comments."""
        code = """
        # Load the library
        library(dplyr)
        
        # Read the data
        d <- read.csv("file")
        
        # Filter the data
        f <- d[d$x > 0,]
        """
        
        fpath = Path(self.test_dir.name) / "comments.R"
        fpath.write_text(code)
        
        result = self.run_r_script(fpath)
        self.assertIn("OBVIOUS COMMENTS", result.stdout)

    def test_single_pipes(self):
        """Test detection of unnecessary single pipes."""
        code = """
        library(dplyr)
        x <- 1:10
        y <- x %>% mean() # Single pipe
        
        # Good chain
        z <- x %>% 
          filter() %>%
          select()
        """
        
        fpath = Path(self.test_dir.name) / "pipes.R"
        fpath.write_text(code)
        
        result = self.run_r_script(fpath)
        self.assertIn("UNNECESSARY SINGLE PIPES", result.stdout)

if __name__ == '__main__':
    unittest.main()
