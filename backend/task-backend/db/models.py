from sqlalchemy import (
    Column,
    Integer,
    String,
    Text,
    ForeignKey,
    Enum,
    Numeric,
    Float,
    DateTime,
    Boolean
)
from sqlalchemy.orm import relationship
from datetime import datetime
import enum

from db.database import Base


# ENUMS

class UserRole(str, enum.Enum):
    ADMIN = "admin"
    BUYER = "buyer"
    DEVELOPER = "developer"


class TaskStatus(str, enum.Enum):
    TODO = "todo"
    IN_PROGRESS = "in_progress"
    SUBMITTED = "submitted"
    PAID = "paid"


# USERS TABLE

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String(255), unique=True, nullable=False, index=True)
    password_hash = Column(String(255), nullable=False)
    role = Column(Enum(UserRole), nullable=False)

    created_at = Column(DateTime, default=datetime.utcnow)

    # Relationships
    projects = relationship("Project", back_populates="buyer", cascade="all, delete")
    assigned_tasks = relationship("Task", back_populates="developer")
    payments = relationship("Payment", back_populates="buyer")



# PROJECTS TABLE

class Project(Base):
    __tablename__ = "projects"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(255), nullable=False)
    description = Column(Text)

    buyer_id = Column(Integer, ForeignKey("users.id"), nullable=False)

    created_at = Column(DateTime, default=datetime.utcnow)

    # Relationships
    buyer = relationship("User", back_populates="projects")
    tasks = relationship("Task", back_populates="project", cascade="all, delete")


# TASKS TABLE

class Task(Base):
    __tablename__ = "tasks"

    id = Column(Integer, primary_key=True, index=True)

    title = Column(String(255), nullable=False)
    description = Column(Text)

    project_id = Column(Integer, ForeignKey("projects.id"), nullable=False)
    developer_id = Column(Integer, ForeignKey("users.id"), nullable=True)

    hourly_rate = Column(Numeric(10, 2), nullable=False)
    hours_spent = Column(Float, nullable=True)

    status = Column(Enum(TaskStatus), default=TaskStatus.TODO)

    # File upload & submission
    solution_file_path = Column(String(500), nullable=True)
    solution_url = Column(String(500), nullable=True)  # public access URL

    # Submission lock/unlock
    submission_locked = Column(Boolean, default=True)

    created_at = Column(DateTime, default=datetime.utcnow)
    submitted_at = Column(DateTime, nullable=True)
    paid_at = Column(DateTime, nullable=True)

    # Relationships
    project = relationship("Project", back_populates="tasks")
    developer = relationship("User", back_populates="assigned_tasks")
    payment = relationship("Payment", back_populates="task", uselist=False)

# PAYMENTS TABLE

class Payment(Base):
    __tablename__ = "payments"

    id = Column(Integer, primary_key=True, index=True)

    task_id = Column(Integer, ForeignKey("tasks.id"), nullable=False)
    buyer_id = Column(Integer, ForeignKey("users.id"), nullable=False)

    amount = Column(Numeric(10, 2), nullable=False)

    is_completed = Column(Boolean, default=False)

    created_at = Column(DateTime, default=datetime.utcnow)
    completed_at = Column(DateTime, nullable=True)

    # Relationships
    task = relationship("Task", back_populates="payment")
    buyer = relationship("User", back_populates="payments")
