from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

# Routers
from routers import (
    auth_router,
    project_router,
    task_router,
    payment_router,
    admin_router,
    developer_router
)

# Database
from db.database import Base, engine

# Create all tables (if not exist)
Base.metadata.create_all(bind=engine)

# Initialize FastAPI
app = FastAPI(
    title="TaskForge Project Management API",
    description="Flutter + FastAPI + PostgreSQL Mini Platform Backend",
    version="1.0.0"
)

# -------------------------------
# CORS (Allow frontend connection)
# -------------------------------
origins = [
    "http://localhost",
    "http://localhost:3000",  # React/Flutter web dev
    "http://127.0.0.1:8000",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,  # frontend URLs
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# -------------------------------
# Include Routers
# -------------------------------
app.include_router(auth_router.router)
app.include_router(project_router.router)
app.include_router(task_router.router)
app.include_router(payment_router.router)
app.include_router(admin_router.router)
app.include_router(developer_router.router)

# -------------------------------
# Startup and Shutdown Events
# -------------------------------
@app.on_event("startup")
async def startup_event():
    print("🚀 TaskForge backend is starting...")

@app.on_event("shutdown")
async def shutdown_event():
    print("🛑 TaskForge backend is shutting down...")
