<!DOCTYPE html>
◊(begin
   (define title (select-from-metas 'title metas))
   (define date (select-from-metas 'date metas))

   (->html
    (html
     (head
      (meta #:charset "UTF-8")
      (meta #:name "viewport" #:content "width=device-width, initial-scale=1")
      (meta #:name "author" #:content (dict-ref personal-data 'author))
      (meta #:name "description" #:content (dict-ref personal-data 'description))
      (head/link #:href ◊internal-url{/assets/stylesheets/styles.css} #:rel "stylesheet" #:type "text/css")
      (head/link #:rel "icon" #:type "image/jpeg" #:href ◊internal-url{/assets/images/favicon.jpg})
      (head/link #:type "application/atom+xml" #:rel "alternate"
                 #:title (dict-ref personal-data 'name) #:href ◊internal-url{/feed.atom})
      (head/title ◊when/splice[title]{◊title · } (dict-ref personal-data 'name)))
     (body
      (header
       (h1 ◊link/internal["/"]{◊(dict-ref personal-data 'name)})
       ◊menu{◊menu/item[#:activation-path "about/"]{◊link/internal["/about"]{About}}
                       ◊menu/item[#:activation-path "contact/"]{◊link/internal["/contact"]{Contact}}
                       ◊menu/item[#:activation-path "research/"]{◊link/internal["/research"]{Research}}
                       ◊menu/item[#:activation-path "prose/"]{◊link/internal["/prose"]{Prose}}
                       ◊menu/item[#:activation-path "software/"]{◊link/internal["/software"]{Software}}
                       ◊menu/item[#:activation-path "music/"]{◊link/internal["/music"]{Music}}
                       ◊menu/item[#:activation-path "cooking/"]{◊link/internal["/cooking"]{Cooking}}
                       ◊menu/item{◊link/internal["/feed.atom"]{Atom feed}}
                       ◊menu/item[#:activation-path "license/"]{◊link/internal["/license"]{License}}
                       ◊menu/item[#:activation-path "colophon/"]{◊link/internal["/colophon"]{Colophon}}})
      (apply
       article
       ◊when/splice[title]{◊header{◊h1{◊title} ◊when/splice[date]{◊time{◊date}}}}
       (select-from-doc 'root doc))))))
