# GET /plans/{plan_id}/money_movement_groups - Get All Money Movement Groups

Returns all money movement groups.

## Curl Command

```bash
./scripts/ynab-curl GET "/plans/${PLAN_ID}/money_movement_groups" > /tmp/response.json
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
    "money_movement_groups": [
      {
        "id": "uuid",
        "group_created_at": "2024-01-15T12:00:00Z",
        "month": "2024-01-01",
        "note": null,
        "performed_by_user_id": "uuid"
      }
    ],
    "server_knowledge": 1234
  }
}
```

### MoneyMovementGroup Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | uuid | Group ID |
| `group_created_at` | datetime | When the group was created |
| `month` | date | Month of the group |
| `note` | string or null | Note |
| `performed_by_user_id` | uuid or null | User who performed it |
