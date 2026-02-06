import json
import os
import time
import urllib.request
import urllib.parse
import sys

# Configuration
CONFIG_PATH = os.path.expanduser("~/.config/opencode/antigravity-accounts.json")
CLIENT_ID = "1071006060591-tmhssin2h21lcre235vtolojh4g403ep.apps.googleusercontent.com"
CLIENT_SECRET = "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"
TOKEN_URL = "https://oauth2.googleapis.com/token"


def get_access_token():
    # 1. Read the refresh token
    if not os.path.exists(CONFIG_PATH):
        print(f"Error: Config file not found at {CONFIG_PATH}", file=sys.stderr)
        sys.exit(1)

    try:
        with open(CONFIG_PATH, "r") as f:
            data = json.load(f)

        # Assuming the first account is the one we want, or the active one
        accounts = data.get("accounts", [])
        if not accounts:
            print("Error: No accounts found in config", file=sys.stderr)
            sys.exit(1)

        # Use active index if available
        active_index = data.get("activeIndex", 0)
        if active_index < 0 or active_index >= len(accounts):
            active_index = 0

        refresh_token = accounts[active_index].get("refreshToken")
        if not refresh_token:
            print("Error: No refresh token found", file=sys.stderr)
            sys.exit(1)

    except Exception as e:
        print(f"Error reading config: {e}", file=sys.stderr)
        sys.exit(1)

    # 2. Refresh the token
    payload = {
        "client_id": CLIENT_ID,
        "client_secret": CLIENT_SECRET,
        "refresh_token": refresh_token,
        "grant_type": "refresh_token",
    }

    data = urllib.parse.urlencode(payload).encode()
    req = urllib.request.Request(TOKEN_URL, data=data)

    try:
        with urllib.request.urlopen(req) as response:
            if response.status != 200:
                print(
                    f"Error refreshing token: HTTP {response.status}", file=sys.stderr
                )
                sys.exit(1)

            response_data = json.loads(response.read().decode())
            access_token = response_data.get("access_token")
            if not access_token:
                print("Error: No access token in response", file=sys.stderr)
                sys.exit(1)

            print(access_token)

    except Exception as e:
        print(f"Error making request: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    get_access_token()
