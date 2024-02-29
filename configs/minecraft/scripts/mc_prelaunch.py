#! /usr/bin/env python
import argparse
import sys
import os
import shutil
from pathlib import Path

MINECRAFT_DIR = Path(os.environ["INST_MC_DIR"])
WAYPOINT_BASE_DIR = MINECRAFT_DIR / "XaeroWaypoints"
GLOBAL_WAYPOINT_DIR = (
    Path(os.path.expanduser("~")) / ".config" / "minecraft" / "XaeroWaypoints"
)


def main() -> int:
    # Handle program arguments
    ap = argparse.ArgumentParser(description="Pre-launch tasks for Minecraft")
    args = ap.parse_args()
    print("[EWCONFIG] Executing pre-launch tasks for Minecraft")
    print(f"[EWCONFIG] Minecraft directory: {MINECRAFT_DIR}")

    # Copy the global waypoint dir on top of the base waypoint dir
    print(f"[EWCONFIG] Copying {GLOBAL_WAYPOINT_DIR} to {WAYPOINT_BASE_DIR}")
    WAYPOINT_BASE_DIR.mkdir(parents=True, exist_ok=True)
    shutil.copytree(GLOBAL_WAYPOINT_DIR, WAYPOINT_BASE_DIR, dirs_exist_ok=True)

    return 0


if __name__ == "__main__":
    sys.exit(main())
