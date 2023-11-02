from dataclasses import dataclass
from typing import Dict


@dataclass
class TrelloBoardInfo:
    id: str
    lists: Dict[str, str]
    tags: Dict[str, str]


PERSONAL_TASKS_BOARD = TrelloBoardInfo(
    id="tw3Cn3L6",
    lists={"To Do": "6348a3ce5208f505b61d29bf"},
    tags={
        "GURU": "64e03ac77d27032282436d28",
        "Github: Issue": "64eb5d72fb694cd8f0ba7a8d",
        "Github: Pull Request": "652d4b775f5c59a8e6308216",
    },
)
