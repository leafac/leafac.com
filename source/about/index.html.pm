#lang pollen

◊define-meta[title]{About}
◊define-meta[date]{2016-11-09}

◊(define (education . elements)
   (match elements
     [`((title ,key ,title ...)
        (institution ,institution ...)
        (from ,from ...)
        (to ,to ...)
        (highlights (highlight ,highlight ...) ...))
      (txexpr* '@ empty
               (apply subsection key title)
               (apply emphasis institution)
               ", from " (txexpr '@ empty from)
               " to " (txexpr '@ empty to)
               (apply list/unordered
                      (map (λ (highlight) (apply list/unordered/item highlight)) highlight)))]))
◊(define (work-experience . elements)
   (match elements
     [`((institution ,key ,institution ...)
        (title ,title ...)
        (from ,from ...)
        (to ,to ...)
        (highlights (highlight ,highlight ...) ...))
      (txexpr* '@ empty
               (apply subsection key institution)
               (apply emphasis title)
               ", from " (txexpr '@ empty from)
               " to " (txexpr '@ empty to)
               (apply list/unordered
                      (map (λ (highlight) (apply list/unordered/item highlight)) highlight)))]))
◊(define (skills . elements)
   (match elements
     [`((skill ,level ,skill ...) ...)
      (apply list/unordered #:class "skills"
             (map
              (λ (level skill) (apply list/unordered/item #:class (~a level) skill))
              level skill))]))
◊(define certification (default-tag-function '@))
◊(define certification/title subsection)
◊(define certification/date (default-tag-function '@))
◊(define (certification/score . elements)
  (apply (default-tag-function '@) `(,(new-line) ,@elements)))
◊(define event (default-tag-function '@))
◊(define event/title subsection)
◊(define event/date (default-tag-function '@))
◊(define (event/from . elements)
  (apply (default-tag-function '@) `("From " ,@elements)))
◊(define (event/to . elements)
  (apply (default-tag-function '@) `(" to " ,@elements)))
◊(define (event/highlight . elements)
  (apply (default-tag-function '@) `(,(new-line) ,@elements)))
◊(define course (default-tag-function '@))
◊(define course/title subsection)
◊(define (course/by . elements)
  (apply (default-tag-function '@) `(,@elements ", " )))
◊(define course/date (default-tag-function '@))
◊(define (course/highlight . elements)
  (apply (default-tag-function '@) `(,(new-line) ,@elements)))

◊style{
  .skills {
    padding-left: ◊|space/none|;
  }

  .skills > * {
    ◊inline-block-enumeration
  }

  .skills > *::before {
    content: "";
    display: inline-block;
    margin-right: ◊|space/extra-small|;
    border-radius: ◊|border-radius|;
    width: ◊|space/small|;
  }

  .beginner::before {
    height: .3rem;
    background-color: ◊|color/red|;
  }

  .intermediate::before {
    height: .6rem;
    background-color: ◊|color/yellow|;
  }

  .advanced::before {
    height: .9rem;
    background-color: ◊|color/green|;
  }
}

◊margin-note{◊figure/image{/avatar.png}}

I am a writer of ◊reference["/prose"]{prose}, ◊reference["/software"]{software} and ◊reference["/music"]{music}. I am a Ph.D. student at the ◊reference["https://pl.cs.jhu.edu"]{Programming Languages Laboratory}, at the ◊reference["https://jhu.edu"]{Johns Hopkins University}. I ◊reference["/research"]{research} a program analysis technique called ◊reference["http://pl.cs.jhu.edu/projects/demand-driven-program-analysis/"]{Demand-Driven Program Analysis}.

My interests are computer programming, music, books, typography, lettering, education, minimalism and ◊reference["/cooking"]{veganism}. I live in Baltimore, Maryland, United States.

◊new-thought[]

I am ◊~a{◊(period-ref (period-between (date 1990 10 20) (today)) 'years)} years old and I have been writing software for over a decade. Most of my career has been in web products and I also developed natural-language-processing applications, system administration tools and programming-language theory.

◊margin-note{Feel free to invite me for a pair-programming session and to talk at conferences and user-group meetings.}

I believe that knowledge should be ◊emphasis{free as in freedom}. Software included. So I contribute to ◊reference["https://www.fsf.org/about/what-is-free-software"]{Free Software} and teach.

I was born in Brazil and lived there most of my life. My undergraduate degree is from ◊reference["http://www5.usp.br/"]{Universidade de São Paulo}.

I enjoy a frugal, simple, minimalist lifestyle. I own as few things as possible. I do not own a cell phone or participate in Internet social networks.

I play the guitar and ◊reference["/songs"]{write my own songs}. I am also into electronic music production and computer generated music.

I am ◊reference["/cooking"]{vegan}. I do not eat and do not use any animal-derived products. I cook most of my meals, instead of eating out.

I read about a book per week. Both fiction and non-fiction.

◊new-thought[]

The rest of this page lists my accomplishments. Work experiences, education, publications and more.

◊section['education]{Education}

◊education[
 ◊title['education--phd]{Ph.D. student in Computer Science, Programming Languages}
 ◊institution{◊reference["https://jhu.edu"]{Johns Hopkins University}}
 ◊from{2014-09}
 ◊to{2019-09 (estimated)}
 ◊highlights[
  ◊highlight{I am part of ◊reference["http://pl.cs.jhu.edu/"]{The Programming Languages Laboratory}, under ◊reference["http://www.cs.jhu.edu/~scott/"]{Dr. Scott Smith’s} advisory.}
  ◊highlight{I ◊reference["/research"]{research} a new approach to high-order program analysis called ◊reference["http://pl.cs.jhu.edu/projects/demand-driven-program-analysis/"]{Demand-Driven Program Analysis (DDPA)}.}
  ◊highlight{I took courses in programming languages, logic, software engineering, cryptography, natural language processing and databases.}
  ◊highlight{I was a course assistant for the ◊reference["http://pl.cs.jhu.edu/oose/index.shtml"]{Object-Oriented Software Engineering} course on Fall 2015. I advised groups of students on their semester-long project and lectured about Git.}
  ◊highlight{I am system administrator for the laboratory.}
  ◊highlight{My work is supported by a fellowship from the Brazilian Government (CAPES). Process number: 13477/13-7.}
  ]
]

◊education[
 ◊title['education--ms]{M.S. in Computer Science}
 ◊institution{◊reference["https://jhu.edu"]{Johns Hopkins University}}
 ◊from{2014-09}
 ◊to{2016-10}
 ◊highlights[
  ◊highlight{I got a master’s degree as part of the Ph.D. program.}
  ◊highlight{My project was ◊citation{Practical Demand-Driven Program Analysis with Recursion}.}
 ]
]

◊education[
 ◊title['education--bs]{B.S. in Computer Science}
 ◊institution{◊reference["http://www5.usp.br/"]{Universidade de São Paulo}}
 ◊from{2008-02}
 ◊to{2012-09}
 ◊highlights[
  ◊highlight{
   ◊margin-note{During my time in Universidade de São Paulo, I played the drums in a group similar to a ◊reference["https://en.wikipedia.org/wiki/Samba_school"]{◊foreign{Escola de Samba}}. It was a lot of fun.}
   My GPA was 3.08.}
  ◊highlight{I participated in an Scientific Initiation program in the field of robotics with scholarship provided by the Brazilian Government (INCT-SEC). My research was in intelligent vehicles that do not require human intervention. I developed an algorithm that helped on visual navigation.}
 ]
]


◊section['work-experience]{Work experience}

◊work-experience[
 ◊institution['work-experience--raise-sistemas]{◊reference["http://raisesistemas.com.br/"]{Raise Sistemas}}
 ◊title{Software Developer}
 ◊from{2014-02}
 ◊to{2014-08}
 ◊highlights[
  ◊highlight{
   ◊margin-note{I had to leave Raise Sistemas so quickly because I got accepted into a Ph.D. program.}

   Raise Sistemas is a product start-up.
  }
  ◊highlight{I maintained and developed new features for an existing medium-sized Ruby on Rails application from end to end.}
  ◊highlight{I improved the performance of an user-importing subsystem by a factor of 30x.}
  ◊highlight{I was part of an agile team that did regular code-reviews, continuous integration and continuous delivery.}
  ◊highlight{I worked remotely, while traveling.}
 ]
]

◊work-experience[
 ◊institution['work-experience--das-dad]{Das Dad}
 ◊title{Software Developer}
 ◊from{2013-02}
 ◊to{2013-12}
 ◊highlights[
  ◊highlight{
   ◊margin-note{Unfortunately, the angel investor that backed Das Dad folded and the product was never completed.}

   Das Dad was a product start-up.
  }
  ◊highlight{I contributed to a Ruby on Rails front-end application and back-end services in Ruby and Java.}
  ◊highlight{The applications made a non-trivial use of natural language processing and artificial intelligence along the lines of recommendation engines, summarization and sentiment analysis.}
  ◊highlight{I did infrastructure work, implementing continuous integration and continuous delivery systems.}
  ◊highlight{I helped manage outreach activities for the local programming community. For example, I promoted coding dojos and hackathons.}
 ]
]

◊work-experience[
 ◊institution['work-experience--uol]{◊reference["http://www.uol.com.br/"]{Universo Online (UOL)}}
 ◊title{Junior System Analyst}
 ◊from{2012-03}
 ◊to{2013-02}
 ◊highlights[
  ◊highlight{UOL is a major Internet publishing company in Brazil.}
  ◊highlight{I used Java EE to build and maintain several web products with millions of users.}
  ◊highlight{I improved the development process of front-end code by introducing new technologies and building internal tools.}
 ]
]

◊work-experience[
 ◊institution['work-experience--daitan-group]{◊reference["http://www.daitangroup.com/"]{Daitan Group}}
 ◊title{Intern in Software Development}
 ◊from{2011-07}
 ◊to{2012-02}
 ◊highlights[
  ◊highlight{Daitan Group is an outsourcing company for Telecom applications.}
  ◊highlight{I had direct contact with customers in California.}
  ◊highlight{I developed a web service in Java EE for a telephony platform and a PHP web administration tool for a video conference system.}
  ◊highlight{I taught a course about Git for peer developers.}
 ]
]

◊section['skills]{Skills}

◊skills[
 ◊skill['advanced]{English}
 ◊skill['advanced]{Portuguese}
 ◊skill['beginner]{Spanish}
 ◊skill['intermediate]{Racket}
 ◊skill['advanced]{Ruby}
 ◊skill['advanced]{Java}
 ◊skill['intermediate]{OCaml}
 ◊skill['intermediate]{Programming Language Semantics}
 ◊skill['intermediate]{Type Theory}
 ◊skill['intermediate]{Program Analysis}
 ◊skill['intermediate]{Abstract Interpretation}
 ◊skill['intermediate]{PLT Redex}
 ◊skill['advanced]{Unit Testing}
 ◊skill['intermediate]{Cryptography}
 ◊skill['intermediate]{Natural Language Processing}
 ◊skill['advanced]{Software Engineering}
 ◊skill['advanced]{Object Orientation}
 ◊skill['advanced]{Functional Programming}
 ◊skill['beginner]{Haskell}
 ◊skill['intermediate]{Lisp}
 ◊skill['beginner]{Golang}
 ◊skill['intermediate]{Number Theory}
 ◊skill['intermediate]{GPG}
 ◊skill['intermediate]{OpenSSL}
 ◊skill['advanced]{TDD}
 ◊skill['advanced]{BDD}
 ◊skill['advanced]{RSpec}
 ◊skill['advanced]{MiniTest}
 ◊skill['beginner]{Cucumber}
 ◊skill['beginner]{Ant}
 ◊skill['beginner]{Maven}
 ◊skill['advanced]{Git}
 ◊skill['intermediate]{SVN}
 ◊skill['intermediate]{C}
 ◊skill['intermediate]{PHP}
 ◊skill['advanced]{Guitar}
 ◊skill['intermediate]{Keyboard}
 ◊skill['intermediate]{Ableton Live}
 ◊skill['beginner]{Erlang}
 ◊skill['beginner]{Node.js}
 ◊skill['beginner]{Meteor}
 ◊skill['advanced]{JQuery}
 ◊skill['advanced]{JavaScript}
 ◊skill['intermediate]{CSS 3}
 ◊skill['intermediate]{HTML 5}
 ◊skill['intermediate]{SQLite}
 ◊skill['beginner]{Oracle Database}
 ◊skill['intermediate]{MySQL}
 ◊skill['intermediate]{PostgreSQL}
 ◊skill['advanced]{Continuous Integration}
 ◊skill['advanced]{Continuous Deployment}
 ◊skill['intermediate]{Cloud Computing}
 ◊skill['intermediate]{Mail Servers}
 ◊skill['intermediate]{Server Automation}
 ◊skill['intermediate]{Compilers}
 ◊skill['advanced]{Ruby on Rails}
 ◊skill['beginner]{HAML}
 ◊skill['intermediate]{Sass}
 ◊skill['intermediate]{Compass}
 ◊skill['intermediate]{CoffeeScript}
 ◊skill['intermediate]{LaTeX}
 ◊skill['beginner]{MongoDB}
 ◊skill['beginner]{Redis}
 ◊skill['intermediate]{Rack}
 ◊skill['intermediate]{nginx}
 ◊skill['intermediate]{Apache Httpd}
 ◊skill['intermediate]{Postfix}
 ◊skill['intermediate]{Dovecot}
 ◊skill['intermediate]{Typography}
 ◊skill['beginner]{JBoss}
 ◊skill['beginner]{Jetty}
 ◊skill['beginner]{Memcached}
 ◊skill['beginner]{Solr}
 ◊skill['beginner]{Elastic Search}
 ◊skill['beginner]{Varnishd}
 ◊skill['intermediate]{Shell Scripting}
 ◊skill['advanced]{Linux}
 ◊skill['advanced]{UML 2.0}
 ◊skill['advanced]{Scrum}
 ◊skill['advanced]{Agile Methodologies}
 ◊skill['advanced]{Vim}
 ◊skill['advanced]{Emacs}
 ◊skill['advanced]{Eclipse}
 ◊skill['advanced]{Web Services}
 ◊skill['intermediate]{REST}
 ◊skill['intermediate]{TLS (SSL)}
 ◊skill['beginner]{ITIL}
 ◊skill['intermediate]{XML}
 ◊skill['advanced]{JSON}
 ◊skill['intermediate]{YAML}
 ◊skill['intermediate]{Puppet}
 ◊skill['intermediate]{Vagrant}
 ◊skill['advanced]{Docker}
 ◊skill['intermediate]{Amazon Web Services}
]

◊section['certifications]{Certifications}

◊certification[
 ◊certification/title['certification--toefl]{TOEFL}
 ◊certification/date{2013-03}
 ◊certification/score{Reading: ◊fraction[28 30]. Listening: ◊fraction[29 30]. Speaking: ◊fraction[24 30]. Writing: ◊fraction[27 30]. Total: ◊fraction[108 120].}
]

◊certification[
 ◊certification/title['certification--gre]{GRE}
 ◊certification/date{2013-09}
 ◊certification/score{Verbal reasoning: ◊fraction[154 170]. Quantitative reasoning: ◊fraction[166 170]. Analytical writing: ◊fraction[3.5 6].}
]

◊certification[
 ◊certification/title['certification--oracle-certified-java-programmer]{Oracle Certified Java Programmer}
 ◊certification/date{2012-06}
 ◊certification/score{Score: 90%}
]

◊section['events]{Events}

◊event[
 ◊event/title['event--tfp-216]{◊reference["http://tfp2016.org/"]{The 17th Symposium on Trends in Functional Programming (TFP 2016)}}
 ◊event/date{2016-06-08, 2016-06-10}
 ◊event/highlight{Alexander Rozenshteyn presented the paper ◊reference["/research#publication--paper--what-is-your-function"]{◊citation{What is Your Function? Static Pattern Matching on Function Behavior}}, of which I am a co-author.}
]

◊event[
 ◊event/title['event--ibm-pl-day-2015]{◊reference["http://researcher.watson.ibm.com/researcher/view_group_subpage.php?id=6432"]{IBM Programming Languages Day 2015}}
 ◊event/date{2015-11-23}
]

◊event[
 ◊event/title['event--the-developer-s-conference-florianopolis-2014]{The Developer’s Conference Florianópolis 2014}
 ◊event/date{2014-05}
 ◊event/highlight{Talked about HTTP/2 and the future of web technologies.}
]

◊event[
 ◊event/title['event--i-masters-inter-con-2013]{iMasters InterCon 2013}
 ◊event/date{2013-11}
]

◊event[
 ◊event/title['event--i-masters-inter-con-plus-android-2013]{iMasters InterCon + Android 2013}
 ◊event/date{2013-09}
]

◊event[
 ◊event/title['event--ruby-conf-brazil-2013]{RubyConf Brazil 2013}
 ◊event/date{2013-08}
]

◊event[
 ◊event/title['event--coding-dojo-at-fai]{Coding Dojo at FAI}
 ◊event/date{2013-08}
 ◊event/highlight{Co-hosted a full day of activities for undergraduate Computer Science students which included a lecture about Git and a Coding Dojo.}
]

◊event[
 ◊event/title['event--7-masters]{7Masters}
 ◊event/date{2013-01}
 ◊event/highlight{◊reference["https://www.youtube.com/watch?v=FUzAxEV29kA"]{Talked} about modern Java development techniques and tools.}
]

◊event[
 ◊event/title['event--dev-in-sampa-2012]{Dev in Sampa 2012}
 ◊event/date{2012-05}
]

◊event[
 ◊event/title['event--ruby-conf-brazil-2012]{RubyConf Brazil 2012}
 ◊event/date{2012-08}
]

◊event[
 ◊event/title['event--coding-dojo-at-sp]{Coding Dojo@SP}
 ◊event/from{2012}
 ◊event/to{2013}
 ◊event/highlight{Promoted, hosted and participated in several Conding Dojos for the local developer community.}
]

◊event[
 ◊event/title['event--guru-sp]{GURU SP}
 ◊event/from{2012}
 ◊event/to{2013}
]

◊event[
 ◊event/title['event--profissao-java]{Profissão Java (Java Career)}
 ◊event/date{2012-08}
]

◊event[
 ◊event/title['event--conexao-java]{Conexão Java (Java Connection)}
 ◊event/date{2012-05}
]

◊event[
 ◊event/title['event--18th-international-scientific-initiation-symposium]{◊foreign{18º Simpósio Internacional de Iniciação Científica da Universidade de São Paulo} (18th International Scientific Initiation Symposium from Universidade de São Paulo)}
 ◊event/date{2010-11}
 ◊event/highlight{Presented the paper ◊reference["/research#publication--paper--sistema-de-navegacao-visual-baseado-em-correlacao-de-imagens-visando-a-aplicacao-em-veiculos-autonomos-inteligentes"]{◊citation{◊foreign{Sistema de Navegação Visual Baseado em Correlação de Imagens Visando a Aplicação em Veículos Autônomos Inteligentes} (Visual Navigation System Based on Image Correlation Targeted to Intelligent Autonomous Vehicles)}}.}
]

◊event[
 ◊event/title['event--joint-conference-2010]{◊reference["http://www.jointconference.fei.edu.br/wci/index.html"]{III Workshop on Computational Intelligence—WCI. Joint Conference 2010—SBIA—SBRN—JRI}}
 ◊event/date{2010-10-24}
 ◊event/highlight{Presented the paper ◊reference["/research#publication--paper--navegacao-visual-de-robos-moveis-autonomos-baseada-em-metodos-de-correlacao-de-imagens"]{◊citation{◊foreign{Navegação Visual de Robôs Móveis Autônomos Baseada em Métodos de Correlação de Imagens} (Visual Navigation of Autonomous Mobile Robots Based on Image Correlation Methods)}}.}
]

◊event[
 ◊event/title['event--iv-scientific-initiation-and-computataion-technology-workshop]{◊foreign{IV Workshop de Iniciação Científica e Tecnológica de Computação (WICT)} (IV Scientific and Technologic Initiation Workshop)}
 ◊event/date{2010-09-22}
 ◊event/highlight{Presented the paper ◊reference["/research#publication--paper--pesquisa-e-desenvolvimento-de-robos-moveis-autonomos-com-navegacao-baseada-em-correlacao-de-imagens"]{◊citation{◊foreign{Pesquisa e Desenvolvimento de Robôs Móveis Autônomos com Navegação Baseada em Correlação de Imagens} (Research and Development of Autonomous Mobile Robots with Image-Correlation-Based Navigation)}}.}
]

◊event[
 ◊event/title['event--ii-computer-science-bachelor-s-workshop]{II Computer Science Bachelor’s Workshop from Universidade de São Paulo}
 ◊event/date{2009}
 ◊event/highlight{Represented students in discussion with professors about improvements on the structure of the Computer Science course.}
]

◊event[
 ◊event/title['event--php-conference-brazil]{PHP Conference Brazil}
 ◊event/date{2006}
]

◊section['courses]{Courses}

◊course[
 ◊course/title['course--introduction-to-ableton-live]{Introduction to Ableton Live}
 ◊course/by{Erin Barra in Coursera}
 ◊course/date{2016}
]

◊course[
 ◊course/title['course--introduction-to-music-production]{Introduction to Music Production}
 ◊course/by{Loudon Stearns in Coursera}
 ◊course/date{2015}
]

◊course[
 ◊course/title['course--natural-language-processing]{Natural Language Processing}
 ◊course/by{Michael Collins in Coursera}
 ◊course/date{2013}
]

◊course[
 ◊course/title['course--fj-25-java-advanced-persistence-with-hibernate-and-jpa]{FJ-25—Java Advanced—Persistence with Hibernate and JPA}
 ◊course/by{Caelum}
 ◊course/date{2012}
]

◊course[
 ◊course/title['course--software-engineering-for-software-as-a-service-part-i]{Software Engineering for Software as a Service (Part I)}
 ◊course/by{Armando Fox and David Patterson in Coursera}
 ◊course/date{2012}
 ◊course/highlight{Scored 2120.6 out of 2126.}
]

◊course[
 ◊course/title['course--secure-development-for-web-programmers]{Secure Development for Web Programmers}
 ◊course/by{Universo Online (UOL)}
 ◊course/date{2012}
]

◊course[
 ◊course/title['course--scrum-and-agile-methodologies]{Scrum and Agile Methodologies}
 ◊course/by{Universo Online (UOL)}
 ◊course/date{2012}
]

◊course[
 ◊course/title['course--itil]{ITIL}
 ◊course/by{Universo Online (UOL)}
 ◊course/date{2012}
]

◊course[
 ◊course/title['course--mc128-intruction-to-java-ee]{MC128—Introduction to Java EE}
 ◊course/by{Globalcode in the open4education program}
 ◊course/date{2012}
]

◊course[
 ◊course/title['course--java-programming-intro-course]{Java Programming Intro Course}
 ◊course/by{SENAI}
 ◊course/date{2006}
]

◊course[
 ◊course/title['course--tableless-i]{Tableless I}
 ◊course/by{Visie}
 ◊course/date{2006}
]

◊course[
 ◊course/title['course--advanced-course-of-english]{Advanced Course of English}
 ◊course/by{CNA}
 ◊course/date{2004}
]
