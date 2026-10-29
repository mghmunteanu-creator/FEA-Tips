(()=>{
 document.querySelectorAll('.hex8ul-page [data-copy-code]').forEach(button=>button.addEventListener('click',async()=>{
  const text=document.getElementById(button.dataset.copyCode).textContent;
  try{await navigator.clipboard.writeText(text);}catch{const field=document.createElement('textarea');field.value=text;document.body.append(field);field.select();document.execCommand('copy');field.remove();}
  button.textContent='Copied!';setTimeout(()=>button.textContent='Copy',1400);
 }));
 document.querySelectorAll('.hex8ul-page .ul-enlarge').forEach(button=>button.addEventListener('click',()=>{
  const overlay=document.createElement('div');overlay.className='ul-lightbox';overlay.setAttribute('role','dialog');overlay.setAttribute('aria-label','Enlarged figure');overlay.setAttribute('aria-modal','true');
  const image=button.querySelector('img').cloneNode();const close=document.createElement('button');close.textContent='×';close.setAttribute('aria-label','Close enlarged figure');overlay.append(image,close);document.body.append(overlay);
  const oldOverflow=document.body.style.overflow;document.body.style.overflow='hidden';
  const dismiss=()=>{overlay.remove();document.body.style.overflow=oldOverflow;document.removeEventListener('keydown',onKey);button.focus();};
  const onKey=e=>{if(e.key==='Escape')dismiss();};document.addEventListener('keydown',onKey);overlay.addEventListener('click',dismiss);close.focus();
 }));
})();
