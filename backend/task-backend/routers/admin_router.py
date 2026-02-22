from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from core.dependencies import get_db, get_current_admin
from db.models import User, Project, Task, Payment
from db.models import User, Project, Task, Payment, TaskStatus

router = APIRouter(prefix="/admin", tags=["Admin"])


# DASHBOARD STATISTICS
@router.get("/stats")
def admin_dashboard(db: Session = Depends(get_db), admin=Depends(get_current_admin)):
    # Users
    total_buyers = db.query(User).filter(User.role == "buyer").count()
    total_developers = db.query(User).filter(User.role == "developer").count()

    # Projects and tasks
    total_projects = db.query(Project).count()
    total_tasks = db.query(Task).count()
    tasks_by_status = {
        status.value: db.query(Task).filter(Task.status == status).count()
        for status in TaskStatus
    }
    completed_tasks = db.query(Task).filter(Task.status == "paid").count()

    # Payments
    total_payments = db.query(Payment).filter(Payment.is_completed == True).count()
    pending_payments = db.query(Payment).filter(Payment.is_completed == False).count()
    revenue = db.query(Payment).filter(Payment.is_completed == True).with_entities(
        Payment.amount
    ).all()
    revenue_sum = sum([r[0] for r in revenue])

    # Total developer hours logged
    total_hours = db.query(Task).filter(Task.hours_spent != None).with_entities(
        Task.hours_spent
    ).all()
    total_hours_sum = sum([h[0] for h in total_hours])

    return {
        "total_projects": total_projects,
        "total_tasks": total_tasks,
        "tasks_by_status": tasks_by_status,
        "completed_tasks": completed_tasks,
        "total_payments": total_payments,
        "pending_payments": pending_payments,
        "total_buyers": total_buyers,
        "total_developers": total_developers,
        "total_hours_logged": total_hours_sum,
        "revenue": revenue_sum
    }
