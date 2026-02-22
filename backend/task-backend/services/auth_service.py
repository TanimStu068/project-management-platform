from sqlalchemy.orm import Session
from fastapi import HTTPException, status
from datetime import timedelta

from db.models import User, UserRole
from schemas.user_schema import UserCreate, UserLogin
from core.security import hash_password, verify_password, create_access_token
from core.config import settings

# REGISTER USER
def register_user(user_data: UserCreate, db: Session):
    existing_user = db.query(User).filter(User.email == user_data.email).first()

    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email already registered"
        )

    hashed_pw = hash_password(user_data.password)

    new_user = User(
        email=user_data.email,
        password_hash=hashed_pw,
        role=user_data.role
    )

    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    return new_user


# LOGIN USER
def login_user(user_data: UserLogin, db: Session):
    user = db.query(User).filter(User.email == user_data.email).first()

    if not user or not verify_password(user_data.password, user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid credentials"
        )

    access_token = create_access_token(
        data={
            "sub": str(user.id),
            "role": user.role.value
        },
        expires_delta=timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    )

    return {"access_token": access_token}
