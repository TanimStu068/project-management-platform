from pydantic_settings import BaseSettings
from functools import lru_cache


class Settings(BaseSettings):
    # DATABASE
    DATABASE_URL: str

    # JWT SETTINGS
    SECRET_KEY: str
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60

    # APP SETTINGS
    PROJECT_NAME: str = "Task Forge API"
    API_V1_STR: str = "/api/v1"

    class Config:
        env_file = ".env"
        case_sensitive = True


# CACHED SETTINGS INSTANCE

@lru_cache()
def get_settings():
    return Settings()


# Create global settings object
settings = get_settings()
