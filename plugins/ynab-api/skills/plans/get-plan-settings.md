# GET /plans/{plan_id}/settings - Get Plan Settings

Returns settings for a plan.

## Curl Command

```bash
./scripts/ynab-curl GET "/plans/${PLAN_ID}/settings" > /tmp/response.json
```

## Input

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `plan_id` | string | Yes | Plan ID. Use `"last-used"` or `"default"`. |

**Request Body:** None

## Response (200)

```json
{
  "data": {
    "settings": {
      "date_format": {
        "format": "MM/DD/YYYY"
      },
      "currency_format": {
        "iso_code": "USD",
        "example_format": "123,456.78",
        "decimal_digits": 2,
        "decimal_separator": ".",
        "symbol_first": true,
        "group_separator": ",",
        "currency_symbol": "$",
        "display_symbol": true
      }
    }
  }
}
```

### Response Fields

| Field | Type | Description |
|-------|------|-------------|
| `data.settings.date_format` | DateFormat or null | Date format setting |
| `data.settings.currency_format` | CurrencyFormat or null | Currency format setting |
