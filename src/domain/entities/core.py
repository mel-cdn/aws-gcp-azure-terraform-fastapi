"""
Core domain model
"""

from datetime import datetime

from pydantic import BaseModel, ConfigDict


class CoreModel(BaseModel):
    model_config = ConfigDict(str_strip_whitespace=True)

    id: str
    is_active: bool
    created_at: datetime
    updated_at: datetime
    created_by: str
    updated_by: str
