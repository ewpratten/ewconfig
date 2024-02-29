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
from ewpipe.common.utils.path import prepend_if_relative
from ewpipe.houdini.editions import (
    get_binary_name_for_edition,
    get_houdini_edition_args,
    HOU_EDITIONS,
    noncomercialize_path,
)
from ewpipe.houdini.installations import get_houdini_installation_path
from ewpipe.common.logging import configure_logging

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
        "--sub-project",
        "--sp",
        help="Name of the sub-project to open",
        type=str,
        default=None,
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
    ap.add_argument("--cpu", help="Use CPU compute for OpenCL", action="store_true")
    ap.add_argument(
        "--dump-core", help="Forces Houdini to dump its core", action="store_true"
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
    project_path = prepend_if_relative(HOUDINI_PROJECTS_DIR, Path(args.project))
    project_save_file = project_path / (
        f"{args.sub_project}.hip" if args.sub_project else f"{project_path.name}.hip"
    )
    logger.info(f"Opening project from: {project_path}")

    # If the directory does not exist, create
    project_path.mkdir(parents=True, exist_ok=True)
    (project_path / "render").mkdir(parents=True, exist_ok=True)

    # If allowed, set up env vars
    hou_env_settings = {}
    hou_env_settings["HOUDINI_SCRIPT_DEBUG"] = "1"
    hou_env_settings["HOUDINI_SPLASH_MESSAGE"] = "Loading with custom scripts"
    hou_env_settings["HOUDINI_CONSOLE_PYTHON_PANEL_ERROR"] = "1"
    hou_env_settings["HOUDINI_PDG_NODE_DEBUG"] = "3"
    if args.cpu:
        hou_env_settings["HOUDINI_OCL_DEVICETYPE"] = "CPU"
        hou_env_settings["HOUDINI_USE_HFS_OCL"] = "1"
    if args.dump_core:
        hou_env_settings["HOUDINI_COREDUMP"] = "1"
    if not args.no_project_env:
        # environment_vars["HIP"] = str(project_path)
        hou_env_settings["JOB"] = str(project_path)
        hou_env_settings["HOUDINI_HIP_DEFAULT_NAME"] = project_save_file.name

    # Figure out what has changed in the environment and print the changes
    if hou_env_settings:
        logger.info("Environment changes:")
        for key, value in hou_env_settings.items():
            logger.info(f"  ${key}: {value}")

    # Combine the current environment with
    cmd_env = dict(os.environ)
    cmd_env.update(hou_env_settings)

    # Build command to launch houdini
    cmd = [
        str(hou_path / "bin" / get_binary_name_for_edition(args.type)),
        "-foreground",
    ] + get_houdini_edition_args(args.type)

    # If the expected project file exists already
    # (aka, user already saved in a previous session),
    # then conveniently open the project automatically
    proj_file = noncomercialize_path(project_save_file)
    if proj_file.exists():
        cmd.append(str(proj_file))

    # Run houdini
    logger.info(f"Running: {' '.join(cmd)}")
    status = subprocess.run(cmd, env=cmd_env, cwd=project_path).returncode
    return status


if __name__ == "__main__":
    sys.exit(main())
