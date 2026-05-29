# GET /plans/{plan_id}/scheduled_transactions/{scheduled_transaction_id} - Get a Scheduled Transaction

Returns a single scheduled transaction.

## Curl Command

```bash
./scripts/ynab-curl GET "/plans/${PLAN_ID}/scheduled_transactions/${SCHEDULED_TRANSACTION_ID}" > /tmp/response.json
```

## Input

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `plan_id` | string | Yes | Plan ID |
| `scheduled_transaction_id` | string | Yes | Scheduled transaction ID |

**Request Body:** None

## Response (200)

```json
{
  "data": {
    "scheduled_transaction": { ScheduledTransactionDetail }
  }
}
```

See [get-scheduled-transactions.md](get-scheduled-transactions.md) for ScheduledTransactionDetail fields.
