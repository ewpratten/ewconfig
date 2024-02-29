import requests
import logging
from typing import Any, Dict, List, Optional

logger = logging.getLogger(__name__)


def get_all_trello_cards(
    board_id: str, api_key: str, api_token: str
) -> List[Dict[str, Any]]:
    # Get a list of cards on the board
    logger.debug(f"Getting all cards on board: {board_id}")
    response = requests.get(
        f"https://api.trello.com/1/boards/{board_id}/cards",
        params={
            "key": api_key,
            "token": api_token,
        },
    )
    response.raise_for_status()
    cards = response.json()
    logger.debug(f"Found {len(cards)} cards on board: {board_id}")
    return cards


def create_card(
    list_id: str,
    name: str,
    api_key: str,
    api_token: str,
    description: Optional[str] = None,
    label_ids: Optional[List[str]] = None,
    position: str = "top",
) -> str:
    logger.debug(f"Creating card: {name}")

    # Build out params
    params = {
        "idList": list_id,
        "name": name,
        "key": api_key,
        "token": api_token,
        "pos": position,
    }
    if description:
        params["desc"] = description
    if label_ids:
        params["idLabels"] = ",".join(label_ids)

    # Make a new card
    response = requests.post(
        "https://api.trello.com/1/cards",
        params=params,
    )
    response.raise_for_status()

    # Get the new card's id
    card_id = response.json()["id"]

    logger.debug(f"Created card: {card_id}")
    return card_id


def add_attachment(
    card_id: str, api_key: str, api_token: str, url: Optional[str] = None
) -> None:
    logger.debug(f"Adding attachment to card: {card_id}")
    params = {
        "key": api_key,
        "token": api_token,
    }
    if url:
        params["url"] = url

    response = requests.post(
        f"https://api.trello.com/1/cards/{card_id}/attachments",
        params=params,
    )
    response.raise_for_status()
    logger.debug(f"Added attachment to card: {card_id}")
