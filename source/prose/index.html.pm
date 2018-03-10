#lang pollen

◊define-meta[title]{Prose}

◊(apply
  @
  (for/list ([pagenode (children 'prose/index.html (~a (current-project-root) "index.ptree"))])
    (define title (select-from-metas 'title pagenode))
    ◊subsection[title]{◊reference[(~a "/" pagenode)]{◊|title|}}))
