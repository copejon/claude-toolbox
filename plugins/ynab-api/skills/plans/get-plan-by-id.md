# GET /plans/{plan_id} - Get a Plan

Returns a single plan with all related entities. Effectively a full plan export.

## Curl Command

```bash
./scripts/ynab-curl GET "/plans/${PLAN_ID}" > /tmp/response.json
```

## Input

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `plan_id` | string | Yes | Plan ID. Use `"last-used"` for last used plan, `"default"` for default plan. |

**Query Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `last_knowledge_of_server` | int64 | No | If provided, only entities changed since this value are included |

**Request Body:** None

## Response (200)

```json
{
  "data": {
    "plan": {
      "id": "uuid",
      "name": "string",
      "last_modified_on": "datetime",
      "first_month": "date",
      "last_month": "date",
      "date_format": { "format": "string" },
      "currency_format": { ... },
      "accounts": [ { "id": "uuid", "name": "string", "type": "checking", "on_budget": true, "closed": false, "note": null, "balance": 0, "cleared_balance": 0, "uncleared_balance": 0, "transfer_payee_id": "uuid", "deleted": false } ],
      "payees": [ { "id": "uuid", "name": "string", "transfer_account_id": null, "deleted": false } ],
      "payee_locations": [ { "id": "uuid", "payee_id": "uuid", "latitude": "string", "longitude": "string", "deleted": false } ],
      "category_groups": [ { "id": "uuid", "name": "string", "hidden": false, "deleted": false } ],
      "categories": [ { "id": "uuid", "category_group_id": "uuid", "name": "string", "hidden": false, "budgeted": 0, "activity": 0, "balance": 0, "deleted": false } ],
      "months": [ { "month": "date", "income": 0, "budgeted": 0, "activity": 0, "to_be_budgeted": 0, "age_of_money": null, "deleted": false, "categories": [] } ],
      "transactions": [ { "id": "string", "date": "date", "amount": 0, "memo": null, "cleared": "cleared", "approved": true, "flag_color": null, "account_id": "uuid", "payee_id": "uuid", "category_id": "uuid", "deleted": false } ],
      "subtransactions": [ { "id": "string", "transaction_id": "string", "amount": 0, "memo": null, "payee_id": null, "category_id": "uuid", "deleted": false } ],
      "scheduled_transactions": [ { "id": "uuid", "date_first": "date", "date_next": "date", "frequency": "monthly", "amount": 0, "account_id": "uuid", "deleted": false } ],
      "scheduled_subtransactions": [ { "id": "uuid", "scheduled_transaction_id": "uuid", "amount": 0, "deleted": false } ]
    },
    "server_knowledge": 1234
  }
}
```

### Response Fields

| Field | Type | Description |
|-------|------|-------------|
| `data.plan` | PlanDetail | Full plan export |
| `data.server_knowledge` | int64 | Server knowledge value for delta requests |
