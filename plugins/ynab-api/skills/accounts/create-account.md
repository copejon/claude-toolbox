# POST /plans/{plan_id}/accounts - Create an Account

Creates a new account.

## Curl Command

```bash
# Save request body to file, then:
./scripts/ynab-curl POST "/plans/${PLAN_ID}/accounts" /tmp/body.json > /tmp/response.json
```

## Input

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `plan_id` | string | Yes | Plan ID |

**Request Body:**

```json
{
  "account": {
    "name": "string (required)",
    "type": "string (required)",
    "balance": 0
  }
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `account.name` | string | Yes | Account name |
| `account.type` | SaveAccountType | Yes | One of: `checking`, `savings`, `cash`, `creditCard`, `otherAsset`, `otherLiability` |
| `account.balance` | int64 | Yes | Current balance in milliunits (e.g. 1000000 = $1,000.00) |

## Response (201)

```json
{
  "data": {
    "account": {
      "id": "uuid",
      "name": "My Checking",
      "type": "checking",
      "on_budget": true,
      "closed": false,
      "note": null,
      "balance": 1000000,
      "cleared_balance": 1000000,
      "uncleared_balance": 0,
      "transfer_payee_id": "uuid",
      "deleted": false,
      "balance_formatted": "$1,000.00",
      "balance_currency": 1000.00,
      "cleared_balance_formatted": "$1,000.00",
      "cleared_balance_currency": 1000.00,
      "uncleared_balance_formatted": "$0.00",
      "uncleared_balance_currency": 0.00
    }
  }
}
```
