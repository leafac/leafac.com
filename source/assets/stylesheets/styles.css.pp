#lang pollen
◊(string-join
  (for/list ([file (in-list '("/vendor/assets/stylesheets/normalize.css"
                              "/vendor/assets/stylesheets/syntax-highlight.css"))])
    (file->string (source-path file))))
◊(css-expr->css (append-map cdr (components/css)))