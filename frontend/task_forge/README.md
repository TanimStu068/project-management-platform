# Flutter Frontend - Project Management Platform

This folder contains the **Flutter application** for the Project Management & Paid Task Mini-Platform.

---

## Overview

The Flutter app provides a **role-based UI** for the platform:

- **Admin / Owner**: View dashboard statistics (tasks, payments, users, revenue).  
- **Buyer**: Create projects, assign tasks, track progress, and make payments.  
- **Developer**: View assigned tasks, update status, submit solutions (ZIP files).

The app connects to the FastAPI backend via REST APIs and ensures **role-based access control** and **payment workflow logic**.

---

## Features

- **Authentication**
  - Email & password login
  - Role-based navigation
- **Project Management (Buyer)**
  - Create and manage projects
  - View all tasks under a project
- **Task Management**
  - Task title, description, assigned developer
  - Hourly rate, status (`todo`, `in_progress`, `submitted`, `paid`)
  - Developer submission of hours & ZIP solution
- **Payment Workflow (Buyer)**
  - Locked submissions until payment
  - Payment confirmation updates task status to `Paid`
  - Access to download ZIP solution after payment
- **Admin Dashboard**
  - View statistics: projects, tasks, completed tasks, payments, revenue, developer hours
- **UI**
  - Dark, premium theme
  - Clean, professional, user-friendly
  - API-driven state management using `Provider`

---
