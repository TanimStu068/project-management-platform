from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base
from sqlalchemy.exc import SQLAlchemyError
from core.config import settings

DATABASE_URL = settings.DATABASE_URL


# ENGINE CONFIGURATION
engine = create_engine(
    DATABASE_URL,
    pool_size=10,          
    max_overflow=20,     
    pool_pre_ping=True,    
    echo=True         
)

# SESSION FACTORY
SessionLocal = sessionmaker(
    autocommit=False,
    autoflush=False,
    bind=engine
)

# BASE CLASS FOR MODELS
Base = declarative_base()


# DEPENDENCY FOR FASTAPI
def get_db():
    db = SessionLocal()
    try:
        yield db
    except SQLAlchemyError as e:
        db.rollback()
        raise e
    finally:
        db.close()

# OPTIONAL: AUTO CREATE TABLES (DEV ONLY)
def init_db():
    from db import models  # Import models to register them
    Base.metadata.create_all(bind=engine)
