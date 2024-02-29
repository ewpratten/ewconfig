import logging
from pathlib import Path
from typing import Optional

SEMI_SECRET_BASE_PATH = Path("~/.config/ewconfig/secrets/semi-secret").expanduser()

logger = logging.getLogger(__name__)

def get_semi_secret_string(name: str, namespace: Optional[str] = None) -> str:
    logger.debug(f"Attempting to load secret: {name} (ns: {namespace})")
    
    # Construct file path
    file = SEMI_SECRET_BASE_PATH 
    if namespace:
        file = file / namespace
    file = file / name
    
    # Make sure it exists
    if not file.exists():
        raise FileNotFoundError(f"Could not load secret from: {file}")

    # Read the value
    with open(file, "r") as f:
        return f.read().strip()
