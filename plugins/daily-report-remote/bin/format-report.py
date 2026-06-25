#!/usr/bin/env python3
"""format-report.py — Deterministic daily report formatter.

Reads the JSON output from collect-daily-data.sh and produces a Slack-ready
daily report plus a suggestions file for items discovered in git but not
reflected in the TODO file.

Usage: format-report.py <json-file> <report-file> <suggestions-file>
"""
import json
import re
import sys
from collections import defaultdict

JIRA_URL = "https://redhat.atlassian.net/browse"
TICKET_RE = re.compile(r"\b([A-Z][A-Z0-9]+-\d+)\b")
COMPLETED_RE = re.compile(r"^- \[x\]\s+(.*)", re.MULTILINE)
IN_PROGRESS_RE = re.compile(r"^- \[ \]\s+(.*)", re.MULTILINE)
BLOCKER_RE = re.compile(r"\[(?:blocker|blocked)\]", re.IGNORECASE)


def extract_tickets(text):
    return TICKET_RE.findall(text)


def format_ticket_urls(tickets):
    return ", ".join(f"{JIRA_URL}/{t}" for t in tickets)


def format_bullet(emoji, description, tickets=None):
    if tickets:
        ticket_str = ", ".join(tickets)
        urls = format_ticket_urls(tickets)
        return f"{emoji} {ticket_str}: {description} ({urls})"
    return f"{emoji} {description}"


def parse_todo(todo_data):
    completed = []
    in_progress = []
    blocked = []

    if not todo_data.get("exists") or not todo_data.get("content"):
        return completed, in_progress, blocked

    content = todo_data["content"]
    sections = re.split(r"^##\s+", content, flags=re.MULTILINE)

    for section in sections:
        lines = section.strip().split("\n")
        section_title = lines[0].strip().lower() if lines else ""

        for line in lines:
            line = line.strip()

            completed_match = re.match(r"^- \[x\]\s+(.*)", line)
            if completed_match:
                desc = completed_match.group(1).strip()
                tickets = extract_tickets(desc)
                desc = TICKET_RE.sub("", desc).strip().strip(":").strip()
                if BLOCKER_RE.search(desc):
                    blocked.append((desc, tickets))
                else:
                    completed.append((desc, tickets))
                continue

            ip_match = re.match(r"^- \[ \]\s+(.*)", line)
            if ip_match:
                desc = ip_match.group(1).strip()
                tickets = extract_tickets(desc)
                desc = TICKET_RE.sub("", desc).strip().strip(":").strip()
                if BLOCKER_RE.search(desc):
                    blocked.append((desc, tickets))
                elif "block" in section_title or "wait" in section_title:
                    blocked.append((desc, tickets))
                else:
                    in_progress.append((desc, tickets))

    return completed, in_progress, blocked


def consolidate_by_ticket(items):
    """Group items that share the same Jira ticket into single bullets."""
    ticket_groups = defaultdict(list)
    no_ticket = []

    for desc, tickets in items:
        if tickets:
            key = tuple(sorted(tickets))
            ticket_groups[key].append(desc)
        else:
            no_ticket.append((desc, tickets))

    consolidated = []
    for tickets, descs in ticket_groups.items():
        combined = "; ".join(d for d in descs if d)
        if not combined:
            combined = "Work on " + ", ".join(tickets)
        consolidated.append((combined, list(tickets)))

    consolidated.extend(no_ticket)
    return consolidated


def find_uncaptured_commits(git_logs, todo_tickets):
    """Find commits whose tickets aren't in the TODO file."""
    suggestions = []
    for repo in git_logs:
        repo_name = repo.get("name", "unknown")
        for commit in repo.get("commits", []):
            subject = commit.get("subject", "")
            commit_tickets = extract_tickets(subject)
            if commit_tickets and not any(t in todo_tickets for t in commit_tickets):
                suggestions.append({
                    "repo": repo_name,
                    "branch": commit.get("branch", ""),
                    "hash": commit.get("hash", ""),
                    "subject": subject,
                    "tickets": commit_tickets,
                })
    return suggestions


def main():
    if len(sys.argv) != 4:
        print("Usage: format-report.py <json-file> <report-file> <suggestions-file>",
              file=sys.stderr)
        sys.exit(1)

    json_file, report_file, suggestions_file = sys.argv[1], sys.argv[2], sys.argv[3]

    with open(json_file) as f:
        data = json.load(f)

    todo = data.get("todo", {})
    git_logs = data.get("git_logs", [])

    completed, in_progress, blocked = parse_todo(todo)

    completed = consolidate_by_ticket(completed)
    in_progress = consolidate_by_ticket(in_progress)
    blocked = consolidate_by_ticket(blocked)

    all_todo_tickets = set()
    for _, tickets in completed + in_progress + blocked:
        all_todo_tickets.update(tickets)

    suggestions = find_uncaptured_commits(git_logs, all_todo_tickets)

    lines = ["Daily Report:", ""]
    for desc, tickets in completed:
        lines.append(format_bullet(":done-circle-check:", desc, tickets or None))
    for desc, tickets in in_progress:
        lines.append(format_bullet(":in-progress:", desc, tickets or None))
    for desc, tickets in blocked:
        lines.append(format_bullet(":jira-blocker:", desc, tickets or None))

    if not completed and not in_progress and not blocked:
        lines.append(":in-progress: No items found in TODO file for this date")

    report = "\n".join(lines) + "\n"
    with open(report_file, "w") as f:
        f.write(report)

    if suggestions:
        sug_lines = ["Uncaptured commits (in git but not in TODO):", ""]
        for s in suggestions:
            subject = s["subject"]
            for t in s["tickets"]:
                subject = subject.replace(f"{t}: ", "").replace(f"{t} ", "")
            ticket_str = ", ".join(s["tickets"])
            sug_lines.append(
                f"- {ticket_str}: {subject.strip()} "
                f"({s['repo']}:{s['branch']} {s['hash']})"
            )
        with open(suggestions_file, "w") as f:
            f.write("\n".join(sug_lines) + "\n")
    else:
        with open(suggestions_file, "w") as f:
            f.write("")


if __name__ == "__main__":
    main()
