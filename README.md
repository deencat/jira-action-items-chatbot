# Jira Action Items Chatbot

Jira Action Items Chatbot is a Microsoft Edge extension that helps you work with Jira issues through a lightweight chatbot workflow.

## Project Status

This repository currently contains the browser extension codebase and supporting task-management assets.

- Active app: Edge extension in `extension/`
- Backend: expected as an external service endpoint (default: `http://localhost:8000`)
- Task Master docs: `README-task-master.md`

## Quick Start

1. Install dependencies:

```bash
npm run install:all
```

2. Build the extension:

```bash
npm run build
```

3. Load into Edge:

- Open `edge://extensions/`
- Enable **Developer mode**
- Click **Load unpacked**
- Select `extension/dist`

## Development

Run extension watch build:

```bash
npm run dev
```

The generated files are emitted to `extension/dist`.

## Testing

Run extension tests:

```bash
npm test
```

Current tests validate extension packaging contracts such as manifest/script paths.

## Configuration

The extension background worker stores runtime settings in `chrome.storage.local`.

Important keys:

- `serverUrl`: API base URL (default `http://localhost:8000`)
- `notificationsEnabled`: enables reminder polling
- `isAuthenticated`: auth state cache
- `lastJiraContext`: latest issue context captured from Jira tab

## Packaging

Create a zip package for store submission:

```bash
npm run pack:extension
```

This outputs `jira-action-items-chatbot.zip` in the repository root.

## Repository Scripts

Top-level scripts proxy to `extension/`:

- `npm run build`
- `npm run dev`
- `npm run test`
- `npm run extension:build`
- `npm run extension:dev`
- `npm run extension:test`

## License

MIT. See `LICENSE`.
