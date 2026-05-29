# GET /plans/{plan_id}/payee_locations - Get All Payee Locations

Returns all payee locations. Locations are GPS coordinates stored when entering transactions on YNAB mobile apps.

## Curl Command

```bash
./scripts/ynab-curl GET "/plans/${PLAN_ID}/payee_locations" > /tmp/response.json
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

### PayeeLocation Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | uuid | Location ID |
| `payee_id` | uuid | Associated payee ID |
| `latitude` | string | GPS latitude |
| `longitude` | string | GPS longitude |
| `deleted` | boolean | Whether deleted |
