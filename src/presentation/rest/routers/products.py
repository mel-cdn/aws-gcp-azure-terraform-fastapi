"""
Product API routers
"""
from typing import Optional, Union

from fastapi import APIRouter, Depends, HTTPException, Query
from pydantic import BaseModel, ConfigDict

from application.services.inventory_service import InventoryService
from domain.entities.constants.product import ProductType, Unit
from domain.repositories.product_repository import ProductRepository
from presentation.rest.dependencies.auth import get_current_user
from presentation.rest.dependencies.services import (
    get_inventory_service,
    get_product_repository,
)

router = APIRouter()


class PaperProductCreate(BaseModel):
    model_config = ConfigDict(extra="ignore", str_strip_whitespace=True)

    type: ProductType
    name: str
    description: str
    price: float
    quantity: int
    brand: str
    length: float
    width: float
    thickness: float
    unit: Unit


@router.post("/", status_code=201)
async def create_product(
    product: Union[PaperProductCreate],
    inventory_service: InventoryService = Depends(get_inventory_service),
    _=Depends(get_current_user),
):
    """Create a new product"""
    try:
        return inventory_service.create_product(product=product.model_dump(exclude_none=True, exclude_unset=True))
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))


@router.get("/")
async def get_products(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=1000),
    product_type: Optional[ProductType] = Query(None),
    product_repo: ProductRepository = Depends(get_product_repository),
    _=Depends(get_current_user),
):
    """Get all products with optional filtering"""
    try:
        if product_type:
            products = product_repo.get_by_type(product_type)
        else:
            products = product_repo.get_all(skip=skip, limit=limit)

        return [product.model_dump() for product in products]
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
