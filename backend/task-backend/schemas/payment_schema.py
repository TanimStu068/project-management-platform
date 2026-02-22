from pydantic import BaseModel
from datetime import datetime
from typing import Optional


# PAYMENT CREATE

class PaymentCreate(BaseModel):
    task_id: int


# PAYMENT RESPONSE

class PaymentOut(BaseModel):
    id: int
    task_id: int
    buyer_id: int
    amount: float
    is_completed: bool
    created_at: datetime
    completed_at: Optional[datetime]

    class Config:
        from_attributes = True
