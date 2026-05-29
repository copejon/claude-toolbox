# POST /plans/{plan_id}/categories - Create a Category

Creates a new category.

## Curl Command

```bash
# Save request body to file, then:
./scripts/ynab-curl POST "/plans/${PLAN_ID}/categories" /tmp/body.json > /tmp/response.json
```

## Input

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `plan_id` | string | Yes | Plan ID |

**Request Body:**

```json
{
  "category": {
    "name": "string (required)",
    "category_group_id": "uuid (required)",
    "note": "string or null",
    "goal_target": 0,
    "goal_target_date": "date or null",
    "goal_needs_whole_amount": true
  }
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `category.name` | string | Yes | Category name |
| `category.category_group_id` | uuid | Yes | Parent category group ID |
| `category.note` | string or null | No | Category note |
| `category.goal_target` | int64 or null | No | Goal target in milliunits. If set without existing goal, creates a monthly goal. |
| `category.goal_target_date` | date or null | No | Goal target date (ISO format) |
| `category.goal_needs_whole_amount` | boolean or null | No | For NEED goals: true = "Set aside another", false = "Refill up to" |

## Response (201)

```json
{
  "data": {
    "category": { ... },
    "server_knowledge": 1234
  }
}
```

Returns a `Category` object (see get-categories.md) plus `server_knowledge`.
