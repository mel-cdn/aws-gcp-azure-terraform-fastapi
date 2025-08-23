"""
FastAPI application factory
"""
import os

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from presentation.rest.routers import products


def create_app(version: str, environment: str) -> FastAPI:
    """Create and configure FastAPI application"""

    inventory_app = FastAPI(
        title="Dunder Mifflin Inventory Service",
        description="A Domain-Driven Design API for managing paper products inventory",
        version=f"{version} - {environment.upper()}",
        docs_url="/swagger",
    )

    # Add CORS middleware
    inventory_app.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    @inventory_app.get("/", include_in_schema=False)
    async def root():
        return {
            "message": f"Hey there! Welcome to {inventory_app.title}!",
            "version": version,
            "docs": "/swagger",
            "redoc": "/redoc",
            "environment": environment,
        }

    return inventory_app


app = create_app(version="0.0.5", environment=os.environ["ENVIRONMENT"])
# Include routers
app.include_router(products.router, prefix="/products", tags=["Products"])
