from fastapi import APIRouter, Depends, UploadFile, File, HTTPException
from sqlalchemy.orm import Session
from typing import List  # <- Add this
import os
import shutil
from services.task_service import create_task, start_task, submit_task
from core.dependencies import get_db, get_current_user
from db.models import TaskStatus, Task, User
from fastapi.responses import FileResponse
from schemas.task_schema import TaskCreate, TaskOut
from fastapi import Form

router = APIRouter(prefix="/tasks", tags=["Tasks"])

# CREATE TASK
@router.post("/{project_id}", response_model=TaskOut)
def create_new_task(
    project_id: int,
    task: TaskCreate,
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user)
):
    return create_task(project_id, task, current_user, db)
# START TASK
@router.post("/start/{task_id}")
def start_task_endpoint(task_id: int, db: Session = Depends(get_db),
                        current_user=Depends(get_current_user)):
    return start_task(task_id, current_user, db)

# SUBMIT TASK WITH ZIP
@router.post("/submit/{task_id}")
def submit_task_endpoint(task_id: int, hours_spent: float = Form(...),
                         zip_file: UploadFile = File(...),
                         db: Session = Depends(get_db),
                         current_user=Depends(get_current_user)):

    if not zip_file.filename.endswith(".zip"):
        raise HTTPException(status_code=400, detail="Only ZIP files allowed")

    upload_dir = f"uploads/tasks/{task_id}"
    os.makedirs(upload_dir, exist_ok=True)
    file_path = os.path.join(upload_dir, zip_file.filename)
    with open(file_path, "wb") as buffer:
        shutil.copyfileobj(zip_file.file, buffer)

    return submit_task(task_id, hours_spent, current_user, db, zip_file_path=file_path)

# DOWNLOAD TASK
@router.get("/download/{task_id}")
def download_task_solution(task_id: int, db: Session = Depends(get_db),
                           current_user=Depends(get_current_user)):
    task = db.query(Task).filter(Task.id == task_id).first()
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")

    if task.project.buyer_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not authorized")

    if task.status != TaskStatus.PAID or not task.solution_file_path:
        raise HTTPException(status_code=400, detail="Task not paid or solution not available")

    return FileResponse(path=task.solution_file_path, filename=os.path.basename(task.solution_file_path))

@router.get("/developer", response_model=List[TaskOut])
def get_developer_tasks(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    tasks = db.query(Task).filter(Task.developer_id == current_user.id).all()
    return tasks
