"""
Database connection management
"""
from typing import List

from utils.logger import logger

FAKE_DB = {}


class CloudStorageDatabase:
    """Cloud Storage as Database connection"""

    def __init__(self):
        """Let's fake it for now :)"""
        self.database = "FAKE_DB"

    def fetch(self, key: str) -> List[dict]:
        logger.info(f"Retrieving {key} items from {self.database}...")
        return FAKE_DB.get(key, [])

    def create(self, key: str, data: dict) -> None:
        logger.info(f"Inserting {key} item to {self.database}...")
        items = self.fetch(key=key)
        items.append(data)
        FAKE_DB[key] = items


def get_cloud_storage_session() -> CloudStorageDatabase:
    return CloudStorageDatabase()
