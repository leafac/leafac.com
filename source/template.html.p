<!DOCTYPE html>
◊(define title (select-from-metas 'title metas))
◊(define date (select-from-metas 'date metas))
◊(define-values (doc/body doc/head)
   (splitf-txexpr
    doc (λ (element) (and (txexpr? element) (member (get-tag element) '(style script))))))
◊(define doc/body/html (->html doc/body #:splice? #t))
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="author" content="◊|settings/author|">
    <meta name="description" content="◊|settings/description|">
    <link rel="stylesheet" type="text/css" href="/styles.css">
    <link rel="icon" type="image/x-icon" href="/favicon.ico">
    <link rel="alternate" type="application/atom+xml" title="◊|settings/title|" href="/feed.atom">
    <title>◊when/splice[title]{◊|title| · }◊|settings/title|</title>
    ◊(map ->html doc/head)
  </head>
  <body>
    <header>
      <h1><a href="/">◊|settings/title|</a></h1>
      <nav>
        ◊(for/list ([pagenode (in-list (pagetree->list (~a (current-project-root) "index.ptree")))])
           (define title (select-from-metas 'title (~a (current-project-root) pagenode)))
           (define path (regexp-replace #rx"index\\.html$" (~a pagenode) ""))
           (define active? (string-prefix? (~a here) path))
           ◊~a{<a href="/◊|path|"◊(if active? ◊~a{ class="active"} "")>◊|title|</a>})
      </nav>
    </header>
    <main>
      ◊(cond
         [title
          ◊~a{
              <article>
              <header>
              <h2>◊|title|</h2>
              ◊(if date ◊~a{<time>◊|date|</time>} "")
              </header>
              ◊doc/body/html
              </article>
              }]
         [else ◊doc/body/html])
    </main>
  </body>
</html>
