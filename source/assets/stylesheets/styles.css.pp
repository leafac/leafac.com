#lang pollen
◊(string-append
  (regexp-replace* #px"\n|/\\*.*?\\*/"
                   (file->string "../../vendor/assets/stylesheets/normalize.css")
                   "")
  (css-expr->string (apply append (map cdr components/css))))
