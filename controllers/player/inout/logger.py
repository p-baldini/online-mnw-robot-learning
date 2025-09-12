import logging
import os
import sys

from .loader import configs

LOGGER_NAME: str = "online-mnw-robot-learning"
LOG_FORMAT: str = "[%(asctime)s %(levelname)s]\t %(message)s"
LOG_PATH: str = os.path.realpath(configs["output"]["path"])
LOG_FILE: str = configs["output"]["log_file"]

def new_log(path: str) -> logging.Handler:
    # calculate the log file position
    file_path = os.path.join(path, LOG_FILE)

    # ensure that the path exists
    os.makedirs(path, exist_ok=True)

    # define the file handler
    handler = logging.FileHandler(file_path)
    handler.setFormatter(logging.Formatter(LOG_FORMAT))
    return handler


# obtain the logger instance
logger = logging.getLogger(LOGGER_NAME)

# set the output path of the logger
logger.addHandler(new_log(LOG_PATH))

# define the shell handler
handler = logging.StreamHandler(sys.stdout)
handler.setFormatter(logging.Formatter(LOG_FORMAT))
logger.addHandler(handler)

# display all the logs
logger.setLevel(logging.DEBUG)

# export only the logger instance
__all__ = "logger", "new_log",
