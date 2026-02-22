from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session

from schemas.user_schema import UserCreate, UserLogin, UserOut
from services.auth_service import register_user, login_user
from core.dependencies import get_db

router = APIRouter(prefix="/auth", tags=["Auth"])


# REGISTER
@router.post("/register", response_model=UserOut, status_code=status.HTTP_201_CREATED)
def register(user: UserCreate, db: Session = Depends(get_db)):
    new_user = register_user(user, db)
    return new_user


# LOGIN
@router.post("/login")
def login(user: UserLogin, db: Session = Depends(get_db)):
    token = login_user(user, db)
    return token
