for (const element of document.querySelectorAll(
  `a[href^="https://paypal.me/"]`
))
  element.addEventListener("click", () => {
    alert(`🎁 Thanks for the gift! 🎁

You’ll be redirected to PayPal now.

1. Please leave a note mentioning which item is your gift.

2. Please don’t tick the box that says “Paying for goods or a service?” or we’d have to pay a fee.`);
  });

document.querySelector("#rsvp").addEventListener("submit", async (event) => {
  event.preventDefault();
  const { target } = event;
  for (const element of target.querySelectorAll("input, button"))
    element.disabled = true;
  const { status } = await fetch(target.action, {
    method: target.method,
    body: new FormData(target),
  });
  target.outerHTML =
    status === 200
      ? `<p><strong>Thanks for RSVPing</strong></p>`
      : `<p><strong>Oops, something went wrong. Please contact me at <a href="mailto:linda.vale.renner@gmail.com">linda.vale.renner@gmail.com</a>.</strong></p>`;
});
