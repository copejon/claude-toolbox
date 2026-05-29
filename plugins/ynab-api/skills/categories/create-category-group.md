# POST /plans/{plan_id}/category_groups - Create a Category Group

Creates a new category group.

## Curl Command

```bash
# Save request body to file, then:
./scripts/ynab-curl POST "/plans/${PLAN_ID}/category_groups" /tmp/body.json > /tmp/response.json
```

## Input

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `plan_id` | string | Yes | Plan ID |

**Request Body:**

```json
{
  "category_group": {
    "name": "string (required, max 50 chars)"
  }
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `category_group.name` | string | Yes | Category group name (max 50 characters) |

## Response (201)

```json
{
  "data": {
    "category_group": {
      "id": "uuid",
      "name": "Monthly Bills",
      "hidden": false,
      "deleted": false
    },
    "server_knowledge": 1234
  }
}
```
