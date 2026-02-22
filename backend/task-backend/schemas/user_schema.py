from pydantic import BaseModel, EmailStr
from datetime import datetime
from typing import Optional
from db.models import UserRole


# USER CREATE (REGISTER)
class UserCreate(BaseModel):
    email: EmailStr
    password: str
    role: UserRole


# USER LOGIN
class UserLogin(BaseModel):
    email: EmailStr
    password: str


# USER RESPONSE
class UserOut(BaseModel):
    id: int
    email: EmailStr
    role: UserRole
    created_at: datetime

    class Config:
        from_attributes = True 


# TOKEN RESPONSE
class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
