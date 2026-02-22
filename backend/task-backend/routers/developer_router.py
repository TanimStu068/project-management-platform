from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from db.models import User, UserRole
from core.dependencies import get_db
from schemas.user_schema import BaseModel

router = APIRouter(prefix="/developers", tags=["Developers"])

class DeveloperOut(BaseModel):
    id: int
    email: str

    class Config:
        from_attributes = True

@router.get("/", response_model=list[DeveloperOut])
def get_all_developers(db: Session = Depends(get_db)):
    # Use string "DEVELOPER" if your DB stores enum names in uppercase
    developers = db.query(User).filter(User.role == "DEVELOPER").all()
    return developers