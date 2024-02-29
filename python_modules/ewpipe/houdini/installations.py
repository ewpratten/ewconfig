import logging
import platform
import argparse
import sys
from pathlib import Path
from typing import Optional

logger = logging.getLogger(__name__)


def get_default_houdini_installation_base_path() -> Path:
    """Get the default Houdini installation base path.

    Returns:
        Path: Default Houdini installation base path
    """
    if platform.system() == "Linux":
        return Path("/opt")
    elif platform.system() == "Windows":
        return Path("C:/Program Files/Side Effects Software")
    else:
        raise RuntimeError(f"Unsupported platform: {platform.system()}")


def find_latest_houdini_installation(base_path: Path) -> Optional[Path]:
    """Find the latest Houdini installation in the given base path.

    Args:
        base_path (Path): Base path to look for Houdini installations in.

    Returns:
        Optional[Path]: Houdini installation path if found
    """
    logger.debug(f"Looking for the latest Houdini installation in: {base_path}")

    # Look for possible houdini installations
    if platform.system() == "Linux":
        possible_installations = sorted(base_path.glob("hfs*"))
    elif platform.system() == "Windows":
        possible_installations = sorted(base_path.glob("Houdini *"))
    else:
        raise RuntimeError(f"Unsupported platform: {platform.system()}")
    logger.debug(
        f"Search found the following Houdini installations: {[str(i) for i in possible_installations]}"
    )

    # Remove `Houdini Server` if it exists
    possible_installations = [
        installation
        for installation in possible_installations
        if "Server" not in installation.name
    ]

    # If there are no installations, return None
    if not possible_installations:
        return None

    # Otherwise, return the latest installation
    latest_installation = possible_installations[-1]
    logger.debug(f"Latest Houdini installation: {latest_installation}")
    return latest_installation


def get_houdini_installation_path(
    version: Optional[str] = None,
    base_path: Optional[Path] = None,
    not_exists_ok: bool = False,
) -> Optional[Path]:
    """Get the path to the Houdini installation for the given version.

    Args:
        version (Optional[str], optional): Houdini version to target. Defaults to None.
        not_exists_ok (bool, optional): If true, allows bad paths to be returned. Defaults to False.

    Raises:
        RuntimeError: Thrown if the platform is not supported.

    Returns:
        Optional[Path]: Path to the Houdini installation if found
    """

    logger.debug(f"Finding Houdini installation for version: {version}")

    # Get the default installation base path
    if not base_path:
        base_path = get_default_houdini_installation_base_path()
    logger.debug(f"Searching for Houdini installations in: {base_path}")

    # If we don't have a version, find the latest installation
    if not version:
        logger.debug("No version specified, finding latest installation")
        return find_latest_houdini_installation(base_path)

    # Otherwise, find the installation for the given version
    if platform.system() == "Linux":
        installation_path = base_path / f"hfs{version}"
    elif platform.system() == "Windows":
        installation_path = base_path / f"Houdini {version}"
    else:
        raise RuntimeError(f"Unsupported platform: {platform.system()}")

    # If the installation path does not exist, return None
    if (not installation_path.exists()) and not not_exists_ok:
        logger.debug(f"Installation path does not exist: {installation_path}")
        return None

    # Otherwise, return the installation path
    logger.debug(f"Found installation path: {installation_path}")
    return installation_path


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--version", "-v", help="Houdini version", type=str)
    ap.add_argument("--base-path", "-b", help="Houdini base path", type=str)
    ap.add_argument("--not-exists-ok", help="Allow bad paths", action="store_true")
    args = ap.parse_args()

    result = get_houdini_installation_path(
            version=args.version,
            base_path=Path(args.base_path) if args.base_path else None,
            not_exists_ok=args.not_exists_ok,
        )
    if not result:
        print("Could not find Houdini", file=sys.stderr)
        sys.exit(1)
    
    print(result)
    sys.exit(0)
