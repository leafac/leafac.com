#lang pollen

◊margin-note{◊figure/image{/assets/images/avatar.png}}

I am a writer of ◊link/internal["/prose"]{prose}, ◊link/internal["/software"]{software} and ◊link/internal["/music"]{music}. I am a Ph.D. student at the ◊link["https://pl.cs.jhu.edu"]{Programming Languages Laboratory}, at the ◊link["https://jhu.edu"]{Johns Hopkins University}. I ◊link/internal["/research"]{research} a program analysis technique called ◊link["http://pl.cs.jhu.edu/projects/demand-driven-program-analysis/"]{Demand-Driven Program Analysis}.

My interests are computer programming, music, books, typography, lettering, education, minimalism and ◊link/internal["/cooking"]{veganism}. I live in Baltimore, Maryland, United States.

Follow my productions on the ◊link/internal["/feed.atom"]{Atom feed}. ◊link/internal["/contact"]{Contact me} via email on ◊email[◊(dict-ref personal-data 'personal-email)].

◊section['news]{News}

◊(require (prefix-in feed: "feed.atom.pm"))

◊(apply
  @
  (for/list ([entry (select-from-doc 'root feed:doc)])
    (match entry
      [`(entry
         (title ,title)
         ,_ ...
         (link ((href ,href)))
         ,_ ...
         (id ,id)
         ,_ ...
         (updated ,updated)
         ,_ ...
         (summary ,summary))
       (define key (substring id (string-length "urn:uuid:")))
       (define entry/time (substring updated 0 (string-length "yyyy-MM-dd")))
       ◊@{◊subsection[key]{◊link[href]{◊title · ◊time{◊entry/time}}}◊summary}]
      [_ ◊@{}])))
