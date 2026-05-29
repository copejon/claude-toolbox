# GET /plans/{plan_id}/months - Get All Plan Months

Returns all plan months.

## Curl Command

```bash
./scripts/ynab-curl GET "/plans/${PLAN_ID}/months" > /tmp/response.json
```

## Input

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `plan_id` | string | Yes | Plan ID |

**Query Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `last_knowledge_of_server` | int64 | No | Only return entities changed since this value |

**Request Body:** None

## Response (200)

```json
{
  "data": {
    "months": [
      {
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
        "to_be_budgeted_currency": 500.00
      }
    ],
    "server_knowledge": 1234
  }
}
```

### MonthSummary Fields

| Field | Type | Description |
|-------|------|-------------|
| `month` | date | The month |
| `note` | string or null | Month note |
| `income` | int64 | Total inflow to "Ready to Assign" in milliunits |
| `budgeted` | int64 | Total assigned in milliunits |
| `activity` | int64 | Total activity (excluding inflow) in milliunits |
| `to_be_budgeted` | int64 | Ready to Assign amount in milliunits |
| `age_of_money` | int32 or null | Age of Money |
| `deleted` | boolean | Whether deleted |
