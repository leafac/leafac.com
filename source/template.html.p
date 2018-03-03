<!DOCTYPE html>
◊(local-require pollen/setup)
◊(define title (select-from-metas 'title metas))
◊(define date (select-from-metas 'date metas))
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="author" content="◊(select 'author personal-data)">
    <meta name="description" content="◊(select 'description personal-data)">
    <link rel="stylesheet" type="text/css" href="/styles.css">
    <link rel="icon" type="image/jpeg" href="/favicon.jpg">
    <link rel="alternate" type="application/atom+xml" title="◊(select 'name personal-data)" href="/feed.atom">
    <title>◊(->html ◊@[◊when/splice[title]{◊title · } (select 'name personal-data)])</title>
  </head>
  <body>
    <header>
      <h1>◊(->html ◊link["/"]{◊(select 'name personal-data)})</h1>
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
