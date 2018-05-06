<!DOCTYPE html>
◊(define title (select-from-metas 'title metas))
◊(define date (select-from-metas 'date metas))
◊(define-values (main head)
   (splitf-txexpr doc
                  (match-lambda
                    [`(p ,tx) (and (txexpr? tx) (member (get-tag tx) '(style script)))]
                    [else #f])))
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="author" content="◊|settings/author|">
    <meta name="description" content="◊|settings/description|">
    <link rel="stylesheet" href="/styles.css" type="text/css">
    <link rel="icon" href="/favicon.ico" type="image/x-icon">
    <link rel="alternate" href="/feed.atom" title="◊(first (select-from-doc 'title 'feed.atom))" type="application/atom+xml">
    <title>◊when/splice[title]{◊|title| · }◊|settings/title|</title>
    ◊(->html (append-map get-elements head))
  </head>
  <body>
    <header>
      <h1><a href="/">◊|settings/title|</a></h1>
      <nav>
        ◊(for/list ([pagenode (in-list (children 'pagetree-root))])
           (define title (select-from-metas 'title pagenode))
           (define activated-pagenodes
             `(,pagenode ,@(flatten (or (select* pagenode (current-pagetree)) empty))))
           (define active? (member here activated-pagenodes))
           ◊@{<a href="/◊|pagenode|" ◊when/splice[active?]{class="active"}>◊|title|</a>})
      </nav>
    </header>
    <main>
      ◊when/splice[title]{
        <header>
          <h2>◊|title|</h2>
          ◊when/splice[date]{<time>◊|date|</time>}
        </header>
      }
      ◊(->html main #:splice? #t)
    </main>
  </body>
</html>
