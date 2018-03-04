#lang pollen

◊define-meta[title]{Cooking}

◊(define (recipes . elements)
  (apply list/unordered #:class "recipes" elements))

◊(define (recipe path . elements)
  (list/unordered/item #:class "recipe" (apply reference (~a "/cooking/" path) elements)))

◊style{
  .recipes {
    ◊prefix['column-count]{2}
    padding-left: ◊|space/none|;
    line-height: ◊|line-height/large|;
  }

  .recipe {
    list-style: none;
  }

  .recipe a {
    text-decoration: none;
  }
}

◊margin-note{My favorite vegan recipes. Tried at home and adapted for best results.}

◊recipes{
 ◊recipe["no-knead-bread"]{No-Knead Bread}
 ◊recipe["no-knead-whole-wheat-bread"]{No-Knead Whole Wheat Bread}
 ◊recipe["beer-bread"]{Beer Bread}
 ◊recipe["whole-wheat-pizza-crust"]{Whole Wheat Pizza Crust}
 ◊recipe["thin-pizza-crust"]{Thin Pizza Crust}
 ◊recipe["medium-pizza-crust"]{Medium Pizza Crust}
 ◊recipe["thick-pizza-crust"]{Thick Pizza Crust}
 ◊recipe["calzone"]{Calzone}
 ◊recipe["chocolate-chip-cookie"]{Chocolate Chip Cookie}
 ◊recipe["brownie"]{Brownie}
 ◊recipe["banana-muffin"]{Banana Muffin}
 ◊recipe["pancake"]{Pancake}
 ◊recipe["pretzel"]{Pretzel}
 ◊recipe["bolinho-de-chuva"]{◊foreign{Bolinho de Chuva}}
 ◊recipe["banoffee-pie"]{Banoffee Pie}
 ◊recipe["strawberry-chocolate-mousse-pie"]{Strawberry Chocolate Mousse Pie}
 ◊recipe["chocolate-chia-seed-pudding"]{Chocolate Chia Seed Pudding}
 ◊recipe["rice"]{Rice}
}