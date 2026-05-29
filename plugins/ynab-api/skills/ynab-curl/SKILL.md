---
name: ynab-curl
description: Make YNAB API calls using the ynab-curl wrapper script. Use this for all YNAB API requests instead of raw curl commands.
allowed-tools: Bash(./scripts/ynab-curl *)
---

Use the `ynab-curl` wrapper script to make YNAB API calls. This script handles authentication and base URL automatically.

## Usage

```bash
# GET request — redirect output to file
./scripts/ynab-curl GET /plans/last-used/transactions?since_date=2026-01-01 > /tmp/output.json

# POST request with JSON body file
./scripts/ynab-curl POST /plans/last-used/transactions /tmp/body.json > /tmp/result.json

# PATCH/PUT/DELETE
./scripts/ynab-curl PATCH /plans/last-used/categories/CATEGORY_ID /tmp/update.json > /tmp/result.json
./scripts/ynab-curl DELETE /plans/last-used/transactions/TRANSACTION_ID > /tmp/result.json
```

## Rules

- Always redirect output to a file (no pipes)
- Use `jq` to process the saved output file
- The script verifies YNAB_TOKEN is set and exits with an error if missing
- Paths are relative to the YNAB API v1 base URL (`https://api.ynab.com/v1`)
