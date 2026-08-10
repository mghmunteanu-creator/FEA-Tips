(() => {
  function showRandom(selector, storageKey) {
    const items = Array.from(document.querySelectorAll(selector));
    if (items.length < 2) return;

    let previous = -1;
    try {
      previous = Number(window.sessionStorage.getItem(storageKey));
    } catch {
      previous = -1;
    }

    let next = Math.floor(Math.random() * items.length);
    if (next === previous) next = (next + 1) % items.length;

    items.forEach((item, index) => {
      item.hidden = index !== next;
    });

    try {
      window.sessionStorage.setItem(storageKey, String(next));
    } catch {
      // The random selection still works when browser storage is unavailable.
    }
  }

  function refreshHomepageFeatures() {
    showRandom("[data-featured-card]", "fea-featured-formula");
    showRandom("[data-code-preview]", "fea-code-preview");
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", refreshHomepageFeatures, { once: true });
  } else {
    refreshHomepageFeatures();
  }
})();
