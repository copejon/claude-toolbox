# GET /plans/{plan_id}/accounts - Get All Accounts

Returns all accounts for a plan.

## Curl Command

```bash
./scripts/ynab-curl GET "/plans/${PLAN_ID}/accounts" > /tmp/response.json
```

## Input

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `plan_id` | string | Yes | Plan ID. Use `"last-used"` or `"default"`. |

**Query Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `last_knowledge_of_server` | int64 | No | Only return entities changed since this value |

**Request Body:** None

## Response (200)

```json
{
  "data": {
    "accounts": [
      {
        "id": "uuid",
        "name": "string",
        "type": "checking",
        "on_budget": true,
        "closed": false,
        "note": null,
        "balance": 1000000,
        "cleared_balance": 900000,
        "uncleared_balance": 100000,
        "transfer_payee_id": "uuid",
        "direct_import_linked": false,
        "direct_import_in_error": false,
        "last_reconciled_at": null,
        "debt_original_balance": null,
        "debt_interest_rates": null,
        "debt_minimum_payments": null,
        "debt_escrow_amounts": null,
        "deleted": false,
        "balance_formatted": "$1,000.00",
        "balance_currency": 1000.00,
        "cleared_balance_formatted": "$900.00",
        "cleared_balance_currency": 900.00,
        "uncleared_balance_formatted": "$100.00",
        "uncleared_balance_currency": 100.00
      }
    ],
    "server_knowledge": 1234
  }
}
```

### Account Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | uuid | Account ID |
| `name` | string | Account name |
| `type` | AccountType | checking, savings, cash, creditCard, lineOfCredit, otherAsset, otherLiability, mortgage, autoLoan, studentLoan, personalLoan, medicalDebt, otherDebt |
| `on_budget` | boolean | Whether on budget |
| `closed` | boolean | Whether closed |
| `note` | string or null | Account note |
| `balance` | int64 | Available balance in milliunits |
| `cleared_balance` | int64 | Cleared balance in milliunits |
| `uncleared_balance` | int64 | Uncleared balance in milliunits |
| `transfer_payee_id` | uuid or null | Payee ID for transfers to this account |
| `direct_import_linked` | boolean | Linked to financial institution |
| `direct_import_in_error` | boolean | Link in error state |
| `last_reconciled_at` | datetime or null | Last reconciliation time |
| `deleted` | boolean | Whether deleted |
