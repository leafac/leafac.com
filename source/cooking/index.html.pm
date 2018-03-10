#lang pollen

◊define-meta[title]{Cooking}

◊style{
  .recipes {
    ◊prefix['column-count]{2}
    padding-left: ◊|space/none|;
    line-height: ◊|line-height/large|;
  }

  .recipes > * {
    list-style: none;
  }

  .recipes > * a {
    text-decoration: none;
  }
}

◊margin-note{My favorite vegan recipes. Tried at home and adapted for best results.}

◊(apply
  list/unordered
  #:class "recipes"
  (for/list ([pagenode (in-list (children 'cooking/index.html
                                          (~a (current-project-root) 'index.ptree)))])
    (define title (select-from-metas 'title pagenode))
    (list/unordered/item (reference (~a "/" pagenode) title))))
