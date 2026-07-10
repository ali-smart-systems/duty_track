# BUSINESS_REQUIREMENTS.md

# DUTY_TRACK
## Business Requirements Specification (BRS)

Version: 1.0

---

# 1. Purpose

Duty Track is an Enterprise Human Resources Management System (HRMS)
designed specifically for military and security organizations.

The first deployment target is the Human Resources Department at Taiz Central Prison.

The system replaces paper-based workflows with a secure digital platform.

---

# 2. Business Goal

The primary objective is to help the Director of Human Resources manage all personnel information from a single centralized system.

The system must reduce:

- Paperwork
- Duplicate records
- Manual calculations
- Lost documents
- Time spent preparing reports

while improving:

- Accuracy
- Search speed
- Reporting
- Decision making
- Accountability

---

# 3. Current Situation

Currently most operations are performed manually.

Personnel data is distributed between:

- Paper files
- Printed reports
- Excel sheets
- Handwritten notes

This causes:

- Slow searching
- Difficult updates
- Duplicate information
- Missing records
- Human errors

---

# 4. Target Users

Primary User

- Director of Human Resources

Secondary Users

- HR Officers
- Unit Commanders
- Administrative Staff

Future Users

- System Administrator
- Read-only Supervisors
- Auditors

---

# 5. Main Business Domains

The ERP system will eventually contain the following modules:

1. Authentication

2. Dashboard

3. Personnel Management

4. Duty Management

5. Leave Management

6. Attendance

7. Absence

8. Violations

9. Promotions

10. Transfers

11. Training

12. Weapons Assignment

13. Assets Management

14. Reports

15. Notifications

16. Activity Log

17. Settings

18. Backup & Restore

---

# 6. Personnel Module

Purpose

Maintain complete personnel records.

Capabilities

- Add personnel
- Edit personnel
- Delete personnel
- Search personnel
- Filter personnel
- View profile
- Archive personnel
- Print reports

Status

Completed.

---

# 7. Duty Module

Purpose

Manage all duty assignments.

Capabilities

- Create duty
- Edit duty
- Delete duty
- Assign personnel
- Assign leader
- Assign role
- Print duty sheet
- View duty history

Status

In Progress.


---

# 8. Business Rules

The following business rules must be respected throughout the system.

## Personnel

- Every personnel member has one unique military number.
- Military number cannot be duplicated.
- National ID cannot be duplicated.
- A personnel record must always belong to one department.
- A personnel record must always have one military rank.
- Deleted personnel should be archived instead of permanently removed whenever possible.

---

## Duties

- Every duty has one date.
- Every duty has one shift.
- Every duty must have at least one assigned personnel.
- One personnel cannot be assigned twice to the same duty.
- Only one leader is allowed per duty.
- Every assigned personnel has a role.
- Duty history must never be lost.

---

## Leaves

- Leave cannot overlap another approved leave.
- Leave requires approval.
- Leave history must remain permanently.

---

## Attendance

- Attendance is recorded daily.
- Absence automatically appears in reports.
- Late attendance should be tracked separately.

---

## Reports

Reports must always reflect live data.

Reports should support:

- PDF
- Excel
- Printing

---

## Security

Only authenticated users may access the system.

Every action should be logged.

Sensitive operations require permissions.

---

## Data Integrity

No duplicated records.

No orphan records.

No invalid references.

Every modification should update UpdatedAt.

CreatedAt should never change.

---

## Future Scalability

The system must support:

- Multiple prisons
- Multiple branches
- Multiple organizations
- Thousands of personnel
- Millions of records

without requiring architecture changes.


---

# 9. Personnel Life Cycle

## Overview

Every personnel member follows a complete life cycle inside the organization.

The system must preserve the complete history of every personnel member.

No important historical information should ever be lost.

---

## Stage 1 — Recruitment

At the time of joining the organization, the following information is recorded:

- Military Number
- National ID
- Full Name
- Rank
- Department
- Job Title
- Birth Date
- Hire Date
- Phone Number
- Email
- Address
- Emergency Contact
- Notes

Status:

Active

---

## Stage 2 — Active Service

During active service the personnel record continuously changes.

Examples:

- Department changes
- Rank promotions
- Job title updates
- Contact information updates
- Duty assignments
- Leave requests
- Attendance records
- Training courses
- Awards
- Violations

Every change must be recorded.

Historical information must never be deleted.

---

## Stage 3 — Daily Operations

Each personnel member may participate in daily operations.

Examples:

- Duty assignment
- Shift assignment
- Patrol
- Guard duty
- Administrative work

Each assignment becomes part of the personnel history.

---

## Stage 4 — Leave

Personnel may receive leave.

Types may include:

- Annual Leave
- Emergency Leave
- Medical Leave
- Official Assignment
- Special Leave

The system stores:

- Start Date
- End Date
- Duration
- Reason
- Approval
- Notes

Leave history must remain permanently.

---

## Stage 5 — Training

Personnel may attend courses.

Store:

- Course Name
- Provider
- Start Date
- End Date
- Certificate
- Result

Training records become part of the permanent history.

---

## Stage 6 — Promotion

When promoted the system stores:

- Previous Rank
- New Rank
- Promotion Date
- Promotion Order
- Notes

Promotion history must never be deleted.

---

## Stage 7 — Transfer

Personnel may move between departments.

Store:

- Old Department
- New Department
- Transfer Date
- Transfer Order
- Reason

Complete transfer history is required.

---

## Stage 8 — Violations

If violations occur:

Store:

- Type
- Date
- Description
- Penalty
- Decision

Violations remain visible in history.

---

## Stage 9 — Awards

Personnel achievements should be recorded.

Store:

- Award Name
- Date
- Reason
- Issuing Authority

---

## Stage 10 — Retirement / Termination

Personnel eventually leaves the organization.

Possible reasons:

- Retirement
- Transfer outside organization
- Resignation
- Death
- Dismissal

The personnel record must never be deleted.

Instead:

Status = Archived

The complete history remains searchable.

---

# Personnel History

The system must provide a complete chronological timeline for every personnel member.

Example

Recruitment

↓

Promotion

↓

Training

↓

Duty Assignment

↓

Leave

↓

Violation

↓

Promotion

↓

Transfer

↓

Retirement

Everything should remain available for reports and auditing.