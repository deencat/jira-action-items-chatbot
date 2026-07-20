function sendMessage(message) {
  return new Promise((resolve, reject) => {
    chrome.runtime.sendMessage(message, (response) => {
      if (chrome.runtime.lastError) {
        reject(new Error(chrome.runtime.lastError.message));
        return;
      }
      resolve(response);
    });
  });
}

function setResult(content) {
  const target = document.getElementById('result');
  target.textContent = typeof content === 'string' ? content : JSON.stringify(content, null, 2);
}

async function refreshAuthStatus() {
  const statusNode = document.getElementById('auth-status');
  try {
    const response = await sendMessage({ type: 'AUTH_STATUS' });
    const authenticated = response?.data?.authenticated;
    statusNode.textContent = authenticated ? 'Authenticated' : 'Not authenticated';
  } catch (error) {
    statusNode.textContent = `Auth check failed: ${error.message}`;
  }
}

async function loadJiraContext() {
  try {
    const response = await sendMessage({ type: 'GET_LAST_JIRA_CONTEXT' });
    const contextNode = document.getElementById('jira-context');
    if (!response?.data) {
      contextNode.textContent = 'No Jira page context captured yet.';
      return;
    }
    contextNode.textContent = JSON.stringify(response.data, null, 2);
  } catch (error) {
    setResult(`Failed to load context: ${error.message}`);
  }
}

async function login() {
  const response = await sendMessage({ type: 'AUTH_LOGIN' });
  setResult(response);
  await refreshAuthStatus();
}

async function logout() {
  const response = await sendMessage({ type: 'AUTH_LOGOUT' });
  setResult(response);
  await refreshAuthStatus();
}

async function checkReminders() {
  const response = await sendMessage({ type: 'CHECK_REMINDERS' });
  setResult(response);
}

function parsePayload() {
  const method = document.getElementById('method').value;
  if (method !== 'POST') {
    return null;
  }

  const payloadText = document.getElementById('payload').value.trim();
  if (!payloadText) {
    return null;
  }

  return JSON.parse(payloadText);
}

async function sendApiRequest() {
  const endpoint = document.getElementById('endpoint').value.trim();
  const method = document.getElementById('method').value;

  if (!endpoint.startsWith('/')) {
    throw new Error('Endpoint must start with /');
  }

  const data = parsePayload();
  const response = await sendMessage({
    type: 'API_REQUEST',
    endpoint,
    method,
    data
  });
  setResult(response);
}

function attachHandlers() {
  document.getElementById('login-btn').addEventListener('click', async () => {
    try {
      await login();
    } catch (error) {
      setResult(`Login failed: ${error.message}`);
    }
  });

  document.getElementById('logout-btn').addEventListener('click', async () => {
    try {
      await logout();
    } catch (error) {
      setResult(`Logout failed: ${error.message}`);
    }
  });

  document.getElementById('check-reminders-btn').addEventListener('click', async () => {
    try {
      await checkReminders();
    } catch (error) {
      setResult(`Reminder check failed: ${error.message}`);
    }
  });

  document.getElementById('send-request-btn').addEventListener('click', async () => {
    try {
      await sendApiRequest();
    } catch (error) {
      setResult(`Request failed: ${error.message}`);
    }
  });
}

(async function init() {
  attachHandlers();
  await refreshAuthStatus();
  await loadJiraContext();
})();
