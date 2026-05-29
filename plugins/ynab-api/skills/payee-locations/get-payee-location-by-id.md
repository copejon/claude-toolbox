# GET /plans/{plan_id}/payee_locations/{payee_location_id} - Get a Payee Location

Returns a single payee location.

## Curl Command

```bash
./scripts/ynab-curl GET "/plans/${PLAN_ID}/payee_locations/${PAYEE_LOCATION_ID}" > /tmp/response.json
```

## Input

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `plan_id` | string | Yes | Plan ID |
| `payee_location_id` | string | Yes | Payee location ID |

**Request Body:** None

## Response (200)

```json
{
  "data": {
    "payee_location": {
      "id": "uuid",
      "payee_id": "uuid",
      "latitude": "40.7128",
      "longitude": "-74.0060",
      "deleted": false
    }
  }
}
```
