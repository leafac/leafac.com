document.querySelectorAll("[data-conditional]").forEach(element => {
  if (new URLSearchParams(window.location.search).has(element.dataset.conditional)) element.style.display = "block";
});
