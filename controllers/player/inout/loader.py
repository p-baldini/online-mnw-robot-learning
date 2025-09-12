import json
import os

from typing import Any, Dict

# open configuration file
with open(os.path.realpath("../../config.json")) as file:
    configs: Dict[str, Any] = json.load(file)

with open(os.path.realpath("../../tsetlin.json")) as file:
    tsetlin_configs = json.load(file)

__all__ = "configs", "tsetlin_configs"
