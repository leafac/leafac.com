<!DOCTYPE html>
◊(define title (select-from-metas 'title metas))
◊(define date (select-from-metas 'date metas))
◊(define (menu-item path label)
   ◊~a{<a href="/◊|path|" ◊(if (string-prefix? (~a here) path) ◊~a{class="active"} "")>◊|label|</a>})
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="author" content="◊(select 'author personal-data)">
    <meta name="description" content="◊(select 'description personal-data)">
    <link rel="stylesheet" type="text/css" href="/assets/stylesheets/styles.css">
    <link rel="icon" type="image/jpeg" href="/assets/images/favicon.jpg">
    <link rel="alternate" type="application/atom+xml" title="◊(select 'name personal-data)" href="/feed.atom">
    <title>◊(->html ◊@[◊when/splice[title]{◊title · } (select 'name personal-data)])</title>
  </head>
  <body>
    <header>
      <h1>◊(->html ◊link["/"]{◊(select 'name personal-data)})</h1>
      <nav>
        ◊menu-item["about"]{About}
        ◊menu-item["contact"]{Contact}
        ◊menu-item["research"]{Research}
        ◊menu-item["prose"]{Prose}
        ◊menu-item["software"]{Software}
        ◊menu-item["music"]{Music}
        ◊menu-item["cooking"]{Cooking}
        ◊menu-item["feed.atom"]{Atom Feed}
        ◊menu-item["license"]{License}
        ◊menu-item["colophon"]{Colophon}
      </nav>
    </header>
    <article>
      ◊when/splice[title]{
        <header>
          <h1>◊|title|</h1>
          ◊when/splice[date]{<time>◊|date|</time>}
        </header>
      }
      ◊(->html doc #:splice? #t)
    </article>
  </body>
</html>
