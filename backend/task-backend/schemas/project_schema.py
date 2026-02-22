from pydantic import BaseModel
from datetime import datetime
from typing import List, Optional
from .task_schema import TaskOut  


# PROJECT CREATE

class ProjectCreate(BaseModel):
    title: str
    description: Optional[str] = None


# PROJECT RESPONSE


class ProjectOut(BaseModel):
    id: int
    title: str
    description: Optional[str]
    buyer_id: int
    created_at: datetime
    tasks: List[TaskOut] = [] 

    class Config:
        from_attributes = True