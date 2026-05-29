# POST /plans/{plan_id}/payees - Create a Payee

Creates a new payee.

## Curl Command

```bash
# Save request body to file, then:
./scripts/ynab-curl POST "/plans/${PLAN_ID}/payees" /tmp/body.json > /tmp/response.json
```

## Input

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `plan_id` | string | Yes | Plan ID |

**Request Body:**

```json
{
  "payee": {
    "name": "string (required, max 500 chars)"
  }
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `payee.name` | string | Yes | Payee name (max 500 characters) |

## Response (201)

```json
{
  "data": {
    "payee": {
      "id": "uuid",
      "name": "Walmart",
      "transfer_account_id": null,
      "deleted": false
    },
    "server_knowledge": 1234
  }
}
```
