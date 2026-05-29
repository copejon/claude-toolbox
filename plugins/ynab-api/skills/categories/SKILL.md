---
name: ynab-categories
description: Manage YNAB categories and category groups — list, create, update categories and set monthly assigned amounts.
user-invocable: false
---

YNAB Category operations. NEVER create new categories or category groups without explicitly asking the user first.

Reference the endpoint files in this directory for curl commands, input specs, and response schemas:

- [get-categories.md](get-categories.md) — GET /plans/{plan_id}/categories
- [get-category-by-id.md](get-category-by-id.md) — GET /plans/{plan_id}/categories/{category_id}
- [create-category.md](create-category.md) — POST /plans/{plan_id}/categories
- [update-category.md](update-category.md) — PATCH /plans/{plan_id}/categories/{category_id}
- [get-month-category.md](get-month-category.md) — GET /plans/{plan_id}/months/{month}/categories/{category_id}
- [update-month-category.md](update-month-category.md) — PATCH /plans/{plan_id}/months/{month}/categories/{category_id}
- [create-category-group.md](create-category-group.md) — POST /plans/{plan_id}/category_groups
- [update-category-group.md](update-category-group.md) — PATCH /plans/{plan_id}/category_groups/{category_group_id}
