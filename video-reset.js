document.querySelectorAll("[data-video-reset]").forEach((button) => {
  const video = document.getElementById(button.dataset.videoReset);
  if (!(video instanceof HTMLVideoElement)) return;

  button.addEventListener("click", () => {
    video.pause();
    video.currentTime = 0;
  });
});
