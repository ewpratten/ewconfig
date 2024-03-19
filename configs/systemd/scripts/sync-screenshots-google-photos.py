#! /usr/bin/env python3
import argparse
import sys
import logging
import platform
import shutil
import glob
import datetime
import subprocess
from PIL import Image
from pathlib import Path

logger = logging.getLogger(__name__)

RCLONE_REMOTE_NAME = "google-photos"
HOSTNAME_MAP = {
    ("ewpratten-desktop"): {
        "name": "Desktop",
        "mode": "directory",
        "directory": "~/Pictures/Screenshots/",
    },
    ("ewpratten-laptop"): {
        "name": "Laptop",
        "mode": "directory",
        "directory": "~/Pictures/Screenshots/",
    },
    ("ewpratten-steamdeck"): {
        "name": "Steam Deck",
        "mode": "steamdeck",
    },
}


def main() -> int:
    # Handle program arguments
    ap = argparse.ArgumentParser()
    ap.add_argument(
        "-v", "--verbose", help="Enable verbose logging", action="store_true"
    )
    args = ap.parse_args()

    # Configure logging
    logging.basicConfig(
        level=logging.DEBUG if args.verbose else logging.INFO,
        format="%(levelname)s:	%(message)s",
    )

    # Get the hostname of this machine
    hostname = platform.node().lower().split(".")[0]

    # Try to figure out what we are runnning on
    if hostname not in HOSTNAME_MAP:
        logger.error(f"Unsupported host: {hostname}")
        return 1
    
    # If rclone is not installed, we can't continue
    if shutil.which("rclone") is None:
        logger.error("rclone is not installed")
        return 1
    
    # If the rclone remote is not configured, we can't continue
    try:
        subprocess.check_output(["rclone", "lsf", f"{RCLONE_REMOTE_NAME}:"], stderr=subprocess.STDOUT)
    except subprocess.CalledProcessError as e:
        logger.error(f"rclone remote not found: {RCLONE_REMOTE_NAME}")
        return 1

    # Get the name of the machine
    host_settings = HOSTNAME_MAP[hostname]
    friendly_name = host_settings["name"]
    album_name = f"{friendly_name} Screenshots"
    logger.info(f"Syncing screenshots from {friendly_name}")

    # If the mode is "directory", we will just use that directory
    if host_settings["mode"] == "directory":
        directory = host_settings["directory"]
        logger.info(f"Using directory: {directory}")

    # If the mode is "steamdeck", we will need to collect all the screenshots from the Steam Deck
    elif host_settings["mode"] == "steamdeck":

        # Find all screenshots on the Steam Deck
        glob_pattern = "/home/deck/.local/share/Steam/userdata/**/screenshots/*.jpg"
        screenshots = glob.glob(glob_pattern, recursive=True)
        logger.info(f"Found {len(screenshots)} screenshots on the Steam Deck")

        # Make a temporary directory to store the screenshots
        temp_dir = Path("/tmp/screenshot-bundle")
        if temp_dir.exists():
            shutil.rmtree(temp_dir)
        temp_dir.mkdir(parents=True, exist_ok=True)
        
        # Copy all the screenshots to the temporary directory
        for screenshot in screenshots:
            shutil.copy(screenshot, temp_dir / screenshot.name)
            
            # Ensure that the timestamps match
            creation_time = datetime.datetime.fromtimestamp(Path(screenshot).stat().st_ctime)
            modification_time = datetime.datetime.fromtimestamp(Path(screenshot).stat().st_mtime)
            earliest_time = min(creation_time, modification_time)
            subprocess.check_output(["touch", "-t", earliest_time.strftime("%Y%m%d%H%M.%S"), temp_dir / screenshot.name])
            
        # Set the directory to the temporary directory
        directory = temp_dir
        logger.info(f"Using directory: {directory}")
        
    else:
        logger.error(f"Unsupported mode: {host_settings['mode']}")
        return 1
    
    directory = Path(directory).expanduser()
    
    # Iterate over each screenshot and update its timestamp if needed
    for screenshot in directory.glob("*"):
        # Skip files that are not images
        if not screenshot.is_file():
            logger.warning(f"Skipping non-file: {screenshot}")
            continue
        if screenshot.suffix.lower() not in [".jpg", ".jpeg", ".png"]:
            logger.warning(f"Skipping non-image: {screenshot}")
            continue
        
        try:
            image = Image.open(screenshot)
        except Exception as e:
            logger.warning(f"Failed to read {screenshot}: {e}")
            raise e
        
        # If the image has an EXIF timestamp, skip
        exif = image.getexif()
        if not exif:
            logger.debug(f"Skipping {screenshot}: EXIF timestamp found")
            continue
        
        # Get the creation and modification times of the file
        creation_time = datetime.datetime.fromtimestamp(screenshot.stat().st_ctime)
        modification_time = datetime.datetime.fromtimestamp(screenshot.stat().st_mtime)
        
        # Find the earliest time
        earliest_time = min(creation_time, modification_time)
        logger.info(f"Updating {screenshot} to {earliest_time}")
        
        # Set the file's EXIF timestamp to the earliest time
        exif[36867] = earliest_time.strftime("%Y:%m:%d %H:%M:%S")
        logger.info(f"Setting EXIF timestamp to {earliest_time} for {screenshot}")
        
    
    # Use rclone to sync the screenshots to Google Photos
    try:
        subprocess.check_output(["rclone", "mkdir", f"{RCLONE_REMOTE_NAME}:album/{album_name}"])
        subprocess.check_output(
            [
                "rclone",
                "copy",
                str(directory),
                f"{RCLONE_REMOTE_NAME}:album/{album_name}",
                "--progress",
            ],
            stderr=subprocess.STDOUT,
        )
    except subprocess.CalledProcessError as e:
        logger.error(f"rclone failed: {e.output.decode()}")
        return 1
    

    return 0


if __name__ == "__main__":
    sys.exit(main())
