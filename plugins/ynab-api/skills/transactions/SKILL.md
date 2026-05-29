---
name: ynab-transactions
description: Manage YNAB transactions — list, create, update, delete, import, and filter transactions by account, category, payee, or month.
user-invocable: false
---

YNAB Transaction operations. Reference the endpoint files in this directory for curl commands, input specs, and response schemas:

- [get-transactions.md](get-transactions.md) — GET /plans/{plan_id}/transactions
- [get-transaction-by-id.md](get-transaction-by-id.md) — GET /plans/{plan_id}/transactions/{transaction_id}
- [create-transaction.md](create-transaction.md) — POST /plans/{plan_id}/transactions
- [update-transaction.md](update-transaction.md) — PUT /plans/{plan_id}/transactions/{transaction_id}
- [update-transactions.md](update-transactions.md) — PATCH /plans/{plan_id}/transactions
- [delete-transaction.md](delete-transaction.md) — DELETE /plans/{plan_id}/transactions/{transaction_id}
- [import-transactions.md](import-transactions.md) — POST /plans/{plan_id}/transactions/import
- [get-transactions-by-account.md](get-transactions-by-account.md) — GET /plans/{plan_id}/accounts/{account_id}/transactions
- [get-transactions-by-category.md](get-transactions-by-category.md) — GET /plans/{plan_id}/categories/{category_id}/transactions
- [get-transactions-by-payee.md](get-transactions-by-payee.md) — GET /plans/{plan_id}/payees/{payee_id}/transactions
- [get-transactions-by-month.md](get-transactions-by-month.md) — GET /plans/{plan_id}/months/{month}/transactions
