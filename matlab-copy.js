(() => {
  document.querySelectorAll("[data-matlab-snippet]").forEach((snippet) => {
    const button = snippet.querySelector("[data-copy-matlab]");
    const code = snippet.querySelector("code");
    if (!button || !code) return;
    button.addEventListener("click", async () => {
      try {
        const value = code.textContent || "";
        if (navigator.clipboard?.writeText) {
          await navigator.clipboard.writeText(value);
        } else {
          const helper = document.createElement("textarea");
          helper.value = value;
          helper.setAttribute("readonly", "");
          helper.style.position = "fixed";
          helper.style.opacity = "0";
          document.body.appendChild(helper);
          helper.select();
          document.execCommand("copy");
          helper.remove();
        }
        const label = button.textContent;
        button.textContent = "Copied!";
        window.setTimeout(() => { button.textContent = label || "Copy"; }, 2200);
      } catch {
        button.textContent = "Copy failed";
        window.setTimeout(() => { button.textContent = "Copy"; }, 2200);
      }
    });
  });
})();
