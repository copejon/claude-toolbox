# GET /plans/{plan_id}/months/{month}/categories/{category_id} - Get Category for Month

Returns a single category for a specific plan month.

## Curl Command

```bash
./scripts/ynab-curl GET "/plans/${PLAN_ID}/months/2024-01-01/categories/${CATEGORY_ID}" > /tmp/response.json
```

## Input

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `plan_id` | string | Yes | Plan ID |
| `month` | date | Yes | ISO date (e.g. `2024-01-01`) or `"current"` |
| `category_id` | string | Yes | Category ID |

**Request Body:** None

## Response (200)

```json
{
  "data": {
    "category": {
      "id": "uuid",
      "category_group_id": "uuid",
      "name": "string",
      "budgeted": 500000,
      "activity": -250000,
      "balance": 250000,
      "deleted": false,
      "balance_formatted": "$250.00",
      "balance_currency": 250.00,
      "activity_formatted": "-$250.00",
      "activity_currency": -250.00,
      "budgeted_formatted": "$500.00",
      "budgeted_currency": 500.00
    }
  }
}
```
