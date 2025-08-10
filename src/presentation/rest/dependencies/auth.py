"""
Authorization Dependencies
"""
import os


def get_current_user():
    """Get current user"""
    os.environ["CURRENT_USER"] = "SYSTEM"
