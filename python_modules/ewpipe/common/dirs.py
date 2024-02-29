from pathlib import Path

DCC_DATA_BASE_DIR = Path.home() / "Videos" / "DCC"
"""The base directory for storing data across DCCs"""

HOUDINI_BASE_DIR = DCC_DATA_BASE_DIR / "Houdini"
"""The base directory for storing Houdini data"""

HOUDINI_PROJECTS_DIR = HOUDINI_BASE_DIR / "Projects"
"""The base directory for storing Houdini projects"""

BLENDER_BASE_DIR = DCC_DATA_BASE_DIR / "Blender"
"""The base directory for storing Blender data"""
