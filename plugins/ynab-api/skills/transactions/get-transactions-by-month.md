# GET /plans/{plan_id}/months/{month}/transactions - Get Transactions by Month

Returns all transactions for a specified month, excluding pending transactions.

## Curl Command

```bash
./scripts/ynab-curl GET "/plans/${PLAN_ID}/months/2024-01-01/transactions" > /tmp/response.json
```

## Input

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `plan_id` | string | Yes | Plan ID |
| `month` | date | Yes | ISO date (e.g. `2024-01-01`) or `"current"` |

**Query Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `since_date` | date | No | Only transactions on or after this date |
| `type` | string | No | `"uncategorized"` or `"unapproved"` |
| `last_knowledge_of_server` | int64 | No | Delta request |

**Request Body:** None

## Response (200)

```json
{
  "data": {
    "transactions": [ TransactionDetail, ... ],
    "server_knowledge": 1234
  }
}
```

See [get-transactions.md](get-transactions.md) for full TransactionDetail field reference.
