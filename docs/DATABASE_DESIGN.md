# DUTY TRACK

# Database Design

Version: 1.0

Status: Draft

---

# Database Philosophy

The database is designed to be independent from the underlying database engine.

The same logical structure should work with:

- Cloud Firestore
- PostgreSQL
- MySQL
- Oracle Database
- SQLite

Flutter should never depend directly on a specific database.

Repositories are responsible for communicating with data sources.

---

# Core Entities

Authentication

Users

Roles

Permissions

Personnel

Operations

Attendance

Leaves

Training Programs

Reports

Master Data

Settings

Audit Logs

---

# Master Data

Master Data stores all reference information used across the system.

Tables include:

- Ranks
- Departments
- Job Titles
- Service Locations
- Service Posts
- Leave Types
- Mission Types
- Attendance Types
- Training Types
- Duty Patterns

Master Data rarely changes.

---

# Personnel

Stores personnel information.

Each personnel record belongs to:

- Rank
- Department
- Job Title
- Duty Pattern

Personnel may participate in:

- Daily Services
- Missions
- Leaves
- Attendance
- Training Programs

---

# Daily Services

Daily Services represent routine daily security assignments.

Examples:

- External Gate
- Internal Gate
- Reception
- Towers
- Roof
- Operations Room

Daily Services are created from predefined service posts.

---

# Service Locations

A service location is a physical place inside the correctional facility.

Example:

External Gate

contains:

- Gate Officer
- Assistant
- Food Inspector
- Visitor Register
- Female Register
- Female Inspectors

---

# Service Posts

Each Service Location contains multiple Service Posts.

Personnel are assigned to Service Posts.

Example:

Location

↓

External Gate

↓

Posts

↓

Gate Officer

↓

Personnel

---

# Daily Assignment

Stores daily personnel assignments.

Each assignment contains:

Date

Location

Post

Personnel

Notes

Status

---

# Special Missions

Independent missions.

Examples:

Court

Hospital

Escort

Transport

Inspection

Emergency

---

# Attendance

Attendance is recorded daily.

Types include:

Present

Absent

Permission

Late

Attendance is separate from Leave.

---

# Leaves

Stores leave information.

Examples:

Annual

Sick

Emergency

Official

Each leave has:

Start Date

End Date

Status

Replacement Personnel

---

# Training Programs

Stores cultural and educational programs.

Includes:

Program

Instructor

Location

Participants

Attendance

Notes

---

# Reports

Reports are generated from database records.

No report stores duplicated information.

Reports are generated dynamically.

---

# Audit Logs

Every important action should be logged.

Examples:

Create

Update

Delete

Login

Logout

Export

---

# Future Database Support

Current:

Firebase

Future:

SQLite

REST API

PostgreSQL

MySQL

Oracle

The application architecture should allow replacing the database without changing the UI.