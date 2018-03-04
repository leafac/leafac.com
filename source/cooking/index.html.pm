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
  (for/list ([pagenode (in-list (pagetree->list "index.ptree"))])
    (list/unordered/item
     #:class "recipe"
     (reference
      pagenode (select-from-metas 'title (~a (current-project-root) "cooking/" pagenode))))))
