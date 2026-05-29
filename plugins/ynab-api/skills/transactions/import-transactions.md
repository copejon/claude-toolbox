# POST /plans/{plan_id}/transactions/import - Import Transactions

Imports available transactions on all linked accounts for the given plan. Equivalent to clicking "Import" in the web app or tapping "New Transactions" in the mobile apps.

## Curl Command

```bash
./scripts/ynab-curl POST "/plans/${PLAN_ID}/transactions/import" > /tmp/response.json
```

## Input

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `plan_id` | string | Yes | Plan ID |

**Request Body:** None

## Response (200/201)

```json
{
  "data": {
    "transaction_ids": [
      "string"
    ]
  }
}
```

| Field | Type | Description |
|-------|------|-------------|
| `data.transaction_ids` | array[string] | IDs of imported transactions |

- **200**: No new transactions to import
- **201**: One or more transactions were imported
