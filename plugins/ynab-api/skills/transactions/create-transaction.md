# POST /plans/{plan_id}/transactions - Create Transaction(s)

Creates a single transaction or multiple transactions. Scheduled transactions (future dates) cannot be created here.

## Curl Command

### Single Transaction

```bash
# Save request body to file, then:
./scripts/ynab-curl POST "/plans/${PLAN_ID}/transactions" /tmp/body.json > /tmp/response.json
```

### Multiple Transactions

```bash
# Save request body to file, then:
./scripts/ynab-curl POST "/plans/${PLAN_ID}/transactions" /tmp/body.json > /tmp/response.json
```

### Split Transaction

```bash
# Save request body to file, then:
./scripts/ynab-curl POST "/plans/${PLAN_ID}/transactions" /tmp/body.json > /tmp/response.json
```

## Input

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `plan_id` | string | Yes | Plan ID |

**Request Body** (provide `transaction` OR `transactions`, not both):

```json
{
  "transaction": { NewTransaction },
  "transactions": [ NewTransaction, ... ]
}
```

### NewTransaction Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `account_id` | uuid | No* | Account ID (*required for useful transaction) |
| `date` | date | No* | ISO date. Must not be in the future. |
| `amount` | int64 | No* | Amount in milliunits (negative = outflow, positive = inflow) |
| `payee_id` | uuid or null | No | Payee ID. For transfers, use the target account's `transfer_payee_id`. |
| `payee_name` | string or null | No | Payee name (max 200). Used to resolve payee if `payee_id` is null. |
| `category_id` | uuid or null | No | Category ID. Set to null for splits (provide `subtransactions`). |
| `memo` | string or null | No | Memo (max 500) |
| `cleared` | string | No | `"cleared"`, `"uncleared"`, or `"reconciled"` |
| `approved` | boolean | No | Default: false (unapproved) |
| `flag_color` | string or null | No | `red`, `orange`, `yellow`, `green`, `blue`, `purple` |
| `import_id` | string or null | No | Import ID (max 36). Format: `YNAB:[milliunit_amount]:[iso_date]:[occurrence]` |
| `subtransactions` | array | No | Split subtransactions |

### SaveSubTransaction Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `amount` | int64 | Yes | Amount in milliunits |
| `payee_id` | uuid or null | No | Payee ID |
| `payee_name` | string or null | No | Payee name (max 200) |
| `category_id` | uuid or null | No | Category ID |
| `memo` | string or null | No | Memo (max 500) |

## Response (201)

```json
{
  "data": {
    "transaction_ids": ["string"],
    "transaction": { TransactionDetail },
    "transactions": [ TransactionDetail, ... ],
    "duplicate_import_ids": ["string"],
    "server_knowledge": 1234
  }
}
```

| Field | Type | Description |
|-------|------|-------------|
| `transaction_ids` | array[string] | IDs of created transactions |
| `transaction` | TransactionDetail | Single transaction (if single create) |
| `transactions` | array[TransactionDetail] | Multiple transactions (if bulk create) |
| `duplicate_import_ids` | array[string] | Import IDs that already existed on the account |
| `server_knowledge` | int64 | Server knowledge value |
