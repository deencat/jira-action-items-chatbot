const fs = require('fs');
const path = require('path');

describe('extension manifest', () => {
  test('uses Jira-only content script matches and valid popup path', () => {
    const manifestPath = path.join(__dirname, '..', 'manifest.json');
    const manifest = JSON.parse(fs.readFileSync(manifestPath, 'utf8'));

    expect(manifest.manifest_version).toBe(3);
    expect(manifest.action.default_popup).toBe('popup/popup.html');
    expect(manifest.content_scripts[0].matches).toEqual(['*://*.atlassian.net/*']);
    expect(manifest.content_scripts[0].js).toEqual(['content/contentScript.js']);
  });
});
