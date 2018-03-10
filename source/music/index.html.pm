#lang pollen

◊define-meta[title]{Music}

◊style{
  .music {
    line-height: ◊|line-height/large|;
  }

  .music a {
    text-decoration: none;
  }
}

◊(apply
  div #:class "music"
  (for/list ([pagenode (children 'music/index.html (~a (current-project-root) 'index.ptree))])
    (define title (select-from-metas 'title pagenode))
    ◊@{◊reference[(~a "/" pagenode)]{◊|title|}◊deemphasis{ · ◊(apply @ (select-from-doc 'p pagenode))}◊(new-line)}))
