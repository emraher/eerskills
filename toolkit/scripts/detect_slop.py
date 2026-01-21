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
    # Use importlib to avoid importing self (circular import) since filenames match
    import importlib.util
    spec = importlib.util.spec_from_file_location("detect_slop_submodule", submodule_path / "detect_slop.py")
    if spec is None:
        raise ImportError("Could not load spec for detect_slop.py")
    module = importlib.util.module_from_spec(spec)
    sys.modules["detect_slop_submodule"] = module
    spec.loader.exec_module(module)
    main = module.main
except ImportError as e:
    print(f"Error: Could not import detect_slop from submodule: {e}")
    sys.exit(1)

if __name__ == '__main__':
    main()