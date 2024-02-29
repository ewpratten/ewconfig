from pathlib import Path


def prepend_if_relative(prefix: Path, possibly_abs_path: Path) -> Path:
    
    # If absolute, no prepend needed
    if possibly_abs_path.is_absolute():
        return possibly_abs_path
    
    # Otherwise prepend
    return prefix / possibly_abs_path
