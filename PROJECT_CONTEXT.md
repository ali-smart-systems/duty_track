# DUTY_TRACK - Project Context

# Project Overview

DUTY_TRACK is a production-ready Flutter application developed to manage the Human Resources Department of Taiz Central Prison.

The application is intended for real daily use and is not a learning or demonstration project.

The system must be scalable, maintainable, and ready for future expansion.

---

# Current Users

Currently there is only one user:

Human Resources Manager

In the future the system must support:

- Multiple users
- Roles
- Permissions

The architecture must already support future expansion.

---

# Main Objective

The application manages:

- Personnel
- Tasks
- Leaves
- Training Programs
- Weekly Reports
- Monthly Reports
- Activity Logs
- Settings
- Backup

---

# Technologies

Flutter Stable

Firebase Authentication

Cloud Firestore

Riverpod

GoRouter

Material 3

Clean Architecture

Repository Pattern

---

# Firestore Collections

users

personnel

tasks

leaves

trainings

reports

activity_logs

settings

---

# Main Features

Authentication

Dashboard

Personnel Management

Task Management

Leave Management

Training Management

Reports

PDF Export

Excel Export

Search

Filtering

Backup

Settings

Activity Log

---

# Target Platforms

Android (Primary)

Windows

Web

The UI must be responsive.

Phones use Bottom Navigation + Drawer.

Windows/Web/Tablets use a permanent Navigation Drawer.

---

# Dashboard Design

Dashboard is NOT just a screen.

Dashboard is the Application Shell.

It contains:

- AppBar
- Drawer
- Bottom Navigation
- Page Container

All modules are displayed inside Dashboard.

---

# Authentication

Authentication uses Firebase Authentication.

Login screen asks for:

- Username
- Password

The Repository converts Username to Email and authenticates using Firebase Authentication.

---

# Coding Philosophy

This project follows enterprise software principles.

Every generated code must:

- be production-ready
- be clean
- be reusable
- be scalable
- follow SOLID principles

No temporary code.

No placeholder implementations.

No duplicated logic.

---

# Future Roadmap

Phase 1

Foundation

Authentication

Dashboard

Phase 2

Personnel

Phase 3

Tasks

Phase 4

Leaves

Phase 5

Training

Phase 6

Reports

PDF

Excel

Phase 7

Settings

Activity Logs

Backup

---

# Important Notes

Do not redesign the architecture.

Do not rename folders.

Do not move files without explicit instruction.

Generate code compatible with the existing project.

Always preserve backward compatibility.

The project must always pass:

flutter analyze

with zero issues.