# DUTY TRACK

# Software Architecture

Version: 1.0

Status: Approved

---

# Architecture Style

The project follows:

- Clean Architecture
- Feature First Architecture
- Repository Pattern
- Service Layer Pattern
- Riverpod State Management
- Material 3 Design System

---

# High-Level Architecture

                UI
                 │
                 ▼
             Riverpod
                 │
                 ▼
            Repository
                 │
                 ▼
             Service Layer
                 │
                 ▼
            Data Source
       ┌─────────┴─────────┐
       ▼                   ▼
 Firebase            Future Database
                     (PostgreSQL / MySQL / SQLite)

---

# Layer Responsibilities

## Presentation Layer

Contains:

- Screens
- Widgets
- Dialogs

Responsibilities:

- Display data
- Receive user input

Must NEVER:

- Access Firebase directly
- Execute business logic

---

## Provider Layer

Responsibilities:

- Manage state
- Execute use cases
- Call repositories

Must NEVER:

- Read Firestore directly

---

## Repository Layer

Responsibilities:

- Coordinate data flow

Repositories know:

- Which service to call

Repositories DO NOT know:

- UI

---

## Service Layer

Responsibilities:

- Communicate with Firebase
- CRUD Operations
- Authentication
- File Storage

Services DO NOT know:

- Flutter UI

---

## Data Source Layer

Current:

Firebase

Future:

REST API

SQLite

PostgreSQL

MySQL

Oracle

---

# Project Structure

lib/

app/

core/

shared/

features/

docs/

---

# Feature Structure

feature/

data/

models/

repositories/

services/

providers/

presentation/

screens/

widgets/

---

# Shared Layer

Contains reusable components only.

Examples:

Dialogs

Loading

Buttons

TextFields

Validators

Extensions

---

# Core Layer

Contains:

Constants

Utilities

Exceptions

Themes

Base Classes

---

# Dependency Rule

Outer layers depend on inner layers.

Never the opposite.

UI

↓

Provider

↓

Repository

↓

Service

↓

Database

---

# Forbidden Rules

Presentation must NEVER access Firebase.

Repositories must NEVER depend on UI.

Widgets must NEVER contain business logic.

Services must NEVER contain UI code.

---

# Scalability

Every new module must follow the same architecture.

Examples:

Personnel

Operations

Attendance

Leaves

Training

Reports

Settings

Future modules should be added without changing existing architecture.

---

# Design Goals

Simple

Maintainable

Scalable

Testable

Offline Ready

Production Ready