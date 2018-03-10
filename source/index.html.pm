#lang pollen

◊margin-note{◊figure/image{/avatar.png}}

I am a writer of ◊reference["/prose"]{prose}, ◊reference["/software"]{software} and ◊reference["/music"]{music}. I am a Ph.D. student at the ◊reference["https://pl.cs.jhu.edu"]{Programming Languages Laboratory}, at the ◊reference["https://jhu.edu"]{Johns Hopkins University}. I ◊reference["/research"]{research} a program analysis technique called ◊reference["http://pl.cs.jhu.edu/projects/demand-driven-program-analysis/"]{Demand-Driven Program Analysis}.

My interests are computer programming, music, books, typography, lettering, education, minimalism and ◊reference["/cooking"]{veganism}. I live in Baltimore, Maryland, United States.

Follow my productions on the ◊reference["/feed.atom"]{Atom feed}. ◊reference["/contact"]{Contact me} via email on ◊email[◊settings/email].

◊section['news]{News}

◊(require (prefix-in feed: "feed.atom.pm"))

◊(apply
  @
  (for/list ([entry (in-list (select-from-doc 'feed feed:doc))]
             #:when (equal? 'entry (get-tag entry)))
    (match-define
      `(entry (id ,id) (title ,title) (link ((href ,href))) (updated ,updated) (summary ,summary ...))
      entry)
    (define key (substring id (string-length "urn:uuid:")))
    (define entry/time (substring updated 0 (string-length "yyyy-MM-dd")))
    ◊@{◊subsection[key]{◊reference[href]{◊|title|◊deemphasis{ · ◊time{◊entry/time}}}}◊(apply @ summary)}))
