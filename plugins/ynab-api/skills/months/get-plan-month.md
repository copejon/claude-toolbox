# GET /plans/{plan_id}/months/{month} - Get a Plan Month

Returns a single plan month with category details.

## Curl Command

```bash
./scripts/ynab-curl GET "/plans/${PLAN_ID}/months/2024-01-01" > /tmp/response.json
```

## Input

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `plan_id` | string | Yes | Plan ID |
| `month` | date | Yes | ISO date (e.g. `2024-01-01`) or `"current"` |

**Request Body:** None

## Response (200)

```json
{
  "data": {
    "month": {
      "month": "2024-01-01",
      "note": null,
      "income": 5000000,
      "budgeted": 4500000,
      "activity": -3000000,
      "to_be_budgeted": 500000,
      "age_of_money": 30,
      "deleted": false,
      "income_formatted": "$5,000.00",
      "income_currency": 5000.00,
      "budgeted_formatted": "$4,500.00",
      "budgeted_currency": 4500.00,
      "activity_formatted": "-$3,000.00",
      "activity_currency": -3000.00,
      "to_be_budgeted_formatted": "$500.00",
      "to_be_budgeted_currency": 500.00,
      "categories": [
        {
          "id": "uuid",
          "category_group_id": "uuid",
          "name": "Groceries",
          "budgeted": 500000,
          "activity": -250000,
          "balance": 250000,
          "deleted": false
        }
      ]
    }
  }
}
```

The `categories` array contains full Category objects with amounts specific to the requested month.
