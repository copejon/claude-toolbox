# GET /plans/{plan_id}/payees/{payee_id} - Get a Payee

Returns a single payee.

## Curl Command

```bash
./scripts/ynab-curl GET "/plans/${PLAN_ID}/payees/${PAYEE_ID}" > /tmp/response.json
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
    "payee": {
      "id": "uuid",
      "name": "string",
      "transfer_account_id": null,
      "deleted": false
    }
  }
}
```
