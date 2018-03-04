<!DOCTYPE html>
◊(local-require pollen/setup)
◊(define title (select-from-metas 'title metas))
◊(define date (select-from-metas 'date metas))
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="author" content="◊|settings/author|">
    <meta name="description" content="◊|settings/description|">
    <link rel="stylesheet" type="text/css" href="/styles.css">
    <link rel="icon" type="image/x-icon" href="/favicon.ico">
    <link rel="alternate" type="application/atom+xml" title="◊|settings/name|" href="/feed.atom">
    <title>◊(->html ◊@[◊when/splice[title]{◊title · } |settings/name|])</title>
  </head>
  <body>
    <header>
      <h1>◊(->html ◊link["/"]{◊|settings/name|})</h1>
      <nav>
        ◊string-append*[
          (for/list ([pagenode (in-list (pagetree->list (~a (current-project-root) "index.ptree")))])
            (define title (select-from-metas 'title (~a (current-project-root) pagenode)))
            (define path (regexp-replace #rx"index\\.html$" (~a pagenode) ""))
            (define active? (string-prefix? (~a here) path))
            ◊~a{<a href="/◊|path|"◊(if active? ◊~a{ class="active"} "")>◊|title|</a>})]
      </nav>
    </header>
    <article>
      ◊when/splice[title]{
        <header>
          <h2>◊|title|</h2>
          ◊when/splice[date]{<time>◊|date|</time>}
        </header>
      }
      ◊(->html doc #:splice? #t)
    </article>
  </body>
</html>
