#!/usr/bin/env python3
"""Send an org-sync report via Gmail SMTP."""

import argparse
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from pathlib import Path


def send(*, sender: str, to: str, subject: str, body: str, password: str) -> None:
    msg = MIMEMultipart("alternative")
    msg["From"] = sender
    msg["To"] = to
    msg["Subject"] = subject

    msg.attach(MIMEText(body, "plain"))

    # Try to render HTML from markdown if the package is available
    try:
        import markdown
        html = markdown.markdown(body, extensions=["tables", "fenced_code"])
        msg.attach(MIMEText(html, "html"))
    except ImportError:
        pass

    with smtplib.SMTP_SSL("smtp.gmail.com", 465) as server:
        server.login(sender, password)
        server.sendmail(sender, to, msg.as_string())


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Send org-sync email report")
    parser.add_argument("--from", dest="sender", required=True)
    parser.add_argument("--to", required=True)
    parser.add_argument("--subject", required=True)
    parser.add_argument("--body-file", required=True)
    parser.add_argument("--password", required=True)
    args = parser.parse_args()

    body = Path(args.body_file).read_text()
    send(sender=args.sender, to=args.to, subject=args.subject, body=body, password=args.password)
