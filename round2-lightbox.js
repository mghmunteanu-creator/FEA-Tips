(() => {
  const triggers = [...document.querySelectorAll('[data-round2-lightbox]')];
  if (!triggers.length) return;
  const overlay = document.createElement('div');
  overlay.className = 'result-lightbox-overlay';
  overlay.style.padding = '0';
  overlay.hidden = true;
  overlay.setAttribute('role', 'dialog');
  overlay.setAttribute('aria-modal', 'true');
  overlay.setAttribute('aria-label', 'Enlarged figure');
  const content = document.createElement('div');
  content.className = 'round2-lightbox-content';
  overlay.append(content);
  document.body.append(overlay);
  let active;
  function size() {
    const img = content.querySelector('img');
    if (!img || !img.naturalWidth) return;
    const ratio = img.naturalWidth / img.naturalHeight;
    content.style.width = Math.min(innerWidth * .96, innerHeight * .92 * ratio, img.naturalWidth * 2) + 'px';
  }
  function close() {
    if (overlay.hidden) return;
    overlay.hidden = true;
    content.replaceChildren();
    document.body.classList.remove('result-lightbox-open');
    active?.focus();
  }
  for (const trigger of triggers) {
    const open = () => {
      active = trigger;
      content.replaceChildren(...[...trigger.querySelectorAll('img')].map(img => {
        const clone = img.cloneNode();
        clone.removeAttribute('style');
        clone.removeAttribute('width');
        clone.removeAttribute('height');
        clone.addEventListener('load', size);
        return clone;
      }));
      overlay.hidden = false;
      document.body.classList.add('result-lightbox-open');
      size();
    };
    trigger.addEventListener('click', open);
    if (trigger.tagName !== 'BUTTON') trigger.addEventListener('keydown', event => {
      if (event.key === 'Enter' || event.key === ' ') { event.preventDefault(); open(); }
    });
  }
  overlay.addEventListener('click', event => { if (event.target === overlay) close(); });
  document.addEventListener('keydown', event => { if (event.key === 'Escape') close(); });
  window.addEventListener('resize', size);
})();
