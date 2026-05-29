# GET /plans/{plan_id}/categories/{category_id}/transactions - Get Transactions by Category

Returns all transactions for a specified category, excluding pending transactions. Returns HybridTransaction objects which include subtransactions inline.

## Curl Command

```bash
./scripts/ynab-curl GET "/plans/${PLAN_ID}/categories/${CATEGORY_ID}/transactions" > /tmp/response.json
```

## Input

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `plan_id` | string | Yes | Plan ID |
| `category_id` | string | Yes | Category ID |

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
    "transactions": [
      {
        "id": "string",
        "date": "2024-01-15",
        "amount": -50000,
        "type": "transaction",
        "parent_transaction_id": null,
        "account_name": "Checking",
        "payee_name": "Store",
        "category_name": "Groceries",
        ...
      }
    ],
    "server_knowledge": 1234
  }
}
```

### HybridTransaction Additional Fields

| Field | Type | Description |
|-------|------|-------------|
| `type` | string | `"transaction"` or `"subtransaction"` |
| `parent_transaction_id` | string or null | For subtransactions, the parent transaction ID |
| `account_name` | string | Account name |
| `payee_name` | string or null | Payee name |
| `category_name` | string | Category name |
