(() => {
  const triggers = Array.from(document.querySelectorAll("[data-result-lightbox]"));
  if (!triggers.length) return;

  const overlay = document.createElement("div");
  overlay.className = "result-lightbox-overlay";
  overlay.hidden = true;
  overlay.setAttribute("role", "dialog");
  overlay.setAttribute("aria-modal", "true");
  overlay.setAttribute("aria-label", "Enlarged result map");

  const image = document.createElement("img");
  image.className = "result-lightbox-image";
  overlay.appendChild(image);
  document.body.appendChild(overlay);

  let activeTrigger = null;

  const close = () => {
    if (overlay.hidden) return;
    overlay.hidden = true;
    image.removeAttribute("src");
    image.removeAttribute("alt");
    document.body.classList.remove("result-lightbox-open");
    activeTrigger?.focus();
    activeTrigger = null;
  };

  triggers.forEach((trigger) => {
    trigger.addEventListener("click", () => {
      const source = trigger.getAttribute("data-result-lightbox");
      const preview = trigger.querySelector("img");
      if (!source || !preview) return;
      activeTrigger = trigger;
      image.src = source;
      image.alt = preview.alt || "Enlarged result map";
      overlay.hidden = false;
      document.body.classList.add("result-lightbox-open");
      overlay.focus();
    });
  });

  overlay.addEventListener("click", (event) => {
    if (event.target === overlay) close();
  });

  document.addEventListener("keydown", (event) => {
    if (event.key === "Escape" && !overlay.hidden) close();
  });
})();
