# PATCH /plans/{plan_id}/months/{month}/categories/{category_id} - Update Month Category

Update a category for a specific month. Only `budgeted` (assigned) amount can be updated.

## Curl Command

```bash
# Save request body to file, then:
./scripts/ynab-curl PATCH "/plans/${PLAN_ID}/months/2024-01-01/categories/${CATEGORY_ID}" /tmp/body.json > /tmp/response.json
```

## Input

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `plan_id` | string | Yes | Plan ID |
| `month` | date | Yes | ISO date (e.g. `2024-01-01`) or `"current"` |
| `category_id` | string | Yes | Category ID |

**Request Body:**

```json
{
  "category": {
    "budgeted": 500000
  }
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `category.budgeted` | int64 | Yes | Assigned amount in milliunits (e.g. 500000 = $500.00) |

## Response (200)

```json
{
  "data": {
    "category": { ... },
    "server_knowledge": 1234
  }
}
```
