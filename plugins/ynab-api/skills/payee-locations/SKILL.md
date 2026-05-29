---
name: ynab-payee-locations
description: Look up YNAB payee GPS locations — list all, get by ID, or list by payee.
user-invocable: false
---

YNAB Payee Location operations. Reference the endpoint files in this directory for curl commands, input specs, and response schemas:

- [get-payee-locations.md](get-payee-locations.md) — GET /plans/{plan_id}/payee_locations
- [get-payee-location-by-id.md](get-payee-location-by-id.md) — GET /plans/{plan_id}/payee_locations/{payee_location_id}
- [get-payee-locations-by-payee.md](get-payee-locations-by-payee.md) — GET /plans/{plan_id}/payees/{payee_id}/payee_locations
