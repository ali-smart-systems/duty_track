# DUTY TRACK

## System Requirements Specification (SRS)

Version: 1.0
Status: Draft
Project: DUTY TRACK
Client: Human Resources Department - Dhamar Central Correctional Facility
Prepared By: Ali Saleh

---

# 1. Project Overview

DUTY TRACK is a Human Resources and Daily Operations Management System designed specifically for the Human Resources Department at Dhamar Central Correctional Facility.

The system aims to simplify daily work, reduce repetitive manual data entry, improve accuracy, and automatically generate official reports and manpower statements.

The application is designed primarily for Android devices, with future support for Windows and Web.

---

# 2. Vision

The goal of DUTY TRACK is not only to store employee information.

Its primary purpose is to help the Human Resources Manager complete his daily work in the shortest possible time while producing accurate official reports.

---

# 3. Primary User

Human Resources Manager.

Future users may include:

- Prison Director
- Operations Officer
- Department Managers
- Administrative Staff

---

# 4. Project Objectives

The system shall:

- Manage personnel information.
- Manage daily services.
- Manage special missions.
- Manage attendance.
- Manage leaves.
- Manage cultural programs.
- Generate daily reports.
- Generate monthly reports.
- Export reports to PDF.
- Export reports to Excel.

---

# 5. Core Principles

The project follows these principles:

1. Ease of use comes first.
2. Minimize user clicks.
3. Minimize repetitive typing.
4. Automation whenever possible.
5. Production-ready architecture.
6. Clean Architecture.
7. Responsive Design.
8. Offline-ready architecture.
9. Scalable architecture.

---

# 6. Main Modules

Authentication

Users

Roles & Permissions

Personnel

Operations

Attendance

Leaves

Training Programs

Reports

Dashboard

Settings

Master Data

---

# 7. Daily Services

Daily services include locations such as:

- External Gate
- Internal Gate
- Middle Gate
- Reception
- Tower 1
- Tower 2
- Tower 3
- Tower 4
- Roof
- Operations Room
- Office
- Cultural Center
- Health Center
- Public Kitchen
- Bakery
- Staff Kitchen
- Juvenile Section

Each location contains one or more service posts.

Personnel are assigned to service posts on a daily basis.

---

# 8. Special Missions

Special missions include:

- Court Escort
- Hospital Escort
- Prisoner Transport
- Reinforcement
- Inspection
- Emergency Tasks

Special missions are independent from daily services.

---

# 9. Attendance

Attendance records include:

- Present
- Absent
- Permission
- Late

Attendance is recorded daily.

---

# 10. Leaves

Leave records include:

- Annual Leave
- Sick Leave
- Emergency Leave
- Official Leave

Leaves are managed independently from attendance.

---

# 11. Cultural Programs

The system shall manage:

- Cultural lectures
- Religious lectures
- Awareness programs
- Training sessions

Attendance shall be recorded.

---

# 12. Reports

The system shall generate:

- Daily reports
- Two-day reports
- Monthly reports
- Human Resources Statement
- Personnel Statement
- Daily Service Statement

Reports shall support:

- PDF Export
- Excel Export
- Printing

---

# 13. Future Goals

Future versions may include:

- Offline synchronization
- PostgreSQL backend
- SQLite local database
- Notifications
- Backup & Restore
- Digital signatures

---

# 14. Success Criteria

The project is considered successful when:

- Daily services can be completed within a few minutes.
- Reports can be generated automatically.
- Manual repetitive work is eliminated.
- The Human Resources Manager can perform his work with minimal effort.