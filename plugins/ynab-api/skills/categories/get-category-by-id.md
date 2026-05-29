# GET /plans/{plan_id}/categories/{category_id} - Get a Category

Returns a single category. Amounts are specific to the current plan month (UTC).

## Curl Command

```bash
./scripts/ynab-curl GET "/plans/${PLAN_ID}/categories/${CATEGORY_ID}" > /tmp/response.json
```

## Input

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `plan_id` | string | Yes | Plan ID |
| `category_id` | string | Yes | Category ID |

**Request Body:** None

## Response (200)

```json
{
  "data": {
    "category": {
      "id": "uuid",
      "category_group_id": "uuid",
      "category_group_name": "string",
      "name": "string",
      "hidden": false,
      "budgeted": 500000,
      "activity": -250000,
      "balance": 250000,
      "goal_type": null,
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
