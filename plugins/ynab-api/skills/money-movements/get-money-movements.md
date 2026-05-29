# GET /plans/{plan_id}/money_movements - Get All Money Movements

Returns all money movements (category-to-category fund moves).

## Curl Command

```bash
./scripts/ynab-curl GET "/plans/${PLAN_ID}/money_movements" > /tmp/response.json
```

## Input

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `plan_id` | string | Yes | Plan ID |

**Request Body:** None

## Response (200)

```json
{
  "data": {
    "money_movements": [
      {
        "id": "uuid",
        "month": "2024-01-01",
        "moved_at": "2024-01-15T12:00:00Z",
        "note": null,
        "money_movement_group_id": "uuid",
        "performed_by_user_id": "uuid",
        "from_category_id": "uuid",
        "to_category_id": "uuid",
        "amount": 100000,
        "amount_formatted": "$100.00",
        "amount_currency": 100.00
      }
    ],
    "server_knowledge": 1234
  }
}
```

### MoneyMovement Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | uuid | Movement ID |
| `month` | date or null | Month of the movement |
| `moved_at` | datetime or null | When the movement was processed |
| `note` | string or null | Note |
| `money_movement_group_id` | uuid or null | Parent group ID |
| `performed_by_user_id` | uuid or null | User who performed it |
| `from_category_id` | uuid or null | Source category |
| `to_category_id` | uuid or null | Destination category |
| `amount` | int64 | Amount in milliunits |
