#lang pollen

◊define-meta[title]{Cooking}

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

◊(apply
  list/unordered
  #:class "recipes"
  (for/list ([pagenode (in-list '("cooking/no-knead-bread/index.html"
                                  "cooking/no-knead-whole-wheat-bread/index.html"
                                  "cooking/beer-bread/index.html"
                                  "cooking/thin-pizza-crust/index.html"
                                  "cooking/medium-pizza-crust/index.html"
                                  "cooking/thick-pizza-crust/index.html"
                                  "cooking/whole-wheat-pizza-crust/index.html"
                                  "cooking/calzone/index.html"
                                  "cooking/chocolate-chip-cookie/index.html"
                                  "cooking/brownie/index.html"
                                  "cooking/banana-muffin/index.html"
                                  "cooking/pancake/index.html"
                                  "cooking/pretzel/index.html"
                                  "cooking/bolinho-de-chuva/index.html"
                                  "cooking/banoffee-pie/index.html"
                                  "cooking/strawberry-chocolate-mousse-pie/index.html"
                                  "cooking/chocolate-chia-seed-pudding/index.html"
                                  "cooking/rice/index.html"))])
    (define title (select-from-metas 'title (~a (current-project-root) pagenode)))
    (list/unordered/item #:class "recipe" (reference (~a "/" pagenode) title))))
