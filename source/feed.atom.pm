#lang pollen

◊define-meta[title]{Atom Feed}
◊define-meta[date]{2018-02-27T06:00:43-05:00}

◊(define link (default-tag-function 'link))

◊feed[
  ◊id{urn:uuid:0d99d85a-bb09-45a9-8735-3344f8a105e6}
  ◊title{◊settings/title}
  ◊subtitle{◊settings/description}
  ◊link[#:href ◊~a{◊|settings/url|/}]
  ◊link[#:rel "self" #:href ◊~a{◊|settings/url|/feed.atom}]
  ◊icon{◊|settings/url|/avatar.png}
  ◊author[◊name{◊settings/author}]
  ◊updated{◊(select-from-metas 'date metas)}

  ◊entry[
    ◊id{urn:uuid:400ec6e1-dae5-4fdf-b0de-1a48273ae13b}
    ◊title{Website Redesign}
    ◊link[#:href ◊~a{◊|settings/url|/}]
    ◊updated{2018-02-27T06:00:43-05:00}
    ◊summary{Published a website redesign that improves readability and load time.}
  ]

  ◊entry[
    ◊id{urn:uuid:f567c62e-852e-48b1-b9b0-c87f3cbfefc6}
    ◊title{My First Robot}
    ◊link[#:href ◊~a{◊|settings/url|/music/my-first-robot}]
    ◊updated{2018-01-15T08:46:37-04:00}
    ◊summary{Published a song.}
  ]

  ◊entry[
    ◊id{urn:uuid:d69eeb15-e521-4205-92f2-d2e40027a76e}
    ◊title{Email Migration: The Ultimate Solution to a Ridiculous Problem}
    ◊link[#:href ◊~a{◊|settings/url|/prose/email-migration}]
    ◊updated{2017-08-05T08:46:37-04:00}
    ◊summary{Published an article about email migration.}
  ]

  ◊entry[
    ◊id{urn:uuid:0c23c7e2-f714-4a1e-a390-3a719fd7287a}
    ◊title{Programming-Language Theory Explained for the Working Programmer: Simple Interpreter}
    ◊link[#:href ◊~a{◊|settings/url|/prose/programming-language-theory-explained-for-the-working-programmer--simple-interpreter}]
    ◊updated{2017-06-26T07:06:08-04:00}
    ◊summary{Published an article about interpreters. The discussion is driven by working code and is approachable to all programmers.}
  ]

  ◊entry[
    ◊id{urn:uuid:485e4b8f-f191-4f6b-afeb-0434287560b9}
    ◊title{Agora há Algo a Temer}
    ◊link[#:href ◊~a{◊|settings/url|/music/agora-ha-algo-a-temer}]
    ◊updated{2017-05-31T20:17:45-04:00}
    ◊summary{Published a song. In Portuguese.}
  ]

  ◊entry[
    ◊id{urn:uuid:9a5f0c7a-0c7e-4e2b-a708-3788d13c5bbd}
    ◊title{O Fim da Tempestade}
    ◊link[#:href ◊~a{◊|settings/url|/music/o-fim-da-tempestade}]
    ◊updated{2017-05-28T19:54:58-04:00}
    ◊summary{Published a song.}
  ]

  ◊entry[
    ◊id{urn:uuid:5b1ddfd2-8217-47e0-a392-8c4ca3e3cd29}
    ◊title{Criatividade}
    ◊link[#:href ◊~a{◊|settings/url|/music/criatividade}]
    ◊updated{2017-05-26T15:23:42-04:00}
    ◊summary{Published a song. In Portuguese.}
  ]

  ◊entry[
    ◊id{urn:uuid:fd0a3eec-bb8b-4a8f-bb47-24872f25642f}
    ◊title{United}
    ◊link[#:href ◊~a{◊|settings/url|/music/united}]
    ◊updated{2017-05-04T15:14:53-04:00}
    ◊summary{Published a song. In Portuguese.}
  ]

  ◊entry[
    ◊id{urn:uuid:23a4a636-0608-4eb5-8201-f7551d079e50}
    ◊title{Programming-Language Theory Explained for the Working Programmer: Principles of Programming Languages}
    ◊link[#:href ◊~a{◊|settings/url|/prose/programming-language-theory-explained-for-the-working-programmer--principles-of-programming-languages}]
    ◊updated{2017-04-03T12:47:30-04:00}
    ◊summary{Published an article about the essence of programming languages. The discussion is driven by working code and is approachable to all programmers.}
  ]

  ◊entry[
    ◊id{urn:uuid:32c8e6c7-b836-498e-a073-c7bec34c25cf}
    ◊title{Playing the Game with PLT Redex}
    ◊link[#:href ◊~a{◊|settings/url|/prose/playing-the-game-with-plt-redex}]
    ◊updated{2017-03-12T16:53:33-04:00}
    ◊summary{Published an article about (ab)using PLT Redex to play a game of Peg Solitaire, a gentle introduction to the tool that avoids complicated formalism.}
  ]

  ◊entry[
    ◊id{urn:uuid:22db8aa9-1c0f-4f0f-9f2e-170a6d58bb9c}
    ◊title{New Website}
    ◊link[#:href ◊~a{◊|settings/url|/}]
    ◊updated{2016-12-27T07:54:08-05:00}
    ◊summary{Published new website.}
  ]
]
