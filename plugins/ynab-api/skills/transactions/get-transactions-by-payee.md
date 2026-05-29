# GET /plans/{plan_id}/payees/{payee_id}/transactions - Get Transactions by Payee

Returns all transactions for a specified payee, excluding pending transactions. Returns HybridTransaction objects.

## Curl Command

```bash
./scripts/ynab-curl GET "/plans/${PLAN_ID}/payees/${PAYEE_ID}/transactions" > /tmp/response.json
```

## Input

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `plan_id` | string | Yes | Plan ID |
| `payee_id` | string | Yes | Payee ID |

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
    "transactions": [ HybridTransaction, ... ],
    "server_knowledge": 1234
  }
}
```

See [get-transactions-by-category.md](get-transactions-by-category.md) for HybridTransaction fields.
