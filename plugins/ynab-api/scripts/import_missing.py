#!/usr/bin/env python3
"""Import missing transactions from bank CSV into YNAB checking account."""

import csv
import json
import re
from collections import defaultdict

ACCOUNT_ID = "b55f8319-91d6-4cd2-98a9-c6bd6113af60"
CSV_PATH = "C:/Users/copej/Downloads/bk_download.csv"
EXISTING_TXNS_PATH = "C:/Users/copej/AppData/Local/Temp/existing_txns.json"
OUTPUT_PATH = "C:/Users/copej/AppData/Local/Temp/import_body.json"

PAYEE_NORMALIZE = [
    (r"(?i)^HEB CURBSIDE", "H-E-B"),
    (r"(?i)^HEB ", "H-E-B"),
    (r"(?i)^AMAZON MKTPLACE", "Amazon"),
    (r"(?i)^STAATS PSYCHIATRIC", "Staats Psychiatric"),
    (r"(?i)^DDBR\b", "Dunkin' & Baskin-Robbins"),
    (r"(?i)^OURFAMILYWIZARD", "OurFamilyWizard"),
    (r"(?i)^VERIZON", "Verizon Wireless"),
    (r"(?i)^CVS", "CVS Pharmacy"),
    (r"(?i)IC\*.*INSTACAR", "Instacart"),
    (r"(?i)INSTACART", "Instacart"),
    (r"(?i)MERCY WELLNESS", "Mercy Wellness LLC"),
    (r"(?i)SLIM CHICKENS", "Slim Chickens"),
    (r"(?i)MENCHIE", "Menchie's Frozen Yogurt"),
    (r"(?i)^WAL-MART|^WALMART", "Walmart"),
    (r"(?i)^U-HAUL", "U-Haul"),
]

PAYEE_CATEGORY = {
    "Headway":                  "158df017-ba95-4ed2-8359-b9512f595222",
    "Netflix":                  "7e89d38f-c239-45b1-9af6-c09cc94efc69",
    "AT&T":                     "15159012-26ae-40ea-ba8b-e02da3ee457a",
    "YouTube Music":            "f3a68d8d-6a88-4cd1-af6a-d716175e591c",
    "Amazon":                   "f5cec231-a264-4acd-a5fe-c5a25eb05b9f",
    "Prime Video":              "34144708-6120-487a-901a-351bc1573a60",
    "Steam":                    "74922968-c2ab-40b4-a92e-040e605a89b6",
    "Roblox":                   "fa58c037-0073-4422-b3ac-0d5edcdf472b",
    "H-E-B":                    "56721cbc-b695-48b1-841c-77d149c9ad1e",
    "CVS Pharmacy":             "0a279c73-a8f6-4f19-be3b-17cb93cf0051",
    "Uber Eats":                "a0998723-1acd-4dda-a5f1-a55aad14512f",
    "PennyMac":                 "a77f7f81-fb4e-411a-a9e3-177c9a6cb20e",
    "Appliance Warehouse":      "893efcfc-75dc-41fa-8b8b-4f81c2b55ca7",
    "OurFamilyWizard":          "a9c239a1-fc91-4f88-b988-3e975eb7dc66",
    "Verizon Wireless":         "2f8a9028-29d6-4870-996f-12f71b30a49c",
    "Disney+":                  "7e89d38f-c239-45b1-9af6-c09cc94efc69",
    "Institute of Orthopaedi":  "d299c41b-cada-4286-afcd-ac49e0674abb",
    "Mercy Wellness LLC":       "d299c41b-cada-4286-afcd-ac49e0674abb",
    "Slim Chickens":            "ce34161b-5460-4202-84cb-191bce7e27c7",
    "Walmart":                  "56721cbc-b695-48b1-841c-77d149c9ad1e",
    "U-Haul":                   "5c0aa9a2-5675-4336-ae9a-a29bfdaa2197",
    "Instacart":                "56721cbc-b695-48b1-841c-77d149c9ad1e",
    "Menchie's Frozen Yogurt":  "34144708-6120-487a-901a-351bc1573a60",
    "Dunkin' & Baskin-Robbins": "ce34161b-5460-4202-84cb-191bce7e27c7",
    "Staats Psychiatric":       "d299c41b-cada-4286-afcd-ac49e0674abb",
    "Red Hat Inc Payroll":      "7baa1952-b284-43e2-a442-a9dbe9e1008f",
}


def to_milliunits(amount_str):
    return round(float(amount_str) * 1000)


def normalize_payee(name):
    for pattern, replacement in PAYEE_NORMALIZE:
        if re.search(pattern, name):
            return replacement
    return name.strip()


def load_existing(path):
    with open(path) as f:
        data = json.load(f)
    result = defaultdict(list)
    for t in data["data"]["transactions"]:
        result[(t["date"], t["amount"])].append(t["payee_name"])
    return result


def load_csv(path):
    with open(path, newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f))


def main():
    existing = load_existing(EXISTING_TXNS_PATH)
    csv_rows = load_csv(CSV_PATH)

    remaining = {k: list(v) for k, v in existing.items()}

    missing = []
    for row in csv_rows:
        if re.search(r"(?i)CHASE CREDIT", row.get("Original Description", "")):
            continue
        key = (row["Date"], to_milliunits(row["Amount"]))
        if key in remaining and remaining[key]:
            remaining[key].pop()
            if not remaining[key]:
                del remaining[key]
        else:
            missing.append(row)

    print(f"Missing transactions to import: {len(missing)}\n")

    import_id_counter = defaultdict(int)
    transactions = []

    for row in missing:
        date = row["Date"]
        amt = to_milliunits(row["Amount"])
        payee = normalize_payee(row["Description"])
        cleared = "uncleared" if row["Status"] == "Pending" else "cleared"
        category_id = PAYEE_CATEGORY.get(payee)

        import_id_counter[(date, amt)] += 1
        import_id = f"YNAB:{amt}:{date}:{import_id_counter[(date, amt)]}"

        transactions.append({
            "account_id": ACCOUNT_ID,
            "date": date,
            "amount": amt,
            "payee_name": payee,
            "category_id": category_id,
            "cleared": cleared,
            "approved": False,
            "import_id": import_id,
        })

        cat = (category_id[:8] + "...") if category_id else "Uncategorized"
        print(f"  {date} | {payee:<42} | {amt/1000:>9.2f} | {cleared:<10} | {cat}")

    with open(OUTPUT_PATH, "w") as f:
        json.dump({"transactions": transactions}, f, indent=2)

    print(f"\nWrote {len(transactions)} transactions to {OUTPUT_PATH}")


if __name__ == "__main__":
    main()
