# DELETE /plans/{plan_id}/scheduled_transactions/{scheduled_transaction_id} - Delete a Scheduled Transaction

Deletes a scheduled transaction.

## Curl Command

```bash
./scripts/ynab-curl DELETE "/plans/${PLAN_ID}/scheduled_transactions/${SCHEDULED_TRANSACTION_ID}" > /tmp/response.json
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
    "scheduled_transaction": {
      "id": "uuid",
      "deleted": true,
      ...
    }
  }
}
```

Returns the deleted ScheduledTransactionDetail with `deleted: true`.
