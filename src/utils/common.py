from datetime import datetime


class CommonUtil:
    @staticmethod
    def get_current_date() -> datetime:
        """Can update here if what timezone"""
        return datetime.now()
