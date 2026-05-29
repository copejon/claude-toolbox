# GET /plans/{plan_id}/categories - Get All Categories

Returns all categories grouped by category group. Amounts are specific to the current plan month (UTC).

## Curl Command

```bash
./scripts/ynab-curl GET "/plans/${PLAN_ID}/categories" > /tmp/response.json
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
    "category_groups": [
      {
        "id": "uuid",
        "name": "string",
        "hidden": false,
        "deleted": false,
        "categories": [
          {
            "id": "uuid",
            "category_group_id": "uuid",
            "category_group_name": "string",
            "name": "string",
            "hidden": false,
            "original_category_group_id": null,
            "note": null,
            "budgeted": 500000,
            "activity": -250000,
            "balance": 250000,
            "goal_type": "NEED",
            "goal_needs_whole_amount": null,
            "goal_day": null,
            "goal_cadence": 1,
            "goal_cadence_frequency": 1,
            "goal_creation_month": "2024-01-01",
            "goal_target": 500000,
            "goal_target_month": null,
            "goal_target_date": "2024-12-01",
            "goal_percentage_complete": 100,
            "goal_months_to_budget": 0,
            "goal_under_funded": 0,
            "goal_overall_funded": 500000,
            "goal_overall_left": 0,
            "goal_snoozed_at": null,
            "deleted": false,
            "balance_formatted": "$250.00",
            "balance_currency": 250.00,
            "activity_formatted": "-$250.00",
            "activity_currency": -250.00,
            "budgeted_formatted": "$500.00",
            "budgeted_currency": 500.00,
            "goal_target_formatted": "$500.00",
            "goal_target_currency": 500.00,
            "goal_under_funded_formatted": "$0.00",
            "goal_under_funded_currency": 0.00,
            "goal_overall_funded_formatted": "$500.00",
            "goal_overall_funded_currency": 500.00,
            "goal_overall_left_formatted": "$0.00",
            "goal_overall_left_currency": 0.00
          }
        ]
      }
    ],
    "server_knowledge": 1234
  }
}
```

### Category Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | uuid | Category ID |
| `category_group_id` | uuid | Parent group ID |
| `name` | string | Category name |
| `hidden` | boolean | Whether hidden |
| `budgeted` | int64 | Assigned amount in milliunits |
| `activity` | int64 | Activity amount in milliunits |
| `balance` | int64 | Available balance in milliunits |
| `goal_type` | string or null | TB, TBD, MF, NEED, DEBT, or null |
| `goal_target` | int64 or null | Goal target in milliunits |
| `goal_target_date` | date or null | Goal target date |
| `goal_percentage_complete` | int32 or null | Goal completion percentage |
| `goal_under_funded` | int64 or null | Underfunded amount in milliunits |
| `deleted` | boolean | Whether deleted |
