# GET /plans/{plan_id}/months/{month}/money_movements - Get Money Movements by Month

Returns all money movements for a specific month.

## Curl Command

```bash
./scripts/ynab-curl GET "/plans/${PLAN_ID}/months/2024-01-01/money_movements" > /tmp/response.json
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
    "money_movements": [ ... ],
    "server_knowledge": 1234
  }
}
```

Same response shape as [get-money-movements.md](get-money-movements.md).
