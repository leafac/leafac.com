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
        ◊(->html ◊@[
        ◊menu/item[#:activation-path "about/"]{◊link["/about"]{About}}
        ◊menu/item[#:activation-path "contact/"]{◊link["/contact"]{Contact}}
        ◊menu/item[#:activation-path "research/"]{◊link["/research"]{Research}}
        ◊menu/item[#:activation-path "prose/"]{◊link["/prose"]{Prose}}
        ◊menu/item[#:activation-path "software/"]{◊link["/software"]{Software}}
        ◊menu/item[#:activation-path "music/"]{◊link["/music"]{Music}}
        ◊menu/item[#:activation-path "cooking/"]{◊link["/cooking"]{Cooking}}
        ◊menu/item{◊link["/feed.atom"]{Atom feed}}
        ◊menu/item[#:activation-path "license/"]{◊link["/license"]{License}}
        ◊menu/item[#:activation-path "colophon/"]{◊link["/colophon"]{Colophon}}])
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
