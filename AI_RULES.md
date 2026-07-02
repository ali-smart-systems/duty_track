# DUTY_TRACK - AI Development Rules

## Project Overview

Project Name: DUTY_TRACK

Purpose:
A production-ready Flutter application for managing human resources at Taiz Central Prison.

This is NOT a demo project.
All generated code must be production-ready.

---

## Technology Stack

- Flutter (Stable)
- Dart
- Firebase Authentication
- Cloud Firestore
- Riverpod
- GoRouter
- Material 3

---

## Architecture

Use:

- Clean Architecture
- Repository Pattern
- Feature-first structure

Never break the existing architecture.

---

## Folder Structure

Keep this structure exactly:

lib/
├── app/
├── core/
├── features/
├── shared/

Do not rename folders.
Do not move files unless explicitly requested.

---

## Feature Structure

Each feature must contain:

data/
presentation/
providers/

Inside data:

models/
repositories/
services/

---

## Coding Standards

- Write production-ready code only.
- No placeholder code.
- No TODO comments.
- No duplicated code.
- Use null safety.
- Keep code clean and readable.
- Follow SOLID principles.

---

## Firebase Rules

Never access Firebase directly from UI.

Correct flow:

UI
↓

Provider
↓

Repository
↓

Service
↓

Firebase

---

## Navigation

Use GoRouter.

Never hardcode route strings.

Always use AppRoutes constants.

---

## State Management

Use Riverpod.

Business logic belongs inside Providers.

Do not place business logic inside Widgets.

---

## UI

Use Material 3.

Support:

- Android
- Windows
- Web

Responsive UI is required.

---

## Project Features

Authentication

Dashboard

Personnel

Tasks

Leaves

Training

Reports

Activity Log

Settings

Backup

PDF Export

Excel Export

---

## Code Quality

The project must always satisfy:

flutter analyze

Result:

No issues found.

---

## Git

Every generated code must compile.

Every commit must be buildable.

Never leave broken code.

---

## Before Generating Code

Always inspect the existing project structure.

Generate code compatible with the current project.

Do not recreate existing files unless requested.

Only modify the necessary files.

Never change project architecture without approval.

---

## AI Role

You are working as a Senior Flutter Engineer.

Produce enterprise-grade code.

Always think about scalability, maintainability, and clean architecture.