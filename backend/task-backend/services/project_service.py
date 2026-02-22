from sqlalchemy.orm import Session, joinedload
from fastapi import HTTPException, status
from db.models import Project, User
from schemas.project_schema import ProjectCreate

# CREATE PROJECT (Buyer Only)
def create_project(project_data: ProjectCreate, buyer: User, db: Session):
    new_project = Project(
        title=project_data.title,
        description=project_data.description,
        buyer_id=buyer.id
    )

    db.add(new_project)
    db.commit()
    db.refresh(new_project)

    return new_project


# GET BUYER PROJECTS
def get_buyer_projects(buyer: User, db: Session):
    return db.query(Project).filter(Project.buyer_id == buyer.id).all()


# GET SINGLE PROJECT
def get_project(project_id, user, db):
    project = (
        db.query(Project)
        .options(joinedload(Project.tasks)) 
        .filter(Project.id == project_id, Project.buyer_id == user.id)
        .first()
    )
    if not project:
        raise HTTPException(status_code=404, detail="Project not found")
    return project
