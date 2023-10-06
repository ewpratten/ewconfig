#! /usr/bin/env python3

# fmt:off
import sys
import os
from pathlib import Path
sys.path.append((Path(os.environ["EWCONFIG_ROOT"]) / "python_modules").as_posix())
# fmt:on

import argparse
import subprocess
import logging
from ewpipe.common.dirs import HOUDINI_PROJECTS_DIR
from ewpipe.houdini.editions import (
    get_binary_name_for_edition,
    get_houdini_edition_args,
    HOU_EDITIONS,
)
from ewpipe.houdini.installations import get_houdini_installation_path
from ewpipe.common.logging import configure_logging
from ewpipe.common.env import diff_from_current_env

logger = logging.getLogger(__name__)


def main() -> int:
    # Handle program arguments
    ap = argparse.ArgumentParser(
        prog="houdini-tool",
        description="Evan's tool for launching and managing Houdini",
    )
    ap.add_argument(
        "--type",
        "-t",
        help="Houdini type",
        choices=HOU_EDITIONS,
        default="apprentice",
    )
    ap.add_argument(
        "--project",
        "-p",
        help="Name of the project to open or create. May also be a direct path",
        type=str,
        required=True,
    )
    ap.add_argument(
        "--hou-version",
        help="Houdini version to use. Defaults to latest",
        type=str,
        default=None,
    )
    ap.add_argument(
        "--no-project-env", help="Disables setting $HIP and $JOB", action="store_true"
    )
    ap.add_argument("--verbose", "-v", help="Verbose output", action="store_true")
    args = ap.parse_args()

    # Set up verbose logging if requested
    configure_logging(verbose=args.verbose)

    # Get the houdini path
    hou_path = get_houdini_installation_path(version=args.hou_version)
    if not hou_path:
        logger.error("Could not find Houdini installation")
        return 1
    logger.info(f"Selected Houdini {hou_path.name[3:]} from {hou_path}")

    # Determine the project path
    project_path = Path(args.project)
    if not project_path.is_absolute():
        # This is a project name, not a path
        project_path = HOUDINI_PROJECTS_DIR / project_path
    logger.info(f"Opening project from: {project_path}")

    # If the directory does not exist, create
    project_path.mkdir(parents=True, exist_ok=True)

    # If allowed, set up env vars
    environment_vars = os.environ.copy()
    environment_vars["HOUDINI_SCRIPT_DEBUG"] = "1"
    environment_vars["HOUDINI_SPLASH_MESSAGE"] = "Loading with custom scripts"
    environment_vars["HOUDINI_CONSOLE_PYTHON_PANEL_ERROR"] = "1"
    if not args.no_project_env:
        # environment_vars["HIP"] = str(project_path)
        environment_vars["JOB"] = str(project_path)
        environment_vars["HOUDINI_HIP_DEFAULT_NAME"] = f"{project_path.name}.hip"

    # Figure out what has changed in the environment and print the changes
    env_changes = diff_from_current_env(environment_vars)
    if env_changes:
        logger.info("Environment changes:")
        for key, value in env_changes.items():
            logger.info(f"  ${key}: {value}")

    # Launch houdini
    cmd = [
        str(hou_path / "bin" / get_binary_name_for_edition(args.type)),
        "-foreground",
    ] + get_houdini_edition_args(args.type)
    if (project_path / f"{project_path.name}.hip").exists():
        cmd.append(f"{project_path}/{project_path.name}.hip")
    if (project_path / f"{project_path.name}.hipnc").exists():
        cmd.append(f"{project_path}/{project_path.name}.hipnc")
    logger.info(f"Running: {' '.join(cmd)}")
    status = subprocess.run(cmd, env=environment_vars, cwd=project_path).returncode
    return status


if __name__ == "__main__":
    sys.exit(main())
