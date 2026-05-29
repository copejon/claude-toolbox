# GET /plans/{plan_id}/months/{month}/money_movement_groups - Get Money Movement Groups by Month

Returns all money movement groups for a specific month.

## Curl Command

```bash
./scripts/ynab-curl GET "/plans/${PLAN_ID}/months/2024-01-01/money_movement_groups" > /tmp/response.json
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
    "money_movement_groups": [ ... ],
    "server_knowledge": 1234
  }
}
```

Same response shape as [get-money-movement-groups.md](get-money-movement-groups.md).
