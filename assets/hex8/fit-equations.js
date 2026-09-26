(() => {
  const blocks = document.querySelectorAll('.hex8-page :is(#element,#coordinates,#strains,#matrix-b) .math-display');
  const fit = () => blocks.forEach(block => {
    const math = block.querySelector('.katex-display > .katex');
    if (!math) return;
    math.style.zoom = '1';
    const available = block.clientWidth - 12;
    const width = math.getBoundingClientRect().width;
    if (width > available && available > 0) math.style.zoom = String(available / width);
  });
  document.fonts.ready.then(fit);
  new ResizeObserver(fit).observe(document.querySelector('.hex8-page .scientific-article'));
})();
