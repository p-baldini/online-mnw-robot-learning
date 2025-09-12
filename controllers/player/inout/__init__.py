import os

from .loader import configs
from pathlib import Path

PATH = os.path.realpath(configs["output"]["path"])

# create the directory and all the possible parents
Path(PATH).mkdir(parents=True, exist_ok=True)
