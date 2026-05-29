# PATCH /plans/{plan_id}/payees/{payee_id} - Update a Payee

Updates an existing payee.

## Curl Command

```bash
# Save request body to file, then:
./scripts/ynab-curl PATCH "/plans/${PLAN_ID}/payees/${PAYEE_ID}" /tmp/body.json > /tmp/response.json
```

## Input

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `plan_id` | string | Yes | Plan ID |
| `payee_id` | string | Yes | Payee ID |

**Request Body:**

```json
{
  "payee": {
    "name": "string (max 500 chars)"
  }
}
```

## Response (200)

```json
{
  "data": {
    "payee": {
      "id": "uuid",
      "name": "Walmart Supercenter",
      "transfer_account_id": null,
      "deleted": false
    },
    "server_knowledge": 1234
  }
}
```
