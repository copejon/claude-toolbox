# PATCH /plans/{plan_id}/category_groups/{category_group_id} - Update a Category Group

Updates an existing category group.

## Curl Command

```bash
# Save request body to file, then:
./scripts/ynab-curl PATCH "/plans/${PLAN_ID}/category_groups/${CATEGORY_GROUP_ID}" /tmp/body.json > /tmp/response.json
```

## Input

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `plan_id` | string | Yes | Plan ID |
| `category_group_id` | string | Yes | Category group ID |

**Request Body:**

```json
{
  "category_group": {
    "name": "string (required, max 50 chars)"
  }
}
```

## Response (200)

```json
{
  "data": {
    "category_group": {
      "id": "uuid",
      "name": "Renamed Group",
      "hidden": false,
      "deleted": false
    },
    "server_knowledge": 1234
  }
}
```
