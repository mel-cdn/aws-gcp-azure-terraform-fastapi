from application.services.inventory_service import InventoryService
from infrastructure.database.cloud_storage import get_cloud_storage_session
from infrastructure.repositories.cloud_storage_product_repository import (
    CloudStoragePaperProductRepository,
)

# Repository dependencies

# Service dependencies


def get_cloud_storage_product_repository():
    """Get Cloud Storage product repository"""
    return CloudStoragePaperProductRepository(cloud_storage_session=get_cloud_storage_session())


def get_product_repository():
    """Get product repository"""
    return get_cloud_storage_product_repository()


def get_inventory_service():
    """Get inventory service"""
    product_repo = get_cloud_storage_product_repository()
    return InventoryService(product_repo=product_repo)
