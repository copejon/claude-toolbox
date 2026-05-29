# GET /plans/{plan_id}/scheduled_transactions - Get All Scheduled Transactions

Returns all scheduled transactions.

## Curl Command

```bash
./scripts/ynab-curl GET "/plans/${PLAN_ID}/scheduled_transactions" > /tmp/response.json
```

## Input

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `plan_id` | string | Yes | Plan ID |

**Query Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `last_knowledge_of_server` | int64 | No | Delta request |

**Request Body:** None

## Response (200)

```json
{
  "data": {
    "scheduled_transactions": [
      {
        "id": "uuid",
        "date_first": "2024-01-01",
        "date_next": "2024-02-01",
        "frequency": "monthly",
        "amount": -100000,
        "memo": "Rent",
        "flag_color": null,
        "flag_name": null,
        "account_id": "uuid",
        "payee_id": "uuid",
        "category_id": "uuid",
        "transfer_account_id": null,
        "deleted": false,
        "amount_formatted": "-$100.00",
        "amount_currency": -100.00,
        "account_name": "Checking",
        "payee_name": "Landlord",
        "category_name": "Rent",
        "subtransactions": []
      }
    ],
    "server_knowledge": 1234
  }
}
```

### ScheduledTransactionDetail Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | uuid | Scheduled transaction ID |
| `date_first` | date | First scheduled date |
| `date_next` | date | Next scheduled date |
| `frequency` | string | `never`, `daily`, `weekly`, `everyOtherWeek`, `twiceAMonth`, `every4Weeks`, `monthly`, `everyOtherMonth`, `every3Months`, `every4Months`, `twiceAYear`, `yearly`, `everyOtherYear` |
| `amount` | int64 | Amount in milliunits |
| `memo` | string or null | Memo |
| `flag_color` | string or null | Flag color |
| `account_id` | uuid | Account ID |
| `account_name` | string | Account name |
| `payee_id` | uuid or null | Payee ID |
| `payee_name` | string or null | Payee name |
| `category_id` | uuid or null | Category ID |
| `category_name` | string or null | Category name |
| `transfer_account_id` | uuid or null | Transfer target account |
| `deleted` | boolean | Whether deleted |
| `subtransactions` | array | Split subtransactions |
