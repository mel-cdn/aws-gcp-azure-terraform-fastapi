"""
Inventory management service
"""
import os
import uuid

from domain.entities.product import PRODUCT_MAP
from domain.repositories.product_repository import ProductRepository
from utils.common import CommonUtil


class InventoryService:
    """Service for inventory management operations"""

    def __init__(
        self,
        product_repo: ProductRepository,
    ):
        self.product_repo = product_repo

    def create_product(
        self,
        product: dict,
    ) -> dict:
        """Create a new paper product"""
        current_date = CommonUtil.get_current_date()
        model = PRODUCT_MAP[product["type"]]
        new_product = model(
            **{
                **product,
                "id": str(uuid.uuid4()),
                "is_active": True,
                "created_at": current_date,
                "updated_at": current_date,
                "created_by": os.environ.get("CURRENT_USER"),
                "updated_by": os.environ.get("CURRENT_USER"),
            }
        )
        return self.product_repo.create(product=new_product).model_dump()
