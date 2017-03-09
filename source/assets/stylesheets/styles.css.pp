#lang pollen
◊(string-append
  (for/fold ([compiled ""])
            ([vendor (in-list '("../../vendor/assets/stylesheets/normalize.css"
                                "../../vendor/assets/stylesheets/syntax-highlight.css"))])
    (string-append compiled (regexp-replace* #px"\n|/\\*.*?\\*/" (file->string vendor) "")))

  (css-expr->css (apply append (map cdr (components/css)))))
