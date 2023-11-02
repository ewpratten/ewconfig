from ..secret_manager import get_semi_secret_string

TRELLO_API_KEY = "fba640a85f15c91e93e6b3f88e59489c"
"""Public api key to do things to personal Trello"""


def get_trello_api_token() -> str:
    return get_semi_secret_string("trello_api_token")
