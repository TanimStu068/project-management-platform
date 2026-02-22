from datetime import datetime
from fastapi import HTTPException
from sqlalchemy.orm import Session
from db.models import Payment, Task, TaskStatus, User
from services.task_service import mark_task_paid

def create_payment(task_id: int, buyer: User, db: Session):
    task = db.query(Task).filter(Task.id == task_id).first()
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")

    # Validate task is ready
    if task.status != TaskStatus.SUBMITTED:
        raise HTTPException(status_code=400, detail="Task not ready for payment")
    if not task.hours_spent or not task.solution_url:
        raise HTTPException(status_code=400, detail="Task incomplete: cannot pay")
    if task.project.buyer_id != buyer.id:
        raise HTTPException(status_code=403, detail="Not authorized")

    # Prevent duplicate payment
    existing_payment = db.query(Payment).filter(Payment.task_id == task.id).first()
    if existing_payment:
        if existing_payment.is_completed:
            raise HTTPException(status_code=400, detail="Task already paid")
        else:
            # Update pending payment
            existing_payment.amount = float(task.hourly_rate) * float(task.hours_spent)
            existing_payment.completed_at = datetime.utcnow()
            existing_payment.is_completed = True
            db.commit()
            db.refresh(existing_payment)
            mark_task_paid(task, db)
            return existing_payment

    # Create new payment
    total_amount = float(task.hourly_rate) * float(task.hours_spent)
    payment = Payment(
        task_id=task.id,
        buyer_id=buyer.id,
        amount=total_amount,
        is_completed=True,
        completed_at=datetime.utcnow()
    )
    db.add(payment)
    db.commit()
    db.refresh(payment)

    # Unlock task for buyer download
    mark_task_paid(task, db)

    return payment