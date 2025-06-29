import logging
import os
from sys import stdout

# Configure logging
log_format = logging.Formatter("[%(levelname)-8s] %(message)s")
handler = logging.StreamHandler(stdout)
handler.setFormatter(log_format)

# Attach the handler to the root logger
logger = logging.getLogger()
logger.addHandler(handler)
logger.setLevel(os.environ.get("LOG_LEVEL", "INFO"))
