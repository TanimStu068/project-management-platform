from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from schemas.payment_schema import PaymentOut
from services.payment_service import create_payment
from core.dependencies import get_db, get_current_user

router = APIRouter(prefix="/payments", tags=["Payments"])

# PAY FOR TASK
@router.post("/task/{task_id}", response_model=PaymentOut)
def pay_for_task(
    task_id: int,
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user)
):
    """
    Process payment for a task:
    - Validates task status (SUBMITTED)
    - Ensures hours and solution URL exist
    - Prevents duplicate payments
    - Unlocks the task for buyer download after payment
    """
    payment = create_payment(task_id, current_user, db)
    return payment