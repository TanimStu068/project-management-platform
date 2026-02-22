import os
import shutil
import zipfile
from datetime import datetime
from fastapi import HTTPException
from sqlalchemy.orm import Session
from db.models import Task, TaskStatus, User

# CREATE TASK (Buyer)
def create_task(project_id: int, task_data, buyer: User, db: Session):
    from db.models import Project

    project = db.query(Project).filter(
        Project.id == project_id,
        Project.buyer_id == buyer.id
    ).first()
    if not project:
        raise HTTPException(status_code=404, detail="Project not found")

    new_task = Task(
        title=task_data.title,
        description=task_data.description,
        project_id=project_id,
        developer_id=task_data.developer_id,
        hourly_rate=task_data.hourly_rate,
        status=TaskStatus.TODO,
        submission_locked=True, 
    )

    db.add(new_task)
    db.commit()
    db.refresh(new_task)
    return new_task

# DEVELOPER START TASK
def start_task(task_id: int, developer: User, db: Session):
    task = db.query(Task).filter(
        Task.id == task_id,
        Task.developer_id == developer.id
    ).first()
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")

    if task.status != TaskStatus.TODO:
        raise HTTPException(status_code=400, detail="Task already started or submitted")

    task.status = TaskStatus.IN_PROGRESS
    db.commit()
    db.refresh(task)
    return task

# DEVELOPER SUBMIT TASK WITH ZIP
def submit_task(task_id: int, hours_spent: float, developer: User, db: Session, zip_file_path: str):
    task = db.query(Task).filter(
        Task.id == task_id,
        Task.developer_id == developer.id
    ).first()
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")

    if task.status != TaskStatus.IN_PROGRESS:
        raise HTTPException(status_code=400, detail="Task must be IN_PROGRESS to submit")

    if not task.submission_locked:
        raise HTTPException(status_code=400, detail="Task already submitted or unlocked")

    # Extract ZIP safely
    extract_dir = zip_file_path.replace(".zip", "")
    os.makedirs(extract_dir, exist_ok=True)
    try:
        with zipfile.ZipFile(zip_file_path, 'r') as zip_ref:
            zip_ref.extractall(extract_dir)
    except zipfile.BadZipFile:
        raise HTTPException(status_code=400, detail="Invalid ZIP file")

    # Update task
    task.hours_spent = hours_spent
    task.solution_file_path = zip_file_path
    task.solution_url = extract_dir 
    task.status = TaskStatus.SUBMITTED
    task.submitted_at = datetime.utcnow()
    task.submission_locked = True 

    db.commit()
    db.refresh(task)
    return task

# MARK TASK PAID (Unlock download)
def mark_task_paid(task: Task, db: Session):
    if task.status == TaskStatus.PAID:
        raise HTTPException(status_code=400, detail="Task already paid")

    task.status = TaskStatus.PAID
    task.paid_at = datetime.utcnow()
    task.submission_locked = False 

    db.commit()
    db.refresh(task)
    return task