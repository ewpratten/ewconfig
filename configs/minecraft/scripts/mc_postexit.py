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
    ap = argparse.ArgumentParser(description="Post-exit tasks for Minecraft")
    args = ap.parse_args()
    print("[EWCONFIG] Executing post-exit tasks for Minecraft")
    print(f"[EWCONFIG] Minecraft directory: {MINECRAFT_DIR}")

    # If the waypoint base dir doesn't exist, we don't need to do anything
    if not WAYPOINT_BASE_DIR.exists():
        print("[EWCONFIG] No waypoints to sync")
        return 0

    # Find all multiplayer waypoint dirs
    multiplayer_waypoints = [
        directory
        for directory in WAYPOINT_BASE_DIR.iterdir()
        if directory.is_dir() and directory.name.startswith("Multiplayer")
    ]
    print(
        f"[EWCONFIG] Found {len(multiplayer_waypoints)} multiplayer waypoint directories"
    )

    # Copy the contents of each multiplayer waypoint dir to the global storage
    for waypoint_dir in multiplayer_waypoints:
        dest_dir = GLOBAL_WAYPOINT_DIR / waypoint_dir.name
        print(f"[EWCONFIG] Copying {waypoint_dir} to {dest_dir}")

        # Use shutil to copy the directory
        dest_dir.mkdir(parents=True, exist_ok=True)
        shutil.copytree(waypoint_dir, dest_dir, dirs_exist_ok=True)

    return 0


if __name__ == "__main__":
    sys.exit(main())
