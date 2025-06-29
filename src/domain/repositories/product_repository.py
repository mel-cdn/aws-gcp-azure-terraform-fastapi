"""
Product repository interface
"""
from abc import ABC, abstractmethod
from typing import List, Optional

from domain.entities.constants.product import ProductType
from domain.entities.product import Product


class ProductRepository(ABC):
    """Abstract repository for Paper Products"""

    @abstractmethod
    def create(self, product: Product) -> Product:
        """Create a new product"""
        pass

    @abstractmethod
    def get_by_id(self, product_id: str) -> Optional[Product]:
        """Get product by ID"""
        pass

    @abstractmethod
    def get_all(self, skip: int = 0, limit: int = 100) -> List[Product]:
        """Get all products with pagination"""
        pass

    @abstractmethod
    def update(self, product: Product) -> Product:
        """Update product"""
        pass

    @abstractmethod
    def delete(self, product_id: str) -> bool:
        """Delete product"""
        pass

    @abstractmethod
    def get_by_type(self, product_type: ProductType) -> List[Product]:
        """Get products by type"""
        pass
