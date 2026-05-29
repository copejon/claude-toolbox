# GET /plans/{plan_id}/transactions/{transaction_id} - Get a Transaction

Returns a single transaction.

## Curl Command

```bash
./scripts/ynab-curl GET "/plans/${PLAN_ID}/transactions/${TRANSACTION_ID}" > /tmp/response.json
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
      "date": "2024-01-15",
      "amount": -50000,
      "memo": "string",
      "cleared": "cleared",
      "approved": true,
      "flag_color": null,
      "account_id": "uuid",
      "account_name": "Checking",
      "payee_id": "uuid",
      "payee_name": "Grocery Store",
      "category_id": "uuid",
      "category_name": "Groceries",
      "subtransactions": [],
      "deleted": false,
      "amount_formatted": "-$50.00",
      "amount_currency": -50.00
    },
    "server_knowledge": 1234
  }
}
```

See [get-transactions.md](get-transactions.md) for full TransactionDetail field reference.
