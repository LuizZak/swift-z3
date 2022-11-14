from typing import Any
from utils.cli.console_color import ConsoleColor


def print_stage_name(*text: Any):
    print(f"{ConsoleColor.YELLOW('•')}", *text)
