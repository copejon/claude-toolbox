# GET /plans/{plan_id}/transactions - Get All Transactions

Returns plan transactions, excluding any pending transactions.

## Curl Command

```bash
./scripts/ynab-curl GET "/plans/${PLAN_ID}/transactions" > /tmp/response.json
```

## Input

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `plan_id` | string | Yes | Plan ID |

**Query Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `since_date` | date | No | Only transactions on or after this date (ISO format) |
| `type` | string | No | `"uncategorized"` or `"unapproved"` |
| `last_knowledge_of_server` | int64 | No | Only return entities changed since this value |

**Request Body:** None

## Response (200)

```json
{
  "data": {
    "transactions": [
      {
        "id": "string",
        "date": "2024-01-15",
        "amount": -50000,
        "memo": "Weekly groceries",
        "cleared": "cleared",
        "approved": true,
        "flag_color": null,
        "flag_name": null,
        "account_id": "uuid",
        "payee_id": "uuid",
        "category_id": "uuid",
        "transfer_account_id": null,
        "transfer_transaction_id": null,
        "matched_transaction_id": null,
        "import_id": null,
        "import_payee_name": null,
        "import_payee_name_original": null,
        "debt_transaction_type": null,
        "deleted": false,
        "amount_formatted": "-$50.00",
        "amount_currency": -50.00,
        "account_name": "Checking",
        "payee_name": "Grocery Store",
        "category_name": "Groceries",
        "subtransactions": []
      }
    ],
    "server_knowledge": 1234
  }
}
```

### TransactionDetail Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | string | Transaction ID |
| `date` | date | Transaction date |
| `amount` | int64 | Amount in milliunits (negative = outflow) |
| `memo` | string or null | Memo |
| `cleared` | string | `"cleared"`, `"uncleared"`, or `"reconciled"` |
| `approved` | boolean | Whether approved |
| `flag_color` | string or null | `red`, `orange`, `yellow`, `green`, `blue`, `purple`, or null |
| `flag_name` | string or null | Custom flag name |
| `account_id` | uuid | Account ID |
| `account_name` | string | Account name |
| `payee_id` | uuid or null | Payee ID |
| `payee_name` | string or null | Payee name |
| `category_id` | uuid or null | Category ID |
| `category_name` | string or null | Category name ("Split" for splits) |
| `transfer_account_id` | uuid or null | If transfer, target account |
| `transfer_transaction_id` | string or null | If transfer, other side's transaction ID |
| `matched_transaction_id` | string or null | Matched transaction ID |
| `import_id` | string or null | Import identifier |
| `import_payee_name` | string or null | Original import payee name (after rename rules) |
| `import_payee_name_original` | string or null | Original statement payee name |
| `debt_transaction_type` | string or null | `payment`, `refund`, `fee`, `interest`, `escrow`, `balanceAdjustment`, `credit`, `charge` |
| `deleted` | boolean | Whether deleted |
| `subtransactions` | array[SubTransaction] | Split subtransactions |

### SubTransaction Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | string | Subtransaction ID |
| `transaction_id` | string | Parent transaction ID |
| `amount` | int64 | Amount in milliunits |
| `memo` | string or null | Memo |
| `payee_id` | uuid or null | Payee ID |
| `payee_name` | string or null | Payee name |
| `category_id` | uuid or null | Category ID |
| `category_name` | string or null | Category name |
| `transfer_account_id` | uuid or null | Transfer target account |
| `transfer_transaction_id` | string or null | Other side's transaction ID |
| `deleted` | boolean | Whether deleted |
