"""
Cloud Storage implementation of Product repository
"""
from typing import List, Optional

from domain.entities.constants.product import ProductType
from domain.entities.product import PaperProduct, Product
from domain.repositories.product_repository import ProductRepository
from infrastructure.database.cloud_storage import CloudStorageDatabase


class CloudStoragePaperProductRepository(ProductRepository):
    """Cloud Storage implementation of Paper Product repository"""

    def __init__(self, cloud_storage_session: CloudStorageDatabase):
        self.session = cloud_storage_session

    def create(self, product: PaperProduct) -> PaperProduct:
        """Create a new product"""
        data = product.model_dump(exclude_unset=True)
        self.session.create(key="PRODUCT", data=data)
        return PaperProduct(**data)

    def get_by_id(self, product_id: str) -> Optional[PaperProduct]:
        """Get product by ID"""

    def get_all(self, skip: int = 0, limit: int = 100) -> List[PaperProduct]:
        """Get all paper products with pagination"""
        return [PaperProduct(**data) for data in self.session.fetch(key="PRODUCT")]

    def update(self, product: Product) -> Product:
        """Update product"""

    def delete(self, product_id: str) -> bool:
        """Delete product"""

    def get_by_type(self, product_type: ProductType) -> List[PaperProduct]:
        """Get products by type"""
        return [PaperProduct(**data) for data in self.session.fetch(key="PRODUCT") if data["type"] == product_type]
