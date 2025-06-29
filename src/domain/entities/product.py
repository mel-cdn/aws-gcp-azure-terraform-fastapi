"""
Product domain model
"""

from pydantic import ConfigDict

from domain.entities.constants.product import ProductType, Unit
from domain.entities.core import CoreModel


class Product(CoreModel):
    model_config = ConfigDict(extra="forbid")

    type: ProductType
    name: str
    description: str
    price: float
    quantity: int
    brand: str


class PaperProduct(Product):
    model_config = ConfigDict(extra="forbid")

    length: float
    width: float
    thickness: float
    unit: Unit


PRODUCT_MAP = {
    ProductType.PAPER: PaperProduct,
}
