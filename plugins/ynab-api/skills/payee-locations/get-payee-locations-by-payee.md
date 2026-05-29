# GET /plans/{plan_id}/payees/{payee_id}/payee_locations - Get Locations for a Payee

Returns all payee locations for a specified payee.

## Curl Command

```bash
./scripts/ynab-curl GET "/plans/${PLAN_ID}/payees/${PAYEE_ID}/payee_locations" > /tmp/response.json
```

## Input

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `plan_id` | string | Yes | Plan ID |
| `payee_id` | string | Yes | Payee ID |

**Request Body:** None

## Response (200)

```json
{
  "data": {
    "payee_locations": [
      {
        "id": "uuid",
        "payee_id": "uuid",
        "latitude": "40.7128",
        "longitude": "-74.0060",
        "deleted": false
      }
    ]
  }
}
```
