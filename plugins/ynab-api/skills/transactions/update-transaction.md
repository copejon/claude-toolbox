# PUT /plans/{plan_id}/transactions/{transaction_id} - Update a Transaction

Updates a single transaction.

## Curl Command

```bash
# Save request body to file, then:
./scripts/ynab-curl PUT "/plans/${PLAN_ID}/transactions/${TRANSACTION_ID}" /tmp/body.json > /tmp/response.json
```

## Input

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `plan_id` | string | Yes | Plan ID |
| `transaction_id` | string | Yes | Transaction ID |

**Request Body:**

```json
{
  "transaction": {
    "account_id": "uuid",
    "date": "date",
    "amount": 0,
    "payee_id": "uuid or null",
    "payee_name": "string or null",
    "category_id": "uuid or null",
    "memo": "string or null",
    "cleared": "cleared",
    "approved": true,
    "flag_color": "red",
    "subtransactions": []
  }
}
```

All fields are optional. Split transaction dates and amounts cannot be changed. Updating subtransactions on existing splits is not supported. See [create-transaction.md](create-transaction.md) for field descriptions.

## Response (200)

```json
{
  "data": {
    "transaction": { TransactionDetail },
    "server_knowledge": 1234
  }
}
```
