from typing import List
from pathlib import Path

HOU_EDITIONS = ["core", "fx", "indie", "apprentice"]
"""All possible Houdini editions."""


def get_binary_name_for_edition(edition: str) -> str:
    """Get the appropriate binary name for the given Houdini edition.

    Args:
        edition (str): Hooudini edition

    Returns:
        str: Binary name
    """

    if edition in ["core", "fx"]:
        return f"houdini{edition}"
    else:
        return "houdini"


def get_houdini_edition_args(edition: str) -> List[str]:
    """Get the appropriate arguments to launch a given Houdini edition.

    Args:
        edition (str): Houdini edition

    Returns:
        List[str]: Arguments
    """

    if edition in ["indie", "apprentice"]:
        return [f"-{edition}"]
    else:
        return []


def noncomercialize_path(input_path: Path) -> Path:
    # Figure out the noncomercial version of the path
    path_suffix = input_path.suffix
    noncomercial_path = input_path.with_suffix(f".{path_suffix}nc")

    # If the NC version exists, use it
    if noncomercial_path.exists():
        return noncomercial_path

    # All other cases, use the input directly
    return input_path
