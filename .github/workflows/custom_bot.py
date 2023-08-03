import os
import requests

GITHUB_API_URL = "https://api.github.com"
BOT_TOKEN = os.environ.get("BOT_TOKEN")  # Set your GitHub access token as an environment variable

def check_issue_reference(repo_full_name, pr_number):
    url = f"{GITHUB_API_URL}/repos/{repo_full_name}/pulls/{pr_number}/commits"
    headers = {"Authorization": f"token {BOT_TOKEN}"}
    response = requests.get(url, headers=headers)
    commits = response.json()

    for commit in commits:
        if "message" in commit["commit"] and "issue #" in commit["commit"]["message"].lower():
            return True

    return False

if __name__ == "__main__":
    # You can add code to parse command-line arguments, receive input, etc.
    repo_full_name = "your-username/your-repo"
    pr_number = 1  # Replace with the actual PR number

    has_issue_reference = check_issue_reference(repo_full_name, pr_number)
    print(has_issue_reference)
