#!/usr/bin/env python3
"""Run the matcher against real YNAB data and print results.

Reads /tmp/transactions.json (a YNAB GET /transactions response). For every
uncleared transaction, searches that transaction's account for a cleared
match using matcher.find_match. Read-only — no API writes.
"""
import json
import sys
from datetime import date, datetime

from ynab_api.matcher import match_score, find_match, MATCH_THRESHOLD


def parse_date(s: str) -> date:
    return datetime.strptime(s, "%Y-%m-%d").date()


def normalize(t: dict) -> dict:
    return {
        "id": t["id"],
        "date": parse_date(t["date"]),
        "amount": t["amount"],
        "payee_name": t.get("payee_name") or "",
        "account_id": t["account_id"],
        "account_name": t.get("account_name") or "",
        "memo": t.get("memo") or "",
        "cleared": t["cleared"],
    }


def fmt_amount(milli: int) -> str:
    return f"${milli / 1000:>10,.2f}"


def fmt_txn(t: dict) -> str:
    return (
        f"{t['date']}  {fmt_amount(t['amount'])}  "
        f"{t['payee_name'][:35]:35}  [{t['account_name']}]"
    )


def main() -> int:
    with open("/tmp/transactions.json") as f:
        data = json.load(f)

    txns = [normalize(t) for t in data["data"]["transactions"]]
    uncleared = [t for t in txns if t["cleared"] == "uncleared"]
    cleared = [t for t in txns if t["cleared"] == "cleared"]

    print(f"\n{'=' * 80}")
    print(f"  {len(uncleared)} uncleared transactions  |  {len(cleared)} cleared candidates")
    print(f"  Threshold: {MATCH_THRESHOLD}")
    print(f"{'=' * 80}\n")

    matched = 0
    unmatched = 0

    for u in uncleared:
        same_account = [c for c in cleared if c["account_id"] == u["account_id"]]
        match = find_match(u, same_account)

        print(f"UNCLEARED  {fmt_txn(u)}")
        if match:
            score = match_score(u, match)
            print(f"  → MATCH   {fmt_txn(match)}")
            print(f"            score={score:.3f}")
            matched += 1
        else:
            top3 = sorted(
                ((c, match_score(u, c)) for c in same_account),
                key=lambda x: x[1],
                reverse=True,
            )[:3]
            print(f"  → no match (top candidates by score):")
            for c, s in top3:
                if s == 0:
                    continue
                print(f"      {s:.3f}  {fmt_txn(c)}")
            if not any(s > 0 for _, s in top3):
                print(f"      (no candidate scored above zero)")
            unmatched += 1
        print()

    print(f"{'=' * 80}")
    print(f"  Matched: {matched}  |  Unmatched: {unmatched}")
    print(f"{'=' * 80}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
