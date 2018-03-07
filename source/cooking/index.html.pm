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
  (for/list ([pagenode (in-list (pagetree->list "recipes.ptree"))])
    (define title (select-from-metas 'title pagenode))
    (list/unordered/item #:class "recipe" (reference (~a "/" pagenode) title))))
