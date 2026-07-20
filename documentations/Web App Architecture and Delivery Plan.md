# Web App Architecture and Delivery Plan

## Goal

Replace the extension-first workflow with a web app that helps a project manager turn raw inputs into approved Jira action items and then keeps following up until the items close.

## Product Flow

1. User uploads files, pastes text, or drops in meeting notes.
2. The app extracts candidate action items and drafts them for review.
3. The user approves all items or approves them individually.
4. Approved items are created as Jira issues.
5. A background agent monitors issue status and follow-up cadence.
6. The agent sends follow-up prompts through Teams or a fallback channel until the issue is closed.

## Recommended System Design

### Frontend

- Web app built for document intake, preview, and approval.
- Main views:
  - intake workspace
  - draft review queue
  - Jira creation summary
  - follow-up timeline
  - configuration page for Jira and Teams

### Backend

- API server for parsing documents, drafting action items, and creating Jira issues.
- Job worker or scheduler for periodic follow-up checks.
- Persistent store for:
  - source documents
  - extracted candidates
  - approvals
  - created Jira issue IDs
  - follow-up history
  - escalation state

### AI / Agent Layer

- Draft action items from raw content.
- Normalize assignees, dates, and due dates.
- Decide follow-up timing based on issue age, status, and escalation policy.
- Improve prompts from feedback loops such as user edits and approved drafts.

## Teams Follow-Up Strategy

### Preferred Option

Use Microsoft Graph or a Teams bot for proactive follow-up messages.

Why:

- more stable than driving the Teams UI
- works unattended
- easier to audit and troubleshoot
- better support for message templates and replies

### What to Send

- short reminder message
- Jira issue reference
- current status
- next requested action
- due date or escalation note

### Recommended Reply Handling

- `done`
- `blocked`
- `need more time`
- `please remind me tomorrow`

These replies should map back into Jira comments, status updates, or a scheduled reminder.

### Fallbacks

If Teams permissions are not available in the tenant:

- email follow-up
- copy-ready manual message
- Slack or other enterprise channel if present

## Data Model

- `documents`
  - uploaded source files and pasted text
- `draft_action_items`
  - extracted candidate items before approval
- `approved_action_items`
  - user-approved work items waiting for Jira creation
- `jira_issues`
  - created Jira issue IDs and metadata
- `follow_up_events`
  - outbound reminders and replies
- `identity_mappings`
  - assignee mapping between Jira, email, and Teams identity

## Minimal MVP Scope

1. Upload or paste source content.
2. Extract and preview action items.
3. Approve items individually or in bulk.
4. Create Jira issues.
5. Store issue state and follow-up schedule.
6. Send one follow-up channel message per item using the simplest approved integration.

## Phase 2 Scope

- document OCR and spreadsheet parsing
- better assignee resolution
- follow-up escalation rules
- reply interpretation from Teams
- dashboards for pending items and overdue issues

## Phase 3 Scope

- adaptive prompting based on user edits
- automatic prioritization from historical patterns
- analytics for recurring blockers
- richer templates for project managers

## Implementation Notes

- Do not depend on browser UI automation for unattended messaging.
- Treat Jira as the system of record for issue state.
- Keep Teams identity mapping explicit and configurable.
- Build approval gating before Jira creation so the AI cannot create issues without user review.
