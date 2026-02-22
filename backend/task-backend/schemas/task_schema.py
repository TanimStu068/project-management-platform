from pydantic import BaseModel
from datetime import datetime
from typing import Optional
from db.models import TaskStatus


# TASK CREATE (Buyer)
class TaskCreate(BaseModel):
    title: str
    description: Optional[str] = None
    developer_id: int
    hourly_rate: float



# TASK UPDATE STATUS (Developer)
class TaskStatusUpdate(BaseModel):
    status: TaskStatus


# TASK SUBMISSION (Developer)
class TaskSubmit(BaseModel):
    hours_spent: float
    solution_url: str  


# TASK RESPONSE
class TaskOut(BaseModel):
    id: int
    title: str
    description: Optional[str]
    project_id: int
    developer_id: Optional[int]
    hourly_rate: float
    hours_spent: Optional[float]
    status: TaskStatus
    solution_url: Optional[str]       
    submission_locked: Optional[bool] 
    created_at: datetime
    submitted_at: Optional[datetime]
    paid_at: Optional[datetime]

    class Config:
        from_attributes = True