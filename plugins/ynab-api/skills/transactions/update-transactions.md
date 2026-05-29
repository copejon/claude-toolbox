# PATCH /plans/{plan_id}/transactions - Update Multiple Transactions

Updates multiple transactions by `id` or `import_id`.

## Curl Command

```bash
# Save request body to file, then:
./scripts/ynab-curl PATCH "/plans/${PLAN_ID}/transactions" /tmp/body.json > /tmp/response.json
```

## Input

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `plan_id` | string | Yes | Plan ID |

**Request Body:**

```json
{
  "transactions": [
    {
      "id": "string or null",
      "import_id": "string or null",
      "account_id": "uuid",
      "date": "date",
      "amount": 0,
      "payee_id": "uuid or null",
      "payee_name": "string or null",
      "category_id": "uuid or null",
      "memo": "string or null",
      "cleared": "cleared",
      "approved": true,
      "flag_color": "red"
    }
  ]
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | string or null | No* | Transaction ID for lookup. *Provide `id` or `import_id`. |
| `import_id` | string or null | No* | Import ID for lookup. Cannot update an existing import_id. |

All other fields are optional -- only provided fields are updated. See [create-transaction.md](create-transaction.md) for field descriptions.

## Response (209)

```json
{
  "data": {
    "transaction_ids": ["string"],
    "transactions": [ TransactionDetail, ... ],
    "duplicate_import_ids": [],
    "server_knowledge": 1234
  }
}
```
