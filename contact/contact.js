(() => {
  const form = document.getElementById('contact-form');
  if (!form) return;
  const button = document.getElementById('contact-submit');
  const status = document.getElementById('contact-status');
  let busy = false;
  function feedback(message, state) {
    status.textContent = message;
    status.dataset.state = state;
    status.focus();
  }
  form.addEventListener('submit', async event => {
    event.preventDefault();
    if (busy || !form.reportValidity()) return;
    for (const name of ['name', 'subject', 'message']) {
      const field = form.elements.namedItem(name);
      field.setCustomValidity(field.value.trim() ? '' : 'Please complete this field.');
      if (!field.reportValidity()) return;
    }
    if (form.elements.namedItem('_gotcha').value) {
      feedback('Your submission could not be accepted. Please check the form and try again.', 'error');
      return;
    }
    busy = true;
    button.disabled = true;
    button.textContent = 'Sending…';
    form.setAttribute('aria-busy', 'true');
    status.textContent = 'Sending your message…';
    status.dataset.state = 'pending';
    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), 30000);
    try {
      const response = await fetch(form.action, {
        method: 'POST', body: new FormData(form),
        headers: { Accept: 'application/json' }, signal: controller.signal
      });
      const data = await response.json().catch(() => ({}));
      if (!response.ok || data.ok === false || data.errors) {
        feedback(response.status === 429
          ? 'Too many attempts. Please wait a few minutes before trying again. Your message has been kept.'
          : 'Your message was not accepted. Please check your details and try again later. Your message has been kept.', 'error');
        return;
      }
      form.reset();
      feedback('Thank you. Formspree has accepted your message for the author.', 'success');
    } catch {
      feedback('We could not confirm submission. Your message has been kept. Please check your connection before trying again; if you retry, a duplicate may be sent.', 'error');
    } finally {
      clearTimeout(timeout);
      busy = false;
      button.disabled = false;
      button.textContent = 'Send message';
      form.removeAttribute('aria-busy');
    }
  });
  form.addEventListener('input', event => {
    if (typeof event.target.setCustomValidity === 'function') event.target.setCustomValidity('');
  });
})();
