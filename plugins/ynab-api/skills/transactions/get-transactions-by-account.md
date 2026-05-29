# GET /plans/{plan_id}/accounts/{account_id}/transactions - Get Transactions by Account

Returns all transactions for a specified account, excluding pending transactions.

## Curl Command

```bash
./scripts/ynab-curl GET "/plans/${PLAN_ID}/accounts/${ACCOUNT_ID}/transactions" > /tmp/response.json
```

## Input

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `plan_id` | string | Yes | Plan ID |
| `account_id` | string | Yes | Account ID |

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
