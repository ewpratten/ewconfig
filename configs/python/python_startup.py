"""Python Startup file. Used to customize the Python REPL"""
import sys
import os

# Global stuff
IS_IN_TINKER_MODE = bool(os.environ.get("PYTHON_TINKER_MODE"))
COLOR_ALLOWED = not bool(os.environ.get("NO_COLOR"))


def colored_string(text: str, color: str) -> str:
    if COLOR_ALLOWED:
        return "\033[" + color + "m" + text + "\033[0m"
    else:
        return text


# Configure the prompt
class Prompt:
    def __init__(self):
        self.prompt = colored_string(">>> ", "36")

    def __str__(self):
        return self.prompt


class MultiLinePrompt:
    def __str__(self):
        return colored_string("... ", "33")
        # return "    "


# Hook up the prompts
sys.ps1 = Prompt()
sys.ps2 = MultiLinePrompt()

# "Tinker mode" - automatically import common things
if IS_IN_TINKER_MODE:
    print(
        colored_string(
            "Running in tinker mode. Additional modules are available.", "33"
        )
    )

    # Basics
    import time
    import json
    from pathlib import Path
    from dataclasses import dataclass
    from typing import (
        List,
        Dict,
        Tuple,
        Set,
        Optional,
        Union,
        Any,
        Callable,
        Iterable,
        Generator,
    ) 
    from pprint import pprint
    from datetime import datetime
    from textwrap import dedent
    from base64 import b64encode, b64decode

    # Math stuff
    try:
        import numpy as np

        np.set_printoptions(suppress=True)
        _vec = lambda *fields: np.array([*fields])
        pi = np.pi
    except ImportError:
        pass
    try:
        from pyquaternion import Quaternion
    except ImportError:
        pass
    try:
        import matplotlib.pyplot as plt
    except ImportError:
        pass


# If we aren't in tinker mode, un-import sys and os
if not IS_IN_TINKER_MODE:
    del sys
    del os

# Clean up other stuff
del IS_IN_TINKER_MODE
del COLOR_ALLOWED
del colored_string
del Prompt
del MultiLinePrompt