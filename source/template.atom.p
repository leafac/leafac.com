<?xml version="1.0" encoding="utf-8"?>
◊(xexpr->string
  (apply feed #:xmlns "http://www.w3.org/2005/Atom"
         (title (dict-ref personal-data 'name))
         (subtitle (dict-ref personal-data 'description))
         (link #:href ◊absolute-url["/"])
         (link #:rel "self" #:href ◊absolute-url["/feed.atom"])
         (updated (first (sort (map (curry select 'updated)
                                    (filter list? (select-from-doc 'root doc)))
                               string>?)))
         (author (name (dict-ref personal-data 'author)))
         (icon ◊absolute-url["/assets/images/favicon.jpg"])
         (id "urn:uuid:0d99d85a-bb09-45a9-8735-3344f8a105e6")
         (select-from-doc 'root doc)))
