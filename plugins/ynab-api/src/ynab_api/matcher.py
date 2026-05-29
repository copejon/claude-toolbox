from datetime import date
from difflib import SequenceMatcher

DATE_WINDOW = 5        # days either side
AMOUNT_TOLERANCE = 0.15  # fraction of the larger amount
PAYEE_MIN = 0.3        # below this, payee is too different to bother
MATCH_THRESHOLD = 0.6

WEIGHT_PAYEE = 0.5
WEIGHT_AMOUNT = 0.3
WEIGHT_DATE = 0.2


def date_score(d1: date, d2: date, window: int = DATE_WINDOW) -> float:
    diff = abs((d1 - d2).days)
    if diff >= window:
        return 0.0
    return 1.0 - diff / window


def amount_score(a1: int, a2: int, tolerance: float = AMOUNT_TOLERANCE) -> float:
    if a1 == 0 and a2 == 0:
        return 1.0
    if a1 == 0 or a2 == 0:
        return 0.0
    if (a1 > 0) != (a2 > 0):
        return 0.0
    diff = abs(a1 - a2) / max(abs(a1), abs(a2))
    if diff >= tolerance:
        return 0.0
    return 1.0 - diff / tolerance


def payee_score(p1: str, p2: str) -> float:
    if not p1 or not p2:
        return 0.0
    return SequenceMatcher(None, p1.lower(), p2.lower()).ratio()


def match_score(t1: dict, t2: dict) -> float:
    p = payee_score(t1.get("payee_name", ""), t2.get("payee_name", ""))
    if p < PAYEE_MIN:
        return 0.0
    a = amount_score(t1["amount"], t2["amount"])
    if a == 0.0:
        return 0.0
    d = date_score(t1["date"], t2["date"])
    return WEIGHT_PAYEE * p + WEIGHT_AMOUNT * a + WEIGHT_DATE * d


def find_match(
    uncleared: dict,
    candidates: list[dict],
    threshold: float = MATCH_THRESHOLD,
) -> dict | None:
    if not candidates:
        return None
    scored = [(c, match_score(uncleared, c)) for c in candidates]
    best, score = max(scored, key=lambda x: x[1])
    return best if score >= threshold else None
