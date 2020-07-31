// const T = {
//   continueToPayPal: {
//     en: (href) => `
//       <p><strong>Thank you for the gift!</strong></p>
//       <p>You’ll be redirected to PayPal.<br><img src="paypal.en.drawio.png" alt="PayPal Instructions" width="415"></p>
//       <p><a href="${href}"><strong>Continue to PayPal</strong></a></p>
//     `,
//     pt: (href) => `
//       <p><strong>Obrigado pelo presente!</strong></p>
//       <p>Você será redirecionado para o PayPal.<br><img src="paypal.pt.drawio.png" alt="Instruções para o PayPal" width="415"></p>
//       <p><a href="${href}"><strong>Continuar no PayPal</strong></a></p>
//   `,
//   },
// };

// document.body.insertAdjacentHTML(
//   "beforeend",
//   `<div id="modal"><div class="content"></div></div>`
// );
// function showModal(content) {
//   const modal = document.querySelector("#modal");
//   modal.querySelector(".content").innerHTML = content;
//   modal.style.display = "flex";
//   modal.style.opacity = 1;
// }

// for (const element of document.querySelectorAll(
//   `a[href^="https://www.paypal.me/"]`
// ))
//   element.addEventListener("click", (event) => {
//     event.preventDefault();
//     showModal(T.continueToPayPal[language](element.getAttribute("href")));
//   });
