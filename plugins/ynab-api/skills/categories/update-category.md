# PATCH /plans/{plan_id}/categories/{category_id} - Update a Category

Updates an existing category.

## Curl Command

```bash
# Save request body to file, then:
./scripts/ynab-curl PATCH "/plans/${PLAN_ID}/categories/${CATEGORY_ID}" /tmp/body.json > /tmp/response.json
```

## Input

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `plan_id` | string | Yes | Plan ID |
| `category_id` | string | Yes | Category ID |

**Request Body:**

```json
{
  "category": {
    "name": "string or null",
    "note": "string or null",
    "category_group_id": "uuid",
    "goal_target": 0,
    "goal_target_date": "date or null",
    "goal_needs_whole_amount": true
  }
}
```

All fields are optional. Only provided fields are updated.

## Response (200)

```json
{
  "data": {
    "category": { ... },
    "server_knowledge": 1234
  }
}
```
