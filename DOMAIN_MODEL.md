# DUTY_TRACK

# Domain Model

Version 1.0

---

# Overview

The project follows Domain Driven Design (DDD).

Every module represents a real business entity.

Business logic must always be based on these entities.

No UI component should define business rules.

---

# Core Domain

The Personnel entity is the center of the system.

Almost every module depends on Personnel.

Personnel
│
├── Duties
├── Leaves
├── Attendance
├── Violations
├── Promotions
├── Transfers
├── Training
├── Weapons
├── Assets
├── Reports

---

# Main Entities

## User

Represents a system account.

Fields

- Id
- Username
- PasswordHash
- Role
- Status
- LastLogin

Relations

One User
↓

Many Activity Logs

---

## Personnel

Represents one military employee.

Fields

- Id
- MilitaryNumber
- NationalId
- FullName
- Rank
- Department
- JobTitle
- BirthDate
- HireDate
- Status

Relations

One Personnel

↓

Many Duties

↓

Many Leaves

↓

Many Attendance

↓

Many Promotions

↓

Many Transfers

↓

Many Violations

↓

Many Training Courses

↓

Many Weapons

↓

Many Assets

---

## Duty

Represents one duty schedule.

Fields

- Id
- Date
- Shift
- Location
- Notes

Relations

One Duty

↓

Many DutyPersonnel

---

## DutyPersonnel

Bridge Entity

Fields

- DutyId
- PersonnelId
- Role
- IsLeader

---

## Leave

Fields

- Id
- PersonnelId
- Type
- StartDate
- EndDate
- Reason
- Status

---

## Attendance

Fields

- Id
- PersonnelId
- Date
- Status
- CheckIn
- CheckOut

---

## Promotion

Fields

- Id
- PersonnelId
- OldRank
- NewRank
- Date

---

## Transfer

Fields

- Id
- PersonnelId
- OldDepartment
- NewDepartment
- Date

---

## Training

Fields

- Id
- PersonnelId
- CourseName
- Provider
- StartDate
- EndDate

---

## Violation

Fields

- Id
- PersonnelId
- Type
- Date
- Decision

---

## Weapon

Fields

- Id
- WeaponNumber
- Type
- Status

Relations

One Weapon

↓

Assigned To

↓

One Personnel

---

## Asset

Fields

- Id
- AssetNumber
- Name
- Status

Relations

Assigned To Personnel

---

## Department

Fields

- Id
- Name
- Description

Relations

One Department

↓

Many Personnel

---

## Report

Virtual Entity

Generated from:

Personnel

+

Duties

+

Leaves

+

Attendance

+

Violations

+

Promotions

+

Transfers

---

# Aggregate Roots

Personnel

Duty

Department

User

---

# Value Objects

MilitaryNumber

NationalId

PhoneNumber

EmailAddress

Rank

DepartmentName

DutyRole

LeaveType

AttendanceStatus

---

# Enumerations

PersonnelStatus

DutyShift

LeaveStatus

LeaveType

AttendanceStatus

WeaponStatus

AssetStatus

UserRole

Permission

---

# Future Modules

Medical Records

Payroll

Vehicles

Prisoners

Visitors

Inventory

Fingerprint

Face Recognition

AI Reports

GIS

Electronic Archive

Document Management

Digital Signature

REST API

Offline Sync

Cloud Backup

Multi Organization

Multi Branch

Audit Center