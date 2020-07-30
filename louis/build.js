const T = {
  title: { en: "Louis’s Registry", pt: "Lista de Nascimento do Louis" },
  currencySymbol: { en: "$", pt: "R$" },
  exchangeExplanation: {
    en: "Based on the exchange rate of €1 = $1.18 on 2020-07-30 15:46.",
    pt: "Baseado no câmbio de €1 = R$6,11 em 2020-07-30 15:46.",
  },
};
const exchangeRate = {
  en: 1.18,
  pt: 6.11,
};
const inventory = [
  {
    en: "Textile",
    pt: "Têxtil",
    items: [
      {
        title: {
          en: "Velcro Swaddle",
          pt: "Swaddle de Velcro",
        },
        brand: "Ergobaby",
        type: { en: "Pineapple", pt: "Abacaxi" },
        price: 30,
        image: "ergobaby-swaddler-pineapples.jpg",
      },
      {
        title: {
          en: "Velcro Swaddle",
          pt: "Swaddle de Velcro",
        },
        brand: "Ergobaby",
        type: { en: "Bamboo", pt: "Bambú" },
        price: 30,
        image: "71ABP+O5SLL._AC_SL1500_.jpg",
      },
      {
        title: {
          en: "Cotton Muslin (Large)",
          pt: "Musselina de Algodão (Grande)",
        },
        brand: "Little Unicorn",
        type: { en: "Fox", pt: "Raposa" },
        price: 19,
        image: "513420a-muselina-algodon-fox-120x120.jpg",
      },
      {
        title: {
          en: "Bamboo Muslin (Large)",
          pt: "Musselina de Bambú (Grande)",
        },
        brand: "Little Unicorn",
        type: { en: "Insect", pt: "Insetos" },
        price: 20,
        image: "muselina-bambu-insectos-little-unicorn-120x120-1000x1000.jpg",
      },
      {
        title: {
          en: "Bamboo Muslin (Medium)",
          pt: "Musselina de Bambú (Médio)",
        },
        brand: "bambinoMio",
        type: { en: "Pack of 3", pt: "Pacote de 3" },
        price: 15,
        image: "016a9173-102b-4973-b388-80a2faa241e6.jpg",
      },
      {
        title: {
          en: "Cotton Muslin (Small)",
          pt: "Musselina de Algodão (Pequeno)",
        },
        brand: "Zara Home",
        type: { en: "Pack of 3", pt: "Pacote de 3" },
        price: 10,
        image: "3675767625_2_1_1.jpg",
      },
      {
        title: {
          en: "Cover for Changing Pad",
          pt: "Capa para Muda Fraldas",
        },
        brand: "IKEA",
        type: { en: "Bunny", pt: "Coelho" },
        price: 6,
        image:
          "vaedra-cover-for-babycare-mat-rabbit-pattern-white__0717411_PE731232_S5.jpg",
      },
      {
        title: {
          en: "Cover for Changing Pad",
          pt: "Capa para Muda Fraldas",
        },
        brand: "IKEA",
        type: { en: "Strawberry", pt: "Morango" },
        price: 6,
        image: "vaedra-cover-for-babycare-mat__0774098_PE756614_S5.jpg",
      },
      {
        title: {
          en: "Cotton Blanket",
          pt: "Manta de Algodão",
        },
        brand: "IKEA",
        type: { en: "Yellow", pt: "Amarela" },
        price: 10,
        image: "solgul-blanket-dark-yellow__0603279_PE680716_S5.jpg",
      },
      {
        title: {
          en: "Fitted Sheet Next2Me",
          pt: "Lençol de Elástico Next2Me",
        },
        brand: "Chicco",
        type: { en: "Pack of 2", pt: "Pacote de 2" },
        price: 25,
        image: "8051761935485-1-chicco-spannbettlaken-next2me.jpg",
      },
    ],
  },
  {
    en: "Toys",
    pt: "Brinquedos",
    items: [
      {
        title: {
          en: "Lapidou Octopus",
          pt: "Polvo Lapidou",
        },
        brand: "Nattou",
        type: { en: "Grey", pt: "Cinzento" },
        price: 17,
        image: "lapidoupolvocinza.jpg",
      },
      {
        title: {
          en: "Playmat",
          pt: "Tapete de Exercício",
        },
        brand: "IKEA",
        price: 25,
        image: "klappa-play-mat__0606299_PE682202_S5.jpg",
      },
      {
        title: {
          en: "Teether",
          pt: "Mordedor",
        },
        brand: "Sophie la Girafe",
        price: 18,
        image: "Girafa-Sofia.jpg",
      },
      {
        title: {
          en: "Silicone Pacifier",
          pt: "Chupeta de Silicone",
        },
        brand: "Chicco",
        type: { en: "Pack of 2", pt: "Pacote de 2" },
        price: 10,
        image: "chupetaverde0-6.jpg",
      },
      {
        title: {
          en: "Pacifier Clip",
          pt: "Clip de Chupeta",
        },
        type: { en: "Wood", pt: "Madeira" },
        price: 12,
        image: "clip_chupeta_estrela_cinza.jpg",
      },
    ],
  },
  {
    en: "Travel",
    pt: "Passeio",
    items: [
      {
        title: {
          en: "Street Duo Adventure",
          pt: "Conjunto de Rua Duo Adventure",
        },
        brand: "ZY SAFE",
        type: { en: "Grey/Beige", pt: "Cinzento/Bege" },
        price: 200,
        image: "carrinho.jpg",
      },
      {
        title: {
          en: "Traveling Changing Pad",
          pt: "Tapete Muda Fraldas",
        },
        brand: "bambinoMio",
        type: { en: "Snail", pt: "Caracol" },
        price: 18,
        image: "change-mat-snail-suprise-web_1080x.jpg",
      },
      {
        title: {
          en: "Baby Carrier Boppy Comfyfit",
          pt: "Marsúpio Boppy Comfyfit",
        },
        brand: "Chicco",
        type: { en: "Grey", pt: "cinzento" },
        price: 40,
        image: "portabebe.jpg",
      },
    ],
  },
  {
    en: "Furniture",
    pt: "Mobília",
    items: [
      {
        title: {
          en: "Bassinet Next2Me",
          pt: "Berço Next2Me",
        },
        brand: "Chicco",
        type: { en: "Fuchsia", pt: "Fúcsia" },
        price: 60,
        image: "berco.jpg",
      },
      {
        title: {
          en: "Changing Table + Changing Pad",
          pt: "Trocador + Muda Fraldas",
        },
        brand: "IKEA",
        type: { en: "White", pt: "Branco" },
        price: 40,
        image: "gulliver-changing-table__0627301_PE693285_S5.jpg",
      },
      {
        title: {
          en: "Mattress Next2Me",
          pt: "Colchão Next2Me",
        },
        brand: "Chicco",
        price: 35,
        image: "5401a030f563371357b70316c795a82bc359c0ac.jpg",
      },
    ],
  },
  {
    en: "Hygiene",
    pt: "Higiene",
    items: [
      {
        title: {
          en: "Wet Bag (Medium)",
          pt: "Saco para Fraldas (Médio)",
        },
        brand: "Baba+Boo",
        type: { en: "Seagulls", pt: "Gaivotas" },
        price: 20,
        image:
          "baba-boo-small-cloth-nappy-storage-bag-seagulls-6949-p[ekm]1000x1000[ekm].jpg",
      },
      {
        title: {
          en: "Pail Liner",
          pt: "Saco de Roupa Suja ",
        },
        brand: "Piriuki",
        type: { en: "Farm", pt: "Fazenda" },
        price: 25,
        image: "saco_de_balde_piriuki_farm_1.jpg",
      },
      {
        title: {
          en: "Bamboo Reusable Wipes",
          pt: "Toalhitas Reutilizáveis de Bambú",
        },
        brand: "Piriuki",
        type: { en: "Pack of 10", pt: "Pacote de 10" },
        price: 17,
        image: "toalhitas_reutilizaveis_em_bambu.jpg",
      },
      {
        title: {
          en: "Nursing Pillow",
          pt: "Almofada de Amamentação",
        },
        brand: "DonAlgodon",
        type: { en: "Grey", pt: "Cinzento" },
        price: 25,
        image:
          "218555_3_cambrass-almofada-amamentacao-estrelas-cinza-35403.jpg",
      },
      {
        title: {
          en: "Diapers (Size 2)",
          pt: "Fraldas (Tamanho 2)",
        },
        brand: "BamboNature",
        type: { en: "Pack of 30", pt: "Pacote de 30" },
        price: 9,
        image: "bambo_nature_fraldas_2_s_30unidades001.jpg",
      },
      {
        title: {
          en: "Wipes",
          pt: "Toalhitas",
        },
        brand: "WaterWipes",
        type: { en: "Pack of 240", pt: "Pacote de 240" },
        price: 15,
        image: "dbb732dfbcd7188ec4107b064c4c2395.jpg",
      },
      {
        title: {
          en: "Reusable Diapers",
          pt: "Fraldas Reutilizáveis",
        },
        type: { en: "Pack of 12", pt: "Pacote de 12" },
        price: 300,
        image: "BBjune20-385_1024x1024@2x.jpg",
      },
    ],
  },
];

const fs = require("fs");

for (const language of ["en", "pt"])
  fs.writeFileSync(
    `${language}.html`,
    `<!DOCTYPE html>
<html lang="en">
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="styles.css">

<title>${T.title[language]}</title>
<h1>${T.title[language]}</h1>

<p><a href="https://paypal.me/LeandroFacchinetti">Send Custom Amount</a></p>

${inventory
  .map(
    (section) => `
<h2>${section[language]}</h2>
<div class="items">
${section.items
  .map((item) => {
    const priceInForeignCurrency = Math.ceil(
      item.price * exchangeRate[language]
    );
    return `
<p class="item"><a href="https://paypal.me/LeandroFacchinetti/${priceInForeignCurrency}USD"><img src="images/${
      item.image
    }" alt="${item.title[language]}"><br>${item.title[language]}${
      item.brand === undefined ? "" : ` · ${item.brand}`
    }${
      item.type === undefined
        ? ""
        : `<br><span class="type">${item.type[language]}</span>`
    }<br><span class="price">${
      T.currencySymbol[language]
    }${priceInForeignCurrency}</span></a></p>
`;
  })
  .join("")}
</div>
    `
  )
  .join("")}

<footer><p>${T.exchangeExplanation[language]}</p></footer>
    `
  );
