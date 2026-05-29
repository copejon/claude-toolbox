# PUT /plans/{plan_id}/scheduled_transactions/{scheduled_transaction_id} - Update a Scheduled Transaction

Updates a single scheduled transaction.

## Curl Command

```bash
# Save request body to file, then:
./scripts/ynab-curl PUT "/plans/${PLAN_ID}/scheduled_transactions/${SCHEDULED_TRANSACTION_ID}" /tmp/body.json > /tmp/response.json
```

## Input

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `plan_id` | string | Yes | Plan ID |
| `scheduled_transaction_id` | string | Yes | Scheduled transaction ID |

**Request Body:**

```json
{
  "scheduled_transaction": {
    "account_id": "uuid (required)",
    "date": "date (required)",
    "amount": 0,
    "payee_id": "uuid or null",
    "payee_name": "string or null",
    "category_id": "uuid or null",
    "memo": "string or null",
    "flag_color": "string or null",
    "frequency": "string"
  }
}
```

See [create-scheduled-transaction.md](create-scheduled-transaction.md) for field descriptions.

## Response (200)

```json
{
  "data": {
    "scheduled_transaction": { ScheduledTransactionDetail }
  }
}
```
