from typing import List

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
