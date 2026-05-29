# GET /user - Get User

Returns authenticated user information.

## Curl Command

```bash
./scripts/ynab-curl GET "/user" > /tmp/response.json
```

## Input

**Parameters:** None

**Request Body:** None

## Response (200)

```json
{
  "data": {
    "user": {
      "id": "uuid"
    }
  }
}
```

### Response Fields

| Field | Type | Description |
|-------|------|-------------|
| `data.user.id` | string (uuid) | The user's unique identifier |
