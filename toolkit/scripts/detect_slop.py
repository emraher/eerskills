#!/usr/bin/env python3
"""
Wrapper for detect_slop.py from cc-polymath submodule.
"""
import sys
from pathlib import Path

# Add submodule path to sys.path
# Path from here: ../../external/cc-polymath/skills/anti-slop/scripts
submodule_path = Path(__file__).resolve().parents[2] / 'external' / 'cc-polymath' / 'skills' / 'anti-slop' / 'scripts'

if not submodule_path.exists():
    print(f"Error: Submodule scripts not found at {submodule_path}")
    print("Please run: git submodule update --init --recursive")
    sys.exit(1)

sys.path.append(str(submodule_path))

try:
    from detect_slop import main
except ImportError as e:
    print(f"Error: Could not import detect_slop from submodule: {e}")
    sys.exit(1)

if __name__ == '__main__':
    main()