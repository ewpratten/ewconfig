from dataclasses import dataclass, field, fields
from typing import Dict, Optional


@dataclass
class HoudiniEnvironment:
    script_debug: bool = field(default=True, metadata={"key": "HOUDINI_SCRIPT_DEBUG"})
    """If set, errors will be printed when loading dialog scripts and scripted operators."""

    show_py_panel_errors_in_console: bool = field(
        default=True, metadata={"key": "HOUDINI_CONSOLE_PYTHON_PANEL_ERROR"}
    )
    """Errors when starting python panels will also be sent to the console, instead of just displaying them within the panel."""

    pdg_node_debug_level: int = field(
        default=3, metadata={"key": "HOUDINI_PDG_NODE_DEBUG"}
    )
    """Determines if PDG should print out node status information during the cook. 
    
    1: Enable a status print out message each time a node finishes cooking
    2: 1 + node error messages
    3: Print node generation/cook status, errors and node warnings
    4: 3 + print a message for each node callback invocation
    """

    splash_message: Optional[str] = field(
        default=None, metadata={"key": "HOUDINI_SPLASH_MESSAGE"}
    )
    """Message shown on the splash screen"""

    def to_dict(self) -> Dict[str, str]:
        output: Dict[str, str] = {}
        for obj_field in fields(self):
            field_value = self.__dict__[obj_field.name]
            if field_value:
                output[obj_field.metadata["key"]] = str()
        return output
