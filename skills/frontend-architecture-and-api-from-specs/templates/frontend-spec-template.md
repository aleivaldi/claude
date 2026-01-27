# Frontend Specifications - [Project Name]

> **Status:** [Draft/Review/Approved]
> **Version:** [X.Y]
> **Last Updated:** [Date]
> **Derived from:** [User Stories v1.0 / Project Brief]

---

## 1. Overview

**Project:** [Project Name]
**Application Type:** [Web App/Mobile App/Desktop App/Multi-platform]
**Target Platforms:** [Desktop/Mobile/Tablet/Multi-platform]
**Purpose:** [Brief description of what this application does - 1-2 lines]

---

## 2. User Roles

### [Role Name]
[Brief description of access level and primary goals - 1-2 lines]

### [Role Name]
[Brief description of access level and primary goals - 1-2 lines]

---

## 3. Sitemap

### Visual Structure

```
/ (Public)
├─ /
├─ /login
├─ /signup
├─ /forgot-password
│
/app (Authenticated - User)
├─ /dashboard (home)
├─ /feature-a
│  ├─ /feature-a (list)
│  ├─ /feature-a/:id (detail)
│  └─ /feature-a/new (create)
├─ /feature-b
└─ /settings
   ├─ /settings/profile
   ├─ /settings/account
   └─ /settings/preferences
│
/admin (Authenticated - Admin)
├─ /admin/dashboard
├─ /admin/users
│  ├─ /admin/users (list)
│  └─ /admin/users/:id (detail)
└─ /admin/system
```

### Access Matrix

| Path Pattern | Roles | Redirect if Unauthorized |
|-------------|-------|-------------------------|
| / | All | - |
| /login | Guest | /dashboard if authenticated |
| /app/* | User, Admin | /login |
| /admin/* | Admin only | /dashboard |

---

## 4. Screens Inventory

### [Screen Name] (`/path/to/screen`, [Role1, Role2])
[1 line describing screen purpose]

#### Data Displayed
- [Field/Info Name] ([type])
- [Field/Info Name] ([type])
- [Nested structure]:
  - [Sub-field] ([type])
  - [Sub-field] ([type])
- [Field/Info Name] ([type])

#### Actions Available
- [Action Name]
- [Action Name]
- [Action Name]

#### Input Required (only if screen has forms)
- [Field Name] ([type, validation])
- [Field Name] ([type, validation])

---

### [Screen Name] (`/path/to/screen`, [Role1, Role2])
[Repeat structure above for each screen]

