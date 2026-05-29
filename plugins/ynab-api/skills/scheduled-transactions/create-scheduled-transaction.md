# POST /plans/{plan_id}/scheduled_transactions - Create a Scheduled Transaction

Creates a single scheduled transaction (a transaction with a future date).

## Curl Command

```bash
# Save request body to file, then:
./scripts/ynab-curl POST "/plans/${PLAN_ID}/scheduled_transactions" /tmp/body.json > /tmp/response.json
```

## Input

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `plan_id` | string | Yes | Plan ID |

**Request Body:**

```json
{
  "scheduled_transaction": {
    "account_id": "uuid (required)",
    "date": "date (required)",
    "amount": 0,
    "payee_id": "uuid or null",
    "payee_name": "string or null",
    "category_id": "uuid or null",
    "memo": "string or null",
    "flag_color": "string or null",
    "frequency": "string"
  }
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `account_id` | uuid | Yes | Account ID |
| `date` | date | Yes | Future date, no more than 5 years out (ISO format) |
| `amount` | int64 | No | Amount in milliunits |
| `payee_id` | uuid or null | No | Payee ID. For transfers, use target account's `transfer_payee_id`. |
| `payee_name` | string or null | No | Payee name (max 200). Resolves to existing or creates new payee. |
| `category_id` | uuid or null | No | Category ID. Credit Card Payment categories not permitted. |
| `memo` | string or null | No | Memo (max 500) |
| `flag_color` | string or null | No | `red`, `orange`, `yellow`, `green`, `blue`, `purple` |
| `frequency` | ScheduledTransactionFrequency | No | `never`, `daily`, `weekly`, `everyOtherWeek`, `twiceAMonth`, `every4Weeks`, `monthly`, `everyOtherMonth`, `every3Months`, `every4Months`, `twiceAYear`, `yearly`, `everyOtherYear` |

## Response (201)

```json
{
  "data": {
    "scheduled_transaction": { ScheduledTransactionDetail }
  }
}
```
