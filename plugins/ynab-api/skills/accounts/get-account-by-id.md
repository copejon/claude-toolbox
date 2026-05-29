# GET /plans/{plan_id}/accounts/{account_id} - Get an Account

Returns a single account.

## Curl Command

```bash
./scripts/ynab-curl GET "/plans/${PLAN_ID}/accounts/${ACCOUNT_ID}" > /tmp/response.json
```

## Input

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `plan_id` | string | Yes | Plan ID |
| `account_id` | uuid | Yes | Account ID |

**Request Body:** None

## Response (200)

```json
{
  "data": {
    "account": {
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
  }
}
```
