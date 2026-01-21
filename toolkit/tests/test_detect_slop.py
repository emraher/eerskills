import unittest
import sys
from pathlib import Path
import tempfile
import os

# Add submodule path to find detect_slop
# Path from here: ../../external/cc-polymath/skills/anti-slop/scripts
PROJECT_ROOT = Path(__file__).resolve().parents[2]
SUBMODULE_PATH = PROJECT_ROOT / 'external' / 'cc-polymath' / 'skills' / 'anti-slop' / 'scripts'

sys.path.append(str(SUBMODULE_PATH))

try:
    from detect_slop import SlopDetector
except ImportError:
    raise ImportError(f"Could not import detect_slop from {SUBMODULE_PATH}. Ensure submodules are initialized.")

class TestSlopDetector(unittest.TestCase):
    def setUp(self):
        # Create a temporary file
        self.test_dir = tempfile.TemporaryDirectory()
        self.test_file = Path(self.test_dir.name) / "test_doc.md"

    def tearDown(self):
        self.test_dir.cleanup()

    def create_test_file(self, content):
        with open(self.test_file, 'w') as f:
            f.write(content)
        return str(self.test_file)

    def test_clean_text(self):
        """Test text with no slop."""
        content = """
        # Analysis
        
        We analyzed the data and found three trends.
        The system handles 100 requests per second.
        """
        path = self.create_test_file(content)
        detector = SlopDetector(path)
        results = detector.analyze()
        
        self.assertLess(results['score'], 20)
        self.assertEqual(len(results['findings']['high_risk']), 0)

    def test_high_risk_phrases(self):
        """Test detection of high risk phrases."""
        content = """
        In this document, we will delve into the complexities of the system.
        It is important to note that we must navigate the complexities.
        In today's fast-paced world, this is crucial.
        """
        path = self.create_test_file(content)
        detector = SlopDetector(path)
        results = detector.analyze()
        
        self.assertGreater(results['score'], 50)
        
        matches = [f['match'] for f in results['findings']['high_risk']]
        self.assertTrue(any("delve into" in m for m in matches))
        self.assertTrue(any("fast-paced world" in m for m in matches))

    def test_buzzwords(self):
        """Test detection of buzzwords."""
        content = """
        We leverage a holistic approach to empower users.
        This paradigm shift will create a synergistic effect.
        """
        path = self.create_test_file(content)
        detector = SlopDetector(path)
        results = detector.analyze()
        
        matches = [f['match'] for f in results['findings']['buzzwords']]
        self.assertIn("leverage", matches)
        self.assertIn("holistic approach", matches)
        self.assertIn("synergistic", matches)

    def test_meta_commentary(self):
        """Test detection of meta-commentary."""
        content = """
        In this article, we will explore the API.
        Let's take a closer look at the function.
        """
        path = self.create_test_file(content)
        detector = SlopDetector(path)
        results = detector.analyze()
        
        matches = [f['match'] for f in results['findings']['meta_commentary']]
        self.assertTrue(len(matches) >= 2)

if __name__ == '__main__':
    unittest.main()
