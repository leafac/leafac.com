#lang pollen

◊margin-note{◊figure/image{/avatar.png}}

I am a writer of ◊link["/prose"]{prose}, ◊link["/software"]{software} and ◊link["/music"]{music}. I am a Ph.D. student at the ◊link["https://pl.cs.jhu.edu"]{Programming Languages Laboratory}, at the ◊link["https://jhu.edu"]{Johns Hopkins University}. I ◊link["/research"]{research} a program analysis technique called ◊link["http://pl.cs.jhu.edu/projects/demand-driven-program-analysis/"]{Demand-Driven Program Analysis}.

My interests are computer programming, music, books, typography, lettering, education, minimalism and ◊link["/cooking"]{veganism}. I live in Baltimore, Maryland, United States.

Follow my productions on the ◊link["/feed.atom"]{Atom feed}. ◊link["/contact"]{Contact me} via email on ◊email[◊settings/email].

◊section['news]{News}

◊(require (prefix-in feed: "feed.atom.pm"))

◊(apply
  @
  (for/list ([entry (select-from-doc 'feed feed:doc)]
             #:when (equal? 'entry (get-tag entry)))
    (match-define
      `(entry (id ,id) (title ,title) (link ((href ,href))) (updated ,updated) (summary ,summary ...))
      entry)
    (define key (substring id (string-length "urn:uuid:")))
    (define entry/time (substring updated 0 (string-length "yyyy-MM-dd")))
    ◊@{◊subsection[key]{◊link[href]{◊|title|◊time[#:datetime updated]{ · ◊entry/time}}}◊(apply @ summary)}))