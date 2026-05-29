# GET /plans/{plan_id}/payees - Get All Payees

Returns all payees.

## Curl Command

```bash
./scripts/ynab-curl GET "/plans/${PLAN_ID}/payees" > /tmp/response.json
```

## Input

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `plan_id` | string | Yes | Plan ID |

**Query Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `last_knowledge_of_server` | int64 | No | Only return entities changed since this value |

**Request Body:** None

## Response (200)

```json
{
  "data": {
    "payees": [
      {
        "id": "uuid",
        "name": "string",
        "transfer_account_id": null,
        "deleted": false
      }
    ],
    "server_knowledge": 1234
  }
}
```

### Payee Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | uuid | Payee ID |
| `name` | string | Payee name |
| `transfer_account_id` | uuid or null | If transfer payee, the target account ID |
| `deleted` | boolean | Whether deleted |
