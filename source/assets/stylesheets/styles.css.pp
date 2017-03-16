#lang pollen
◊(string-append
  (for/fold ([compiled ""])
            ([vendor (in-list '("../../vendor/assets/stylesheets/normalize.css"
                                "../../vendor/assets/stylesheets/syntax-highlight.css"))])
    (define removes '(#px"/\\*.*?\\*/" #px"\\s*\n+\\s*"))
    (define vendor/source (file->string vendor))
    (define vendor/target
      (for/fold ([removed vendor/source])
                ([remove (in-list removes)])
        (regexp-replace* remove removed "")))
    (string-append compiled vendor/target))

  (css-expr->css (apply append (map cdr (components/css)))))
