# DELETE /plans/{plan_id}/transactions/{transaction_id} - Delete a Transaction

Deletes a transaction.

## Curl Command

```bash
./scripts/ynab-curl DELETE "/plans/${PLAN_ID}/transactions/${TRANSACTION_ID}" > /tmp/response.json
```

## Input

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `plan_id` | string | Yes | Plan ID |
| `transaction_id` | string | Yes | Transaction ID |

**Request Body:** None

## Response (200)

```json
{
  "data": {
    "transaction": {
      "id": "string",
      "deleted": true,
      ...
    },
    "server_knowledge": 1234
  }
}
```

Returns the deleted TransactionDetail with `deleted: true`.
