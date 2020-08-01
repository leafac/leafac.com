for (const element of document.querySelectorAll(
  `a[href^="https://paypal.me/"]`
))
  element.addEventListener("click", () => {
    alert(`🎁 Thanks for the gift! 🎁

You’ll be redirected to PayPal now.

1. Please leave a note mentioning which item is your gift.

2. Please don’t tick the box that says “Paying for goods or a service?” or we’d have to pay a fee.`);
  });

document.querySelector("#rsvp").addEventListener("submit", (event) => {
  event.preventDefault();
  alert("hi");
});
