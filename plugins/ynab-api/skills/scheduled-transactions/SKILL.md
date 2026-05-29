---
name: ynab-scheduled-transactions
description: Manage YNAB scheduled (recurring/future) transactions — list, create, update, or delete.
user-invocable: false
---

YNAB Scheduled Transaction operations. Reference the endpoint files in this directory for curl commands, input specs, and response schemas:

- [get-scheduled-transactions.md](get-scheduled-transactions.md) — GET /plans/{plan_id}/scheduled_transactions
- [get-scheduled-transaction-by-id.md](get-scheduled-transaction-by-id.md) — GET /plans/{plan_id}/scheduled_transactions/{id}
- [create-scheduled-transaction.md](create-scheduled-transaction.md) — POST /plans/{plan_id}/scheduled_transactions
- [update-scheduled-transaction.md](update-scheduled-transaction.md) — PUT /plans/{plan_id}/scheduled_transactions/{id}
- [delete-scheduled-transaction.md](delete-scheduled-transaction.md) — DELETE /plans/{plan_id}/scheduled_transactions/{id}
