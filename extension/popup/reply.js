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

function getParams() {
  const url = new URL(window.location.href);
  return {
    notificationId: url.searchParams.get('id') || '',
    issueKey: url.searchParams.get('key') || ''
  };
}

async function sendReply() {
  const { notificationId, issueKey } = getParams();
  const replyStatus = document.getElementById('reply-status');
  const message = document.getElementById('reply-message').value.trim();

  if (!issueKey) {
    replyStatus.textContent = 'Issue key is missing.';
    return;
  }

  if (!message) {
    replyStatus.textContent = 'Please enter a reply first.';
    return;
  }

  try {
    const response = await sendMessage({
      type: 'SEND_REPLY',
      issueKey,
      message
    });

    if (response?.success === false) {
      throw new Error(response.error || 'Unknown error from extension runtime');
    }

    if (notificationId) {
      chrome.notifications.clear(notificationId);
    }

    replyStatus.textContent = 'Reply sent successfully. You can close this window.';
  } catch (error) {
    replyStatus.textContent = `Failed to send reply: ${error.message}`;
  }
}

function init() {
  const { issueKey } = getParams();
  document.getElementById('issue-label').textContent = `Issue: ${issueKey || 'unknown'}`;
  document.getElementById('send-reply-btn').addEventListener('click', sendReply);
}

init();
