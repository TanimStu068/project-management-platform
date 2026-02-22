from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session
from typing import List

from schemas.project_schema import ProjectCreate, ProjectOut
from services.project_service import create_project, get_buyer_projects, get_project
from core.dependencies import get_db, get_current_user

router = APIRouter(prefix="/projects", tags=["Projects"])


# CREATE PROJECT
@router.post("/", response_model=ProjectOut, status_code=status.HTTP_201_CREATED)
def create_new_project(
    project: ProjectCreate,
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user)
):
    return create_project(project, current_user, db)


# GET ALL PROJECTS (Buyer)
@router.get("/", response_model=List[ProjectOut])
def list_projects(
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user)
):
    return get_buyer_projects(current_user, db)


# GET SINGLE PROJECT
@router.get("/{project_id}", response_model=ProjectOut)
def get_single_project(
    project_id: int,
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user)
):
    return get_project(project_id, current_user, db)
