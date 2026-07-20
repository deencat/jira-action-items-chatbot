# Jira Action Items Chatbot

Jira Action Items Chatbot is being transitioned from an Edge extension concept to a web app that drafts, approves, creates, and follows up on Jira action items.

## Current Direction

The target product is a web app with:

- document upload and paste-in intake for PDFs, Excel, and text
- action-item drafting with preview and approval
- Jira issue creation after approval
- scheduled follow-up until issues are closed
- Teams-based follow-up where supported, preferably through Microsoft Graph or a bot rather than browser automation

## What This Repository Contains

- Historical Edge extension code under `extension/`
- Task-management and planning docs
- New architecture and rollout notes in `documentations/Web App Architecture and Delivery Plan.md`

## Recommended Next Read

Start with [documentations/Web App Architecture and Delivery Plan.md](documentations/Web%20App%20Architecture%20and%20Delivery%20Plan.md).

## Notes

- Teams UI automation is not the recommended integration path for unattended follow-up.
- If Microsoft Graph or a Teams bot is not available in your tenant, the follow-up channel should fall back to email or manual copy-ready prompts.

## License

MIT. See `LICENSE`.
