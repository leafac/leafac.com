<!DOCTYPE html>
◊(begin
   (define document-class (select-from-metas 'document-class metas))
   (define title (select-from-metas 'title metas))
   (define date (select-from-metas 'date metas))
   
   (->html
    (html
     (head
      (meta #:charset "UTF-8")
      (meta #:name "viewport" #:content "width=device-width, initial-scale=1")
      (meta #:name "author" #:content (dict-ref personal-data 'author))
      (meta #:name "description" #:content (dict-ref personal-data 'description))
      (head/link #:href ◊internal-url["/assets/stylesheets/styles.css"]
                 #:rel "stylesheet" #:type "text/css")
      (head/link #:rel "icon" #:type "image/jpeg" #:href ◊internal-url["/assets/images/favicon.jpg"])
      (head/link #:type "application/atom+xml" #:rel "alternate"
                 #:title (dict-ref personal-data 'name) #:href ◊internal-url["/feed.atom"])
      (head/title ◊when/splice[title]{◊title · } (dict-ref personal-data 'name)))
     (body
      (header
       (h1 ◊link/internal["/"]{◊(dict-ref personal-data 'name)})
       ◊menu[◊link/internal["/about"]{About}
                           ◊link/internal["/contact"]{Contact}
                           ◊link/internal["/research"]{Research}
                           ◊link/internal["/prose"]{Prose}
                           ◊link/internal["/software"]{Software}
                           ◊link/internal["/music"]{Music}
                           ◊link/internal["/cooking"]{Cooking}
                           ◊link/internal["/feed.atom"]{Atom feed}
                           ◊link/internal["/license"]{License}
                           ◊link/internal["/colophon"]{Colophon}])
      (apply
       article
       ◊when/splice[(equal? document-class 'recipe)]{◊margin-note{See ◊link/internal["/cooking"]{all recipes}.}}
       ◊when/splice[title]{◊(header (h1 ◊title) ◊when/splice[date]{◊time{◊date}})}
       (select-from-doc 'root doc))))))
