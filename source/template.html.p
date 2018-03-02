<!DOCTYPE html>
◊(define title (select-from-metas 'title metas))
◊(define date (select-from-metas 'date metas))
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
        ◊string-append*[
          (for/list ([(path label)
                      (in-dict '(("about"     . "About")
                                 ("contact"   . "Contact")
                                 ("research"  . "Research")
                                 ("prose"     . "Prose")
                                 ("software"  . "Software")
                                 ("music"     . "Music")
                                 ("cooking"   . "Cooking")
                                 ("feed.atom" . "Atom Feed")
                                 ("license"   . "License")
                                 ("colophon"  . "Colophon")))])
            (define class (if (string-prefix? (~a here) path) ◊~a{class="active"} ""))
            ◊~a{<a href="/◊|path|" ◊|class|>◊|label|</a>})]
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
