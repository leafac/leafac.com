#lang pollen

◊define-meta[title]{Music}

◊(apply
  @
  (for/list ([pagenode (children 'music/index.html (~a (current-project-root) 'index.ptree))])
    (define title (select-from-metas 'title pagenode))
    ◊@{◊subsection[title]{◊reference[(~a "/" pagenode)]{◊|title|}}◊(first (select-from-doc 'root pagenode))}))
