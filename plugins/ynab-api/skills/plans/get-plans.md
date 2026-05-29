# GET /plans - Get All Plans

Returns plans list with summary information.

## Curl Command

```bash
./scripts/ynab-curl GET "/plans?include_accounts=true" > /tmp/response.json
```

## Input

**Query Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `include_accounts` | boolean | No | Whether to include the list of plan accounts |

**Request Body:** None

## Response (200)

```json
{
  "data": {
    "plans": [
      {
        "id": "uuid",
        "name": "string",
        "last_modified_on": "datetime",
        "first_month": "date",
        "last_month": "date",
        "date_format": {
          "format": "string"
        },
        "currency_format": {
          "iso_code": "string",
          "example_format": "string",
          "decimal_digits": 2,
          "decimal_separator": ".",
          "symbol_first": true,
          "group_separator": ",",
          "currency_symbol": "$",
          "display_symbol": true
        },
        "accounts": []
      }
    ],
    "default_plan": null
  }
}
```

### Response Fields

| Field | Type | Description |
|-------|------|-------------|
| `data.plans` | array[PlanSummary] | List of plans |
| `data.default_plan` | PlanSummary or null | The default plan, if configured |

### PlanSummary

| Field | Type | Description |
|-------|------|-------------|
| `id` | string (uuid) | Plan ID |
| `name` | string | Plan name |
| `last_modified_on` | datetime | Last modification time |
| `first_month` | date | Earliest plan month |
| `last_month` | date | Latest plan month |
| `date_format` | DateFormat or null | Date format setting |
| `currency_format` | CurrencyFormat or null | Currency format setting |
| `accounts` | array[Account] | Accounts (only if `include_accounts=true`) |
