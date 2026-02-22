# Project Management & Paid Task Mini-Platform

A **full-stack project management platform** built with **Flutter**, **FastAPI**, and **PostgreSQL**. This platform allows buyers to create projects and assign paid tasks to developers, while admins can monitor statistics. Access to task solutions is **locked until payment is completed**.

---

## 🚀 Features

### User Roles

**1. Admin / Owner**
- View platform-wide dashboard statistics
- Cannot modify tasks directly
- Dashboard includes:
  - Total projects
  - Total tasks
  - Completed tasks
  - Total payments received
  - Pending payments
  - Total developer hours logged
  - Revenue generated (hourly rate × hours)

**2. Buyer**
- Create projects
- Assign tasks to developers
- Define hourly rate per task
- View task progress & submission status
- Complete payment to unlock submitted work
- Download task solutions after payment

**3. Developer**
- View assigned tasks
- Update task status
- Submit:
  - Time taken to complete task
  - ZIP file solution
- Cannot receive payment directly

---

### Task Workflow

1. **Task Assignment**
   - Buyer creates a task, sets hourly rate, assigns a developer.

2. **Task Completion**
   - Developer marks task as completed and submits ZIP solution with hours spent.

3. **Submission Lock**
   - Buyer sees “Submitted” status, hours spent, and total amount due.
   - Task solution is **locked until payment**.

4. **Payment**
   - Buyer completes payment via platform.
   - Payment is stored in backend.
   - Task status updates to “Paid”.

5. **Access Granted**
   - Buyer can now download ZIP solution and view full submission details.

---

## 🛠 Tech Stack

**Frontend:** Flutter  
**Backend:** FastAPI (Python)  
**Database:** PostgreSQL  
**State Management:** Provider (Flutter)  
**Payment Workflow:** Custom implementation (task-locked until payment)

---
