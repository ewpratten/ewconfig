import os
from typing import Dict


def diff_environments(env_1: Dict[str, str], env_2: Dict[str, str]) -> Dict[str, str]:
    """Diff two environments.

    Args:
        env_1 (Dict[str,str]): First environment
        env_2 (Dict[str,str]): Second environment

    Returns:
        Dict[str,str]: Difference between the two environments
    """
    return {
        key: value
        for key, value in env_1.items()
        if key not in env_2 or env_2[key] != value
    }


def diff_from_current_env(new_env: Dict[str, str]) -> Dict[str, str]:
    """Diff the current environment from the given environment.

    Args:
        new_env (Dict[str, str]): New environment

    Returns:
        Dict[str, str]: Difference between the current environment and the given environment
    """
    return diff_environments(os.environ, new_env)  # type: ignore
