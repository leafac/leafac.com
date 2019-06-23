---
# HOW TO ADD A PUBLICATION
#
# - Add publication to Zotero.
#   - Authors: Use ‘Literal’.
#   - Abstract: Don’t use paragraphs. If multilingual, use a soft line break (two spaces followed by newline).
# - Export from Zotero.
#   - Format ‘BibTeX’ and ‘Export Files’ enabled.
#   - Format ‘CSL JSON’.
# - Format generated BibTeX.
#   - Remove the ‘file’ entry.
#   - Use four spaces for indentation.
# - Upload PDF to server.
# - Copy data here.
#   - JSON.
#   - BibTeX.
#   - PDF file name.
# - Replace tabs with two spaces.

publications:
  [
    {
      "id": "http://zotero.org/users/4828827/items/RKXIFGKR",
      "type": "speech",
      "title": "What is Your Function? Static Pattern Matching on Function Behavior",
      "event": "The 17th Symposium on Trends in Functional Programming (TFP 2016)",
      "abstract": "We define a new notion of *function pattern*, which supports run-time pattern matching on functions based on their behavior. The ability to run-time dispatch on function type information enables new programmer expressiveness, including support of overloading on higher-order functions as well as other useful patterns. We formally present a type inference system for function patterns. The system answers questions of function pattern matching by recursively invoking the type inference algorithm. The recursive invocation contains some delicate issues of self-referentiality that we address.",
      "URL": "http://tfp2016.org/",
      "author": [
        {
          "literal": "Leandro Facchinetti"
        },
        {
          "literal": "Pottayil Harisanker Menon"
        },
        {
          "literal": "Zachary Palmer"
        },
        {
          "literal": "Alexander Rozenshteyn"
        },
        {
          "literal": "Scott F. Smith"
        }
      ],
      "issued": {
        "date-parts": [
          [
            "2016",
            6,
            8
          ]
        ]
      }
    },
    {
      "id": "http://zotero.org/users/4828827/items/VUC75E8B",
      "type": "speech",
      "title": "Sistema de Navegação Visual baseado em Correlação de Imagens Visando a Aplicação em Veículos Autônomos Inteligentes",
      "event": "*18º Simpósio Internacional de Iniciação Científica da Universidade de São Paulo* (SIICUSP) (18th International Scientific Initiation Symposium from Universidade de São Paulo)",
      "shortTitle": "Visual Navigation System Based on Image Correlation Targeted to Intelligent Autonomous Vehicles",
      "author": [
        {
          "literal": "Leandro Facchinetti"
        },
        {
          "literal": "Fernando Santos Osório"
        }
      ],
      "issued": {
        "date-parts": [
          [
            "2010",
            11,
            16
          ]
        ]
      }
    },
    {
      "id": "http://zotero.org/users/4828827/items/TJW5USER",
      "type": "paper-conference",
      "title": "Relative Store Fragments for Singleton Abstraction",
      "container-title": "24th Static Analysis Symposium",
      "archive": "https://link.springer.com/chapter/10.1007%2F978-3-319-66706-5_6",
      "abstract": "A *singleton abstraction* occurs in a program analysis when some results of the analysis are known to be exact: an abstract binding corresponds to a single concrete binding. In this paper, we develop a novel approach to constructing singleton abstractions via *relative store fragments*. Each store fragment is a *locally* exact store abstraction in that it contains only those abstract variable bindings necessary to address a particular question at a particular program point; it is *relative* to that program point and the point of view may be shifted. We show how an analysis incorporating relative store fragments achieves flow-, context-, path- and must-alias sensitivity, and can be used as a basis for environment analysis, without any machinery put in place for those specific aims. We build upon recent advances in *demand-driven* higher-order program analysis to achieve this construction as it is fundamentally tied to demand-driven lookup of variable values.",
      "URL": "http://staticanalysis.org/sas2017/sas2017.html",
      "author": [
        {
          "literal": "Leandro Facchinetti"
        },
        {
          "literal": "Zachary Palmer"
        },
        {
          "literal": "Scott F. Smith"
        }
      ],
      "issued": {
        "date-parts": [
          [
            "2017",
            11,
            1
          ]
        ]
      }
    },
    {
      "id": "http://zotero.org/users/4828827/items/V865FGTI",
      "type": "report",
      "title": "Practical Demand-Driven Program Analysis with Recursion",
      "publisher": "Johns Hopkins University",
      "genre": "Research project report to fulfill a qualifying requirement of the Ph.D. program",
      "abstract": "Demand-Driven Program Analysis (DDPA) is a context-sensitive control-ﬂow analysis for higher-order functional programming languages in the same space as *k*-CFA and related analyses. DDPA is provably sound and polynomial, but that alone does not guarantee its applicability to real-world programs. This project studies DDPA’s practicality in two dimensions: expressiveness (the analysis closely approximates the run-time) and performance (the analysis is fast to compute). To address expressiveness, we extended the analysis to directly support recursion, eliminating the need for encodings. To address performance, we developed a higher-level programming language that compiles to DDPA’s core language, ported over benchmarks that exercise all its features, and measured the reference implementation’s performance, comparing to other state-ofthe-art program analyses. DDPA is competitive and, in some cases, faster than the alternatives.",
      "author": [
        {
          "literal": "Leandro Facchinetti"
        }
      ],
      "issued": {
        "date-parts": [
          [
            "2016",
            10,
            7
          ]
        ]
      }
    },
    {
      "id": "http://zotero.org/users/4828827/items/IZSR5PBU",
      "type": "paper-conference",
      "title": "Pesquisa e Desenvolvimento de Robôs Táticos para Ambientes Internos",
      "container-title": "Internal Workshop of INCT-SEC",
      "abstract": "*Este artigo apresenta os trabalhos de pesquisa e desenvolvimento realizados junto ao INCT-SEC voltados para aplicações de monitoramento e segurança de ambientes internos (indoor) com o uso de robôs móveis. Os trabalhos desenvolvidos visam prover os robôs móveis de uma arquitetura de software que implemente um sistema de controle inteligente. O robô móvel deve poder ser controlado em modo tele-operado (operação remota semi-autônoma) ou em modo completamente autônomo. Este sistema deve ser capaz de detectar intrusos e situações anômalas, navegar no ambiente desviando dos obstáculos, garantindo assim a integridade do robô e dos elementos presentes no ambiente.*  \nThis paper describes the INCT-SEC research and development efforts in order to create a mobile robotic platform applied to inspect and to protect indoor environments. We proposed a robotic control architecture and implemented some computational software modules which are used to provide “intelligent behaviors” to the mobile robots. The robot can be remotely controlled based on a semi-autonomous approach, and also it can perform the surveillance tasks in a completely autonomous mode. The system is able to detect intruders and anomalous situations, and also, perform the patrolling task avoiding obstacles and also preserving the integrity of the robot and other environment elements (e.g. people, objects).",
      "shortTitle": "Research and Development of Tactical Robots for Indoor Environments",
      "author": [
        {
          "literal": "Fernando Osório"
        },
        {
          "literal": "Denis Wolf"
        },
        {
          "literal": "Kalinka Castelo Branco"
        },
        {
          "literal": "Jó Ueyama"
        },
        {
          "literal": "Gustavo Pessin"
        },
        {
          "literal": "Leandro Fernandes"
        },
        {
          "literal": "Maurício Dias"
        },
        {
          "literal": "Leandro Couto"
        },
        {
          "literal": "Daniel Sales"
        },
        {
          "literal": "Diogo Correa"
        },
        {
          "literal": "Matheus Nin"
        },
        {
          "literal": "Leandro Lourenço Silva"
        },
        {
          "literal": "Leonardo Bonetti"
        },
        {
          "literal": "Leandro Facchinetti"
        },
        {
          "literal": "Fabiano Hessel"
        }
      ],
      "issued": {
        "date-parts": [
          [
            "2011",
            12,
            7
          ]
        ]
      }
    },
    {
      "id": "http://zotero.org/users/4828827/items/25ZBP9BS",
      "type": "paper-conference",
      "title": "Navegação Visual de Robôs Móveis Autônomos Baseada em Métodos de Correlação de Imagens",
      "container-title": "III Workshop on Computational Intelligence—WCI. Joint Conference 2010—SBIA—SBRN—JRI",
      "abstract": "*Uma área importante de pesquisas na robótica é a navegação autônoma de veículos, onde o objetivo principal é fazer com que um robô móvel ou veículo seja capaz de se locomover sem a necessidade de alguém controlá-lo. Uma das abordagens que se destaca consiste em equipar o veículo com câmeras e a partir do processamento das imagens geradas orientar e controlar sua movimentação. Com este propósito, o presente trabalho propõe mecanismos para encontrar correlações entre imagens que ajudem a ajustar a rota (posição e orientação) de um veículo autônomo. A partir de uma região de interesse escolhida em uma imagem previamente armazenada do caminho a ser percorrido, o programa deve procurar uma área correspondente desta cena em outra imagem capturada em tempo real pelo veículo. A correlação entre as imagens previamente registradas do caminho e as imagens observadas pelo veículo, permitem que se determine o ajuste de sua orientação e o controle de seu avanço em uma determinada direção. Neste trabalho são propostos dois algoritmos de correlação que foram desenvolvidos e testados visando este tipo de aplicação, tendo seus desempenhos comparados. Buscou-se otimizar o desempenho destes algoritmos a fim de viabilizar a sua utilização em aplicações de controle de veículos móveis em tempo real.*",
      "URL": "http://www.jointconference.fei.edu.br/wci/index.html",
      "shortTitle": "Visual Navigation of Autonomous Mobile Robots Based on Image Correlation Methods",
      "author": [
        {
          "literal": "Leandro Facchinetti"
        },
        {
          "literal": "Fernando Santos Osório"
        }
      ],
      "issued": {
        "date-parts": [
          [
            "2010",
            10,
            24
          ]
        ]
      }
    },
    {
      "id": "http://zotero.org/users/4828827/items/YNQJ9ISI",
      "type": "speech",
      "title": "Pesquisa e Desenvolvimento de Robôs Móveis Autônomos com Navegação Baseada em Correlação de Imagens",
      "event": "*IV Workshop de Iniciação Científica e Tecnológica de Computação* (WICT) (IV Scientific and Technologic Initiation Workshop)",
      "shortTitle": "Research and Development of Autonomous Mobile Robots with Image-Correlation-Based Navigation",
      "author": [
        {
          "literal": "Leandro Facchinetti"
        },
        {
          "literal": "Fernando Santos Osório"
        }
      ],
      "issued": {
        "date-parts": [
          [
            "2010",
            9,
            22
          ]
        ]
      }
    },
    {
      "id": "http://zotero.org/users/4828827/items/AEVV98PS",
      "type": "book",
      "title": "Higher-Order Demand-Driven Program Analysis (Artifact)",
      "collection-title": "ECOOP 2016 Artifacts",
      "archive": "http://2016.ecoop.org/event/ecoop-2016-artifacts-higher-order-demand-driven-program-analysis",
      "abstract": "This artifact is a proof-of-concept implementation of DDPA, an on-demand program analysis for higher-order functional programs. The implementation, written in OCaml, includes a parser, evaluator, and DDPA analysis for the language defined in the companion paper (including the proper record semantics extension). The analysis may be performed using different levels of precision as specified by the user and is capable of rendering the control flow graphs and pushdown systems using the GraphViz language DOT. This artifact was used to verify the conclusions of the companion paper and produces visualizations matching those figures in the companion paper's overview.",
      "URL": "https://2016.ecoop.org/track/ecoop-2016-artifacts",
      "note": "Also appeared at the [Dagstuhl Artifacts Series](http://drops.dagstuhl.de/opus/volltexte/2016/6130/)",
      "author": [
        {
          "literal": "Leandro Facchinetti"
        },
        {
          "literal": "Zachary Palmer"
        },
        {
          "literal": "Scott F. Smith"
        }
      ],
      "issued": {
        "date-parts": [
          [
            "2016",
            6,
            20
          ]
        ]
      }
    },
    {
      "id": "http://zotero.org/users/4828827/items/GJMBE3DC",
      "type": "report",
      "title": "SDL: A DSL for Cryptographic Schemes",
      "publisher": "Johns Hopkins University",
      "genre": "Research project report to fulfill a qualifying requirement of the Ph.D. program",
      "abstract": "In the past few years there has been an increasing interest in automating the development and implementation of cryptographic schemes, which traditionally are manual, difficult and error-prone tasks. Projects including AutoBatch and AutoGroup+ mechanically generate cryptographic schemes, and use a Domain-Specific Language (DSL) called the Scheme Description Language (SDL) to represent them; but, despite being a critical component in these systems, SDL is significantly limited. We introduce a redesigned SDL which addresses these shortcomings: we extend the language with new features, provide a formal specification, define a type system and several other static analyses, allow it to express various kinds of cryptographic schemes, and present techniques for manipulation via term rewriting. Finally, we explore two applications: a simple transformer to assert the consistent use of group operators (additive vs. multiplicative notation); and a generalization of AutoBatch, which includes more sophisticated term rewriting. Operations that previously required hundreds of lines of code in the original AutoBatch implementation are expressed with our techniques in less then ten lines. Overall, the redesigned SDL is a more solid and practical foundation upon which to build cryptographic-system development automations.",
      "author": [
        {
          "literal": "Leandro Facchinetti"
        }
      ],
      "issued": {
        "date-parts": [
          [
            "2017",
            11,
            14
          ]
        ]
      }
    },
    {
      "id": "http://zotero.org/users/4828827/items/NPG5Y85P",
      "type": "speech",
      "title": "Towards Practical Higher-Order Demand-Driven Program Analysis",
      "publisher-place": "Johns Hopkins University",
      "genre": "Preliminary research proposal for Graduate Board Oral (GBO) examination, a qualifying requirement for the Ph.D. program",
      "event-place": "Johns Hopkins University",
      "abstract": "We propose to research an abstract-interpretation-based static analysis for higher-order programming languages which performs demand-driven (backward) variable lookups, addressing issues of performance and expressiveness towards a foundational theory for practical analysis tools. State-of-the-art program analyses in the higher-order space generally carry variable environments forward, and only recently our research introduced an alternative backward approach, but, while preliminary investigation indicates that our technique has fundamentally different and promising trade-offs, the connection between forward and backward analysis is not well understood; we intend to examine this question, contemplating a hybrid approach which would combine the strengths of both methods. We also propose to address shortcomings of the existing backward technique, in particular regarding recursive programs, by introducing improved models for calling contexts and by adapting parameters in the course of variable lookup. Finally, we plan to probe other grounding theoretical frameworks besides the pushdown-automata reachability we currently use, including logic programming and grammar-based strategies.",
      "author": [
        {
          "literal": "Leandro Facchinetti"
        }
      ],
      "issued": {
        "date-parts": [
          [
            "2017",
            10,
            27
          ]
        ]
      }
    },
    {
      "id": "http://zotero.org/users/4828827/items/2WHK3X28",
      "type": "article-journal",
      "title": "Higher-Order Demand-Driven Program Analysis",
      "container-title": "ACM Transactions on Programming Languages and Systems (TOPLAS)",
      "source": "Zotero",
      "abstract": "Developing accurate and efficient program analyses for languages with higher-order functions is known to be difficult. Here we define a new higher-order program analysis, Demand-Driven Program Analysis (DDPA), which extends well-known *demand-driven* lookup techniques found in first-order program analyses to higher-order programs. This task presents several unique challenges to obtain good accuracy, including the need for a new method for demand-driven lookup of non-local variable values. DDPA is flow- and context-sensitive and provably polynomial-time. To efficiently implement DDPA we develop a novel pushdown automaton metaprogramming framework, the Pushdown Reachability automaton (PDR). The analysis is formalized and proved sound, and an implementation is described.",
      "note": "Accepted for publication",
      "author": [
        {
          "literal": "Leandro Facchinetti"
        },
        {
          "literal": "Zachary Palmer"
        },
        {
          "literal": "Scott Smith"
        }
      ],
      "issued": {
        "date-parts": [
          [
            "2019"
          ]
        ]
      }
    }
  ]

bibtex:
  "http://zotero.org/users/4828827/items/GJMBE3DC": |-
    @techreport{leandro_facchinetti_sdl:_2017,
        type = {Research project report to fulfill a qualifying requirement of the {Ph}.{D}. program},
        title = {{SDL}: {A} {DSL} for {Cryptographic} {Schemes}},
        abstract = {In the past few years there has been an increasing interest in automating the development and implementation of cryptographic schemes, which traditionally are manual, difficult and error-prone tasks. Projects including AutoBatch and AutoGroup+ mechanically generate cryptographic schemes, and use a Domain-Specific Language (DSL) called the Scheme Description Language (SDL) to represent them; but, despite being a critical component in these systems, SDL is significantly limited. We introduce a redesigned SDL which addresses these shortcomings: we extend the language with new features, provide a formal specification, define a type system and several other static analyses, allow it to express various kinds of cryptographic schemes, and present techniques for manipulation via term rewriting. Finally, we explore two applications: a simple transformer to assert the consistent use of group operators (additive vs. multiplicative notation); and a generalization of AutoBatch, which includes more sophisticated term rewriting. Operations that previously required hundreds of lines of code in the original AutoBatch implementation are expressed with our techniques in less then ten lines. Overall, the redesigned SDL is a more solid and practical foundation upon which to build cryptographic-system development automations.},
        institution = {Johns Hopkins University},
        author = {{Leandro Facchinetti}},
        month = nov,
        year = {2017},
    }
  "http://zotero.org/users/4828827/items/TJW5USER": |-
    @inproceedings{leandro_facchinetti_relative_2017,
        title = {Relative {Store} {Fragments} for {Singleton} {Abstraction}},
        url = {http://staticanalysis.org/sas2017/sas2017.html},
        abstract = {A *singleton abstraction* occurs in a program analysis when some results of the analysis are known to be exact: an abstract binding corresponds to a single concrete binding. In this paper, we develop a novel approach to constructing singleton abstractions via *relative store fragments*. Each store fragment is a *locally* exact store abstraction in that it contains only those abstract variable bindings necessary to address a particular question at a particular program point; it is *relative* to that program point and the point of view may be shifted. We show how an analysis incorporating relative store fragments achieves flow-, context-, path- and must-alias sensitivity, and can be used as a basis for environment analysis, without any machinery put in place for those specific aims. We build upon recent advances in *demand-driven* higher-order program analysis to achieve this construction as it is fundamentally tied to demand-driven lookup of variable values.},
        booktitle = {24th {Static} {Analysis} {Symposium}},
        author = {{Leandro Facchinetti} and {Zachary Palmer} and {Scott F. Smith}},
        month = nov,
        year = {2017},
    }
  "http://zotero.org/users/4828827/items/NPG5Y85P": |-
    @misc{leandro_facchinetti_towards_2017,
        address = {The Johns Hopkins University},
        type = {Preliminary research proposal for {Graduate} {Board} {Oral} ({GBO}) examination, a qualifying requirement for the {Ph}.{D}. program},
        title = {Towards {Practical} {Higher}-{Order} {Demand}-{Driven} {Program} {Analysis}},
        abstract = {We propose to research an abstract-interpretation-based static analysis for higher-order programming languages which performs demand-driven (backward) variable lookups, addressing issues of performance and expressiveness towards a foundational theory for practical analysis tools. State-of-the-art program analyses in the higher-order space generally carry variable environments forward, and only recently our research introduced an alternative backward approach, but, while preliminary investigation indicates that our technique has fundamentally different and promising trade-offs, the connection between forward and backward analysis is not well understood; we intend to examine this question, contemplating a hybrid approach which would combine the strengths of both methods. We also propose to address shortcomings of the existing backward technique, in particular regarding recursive programs, by introducing improved models for calling contexts and by adapting parameters in the course of variable lookup. Finally, we plan to probe other grounding theoretical frameworks besides the pushdown-automata reachability we currently use, including logic programming and grammar-based strategies.},
        author = {{Leandro Facchinetti}},
        month = oct,
        year = {2017},
    }
  "http://zotero.org/users/4828827/items/V865FGTI": |-
    @techreport{leandro_facchinetti_practical_2016,
        type = {Research project report to fulfill a qualifying requirement of the {Ph}.{D}. program},
        title = {Practical {Demand}-{Driven} {Program} {Analysis} with {Recursion}},
        abstract = {Demand-Driven Program Analysis (DDPA) is a context-sensitive control-ﬂow analysis for higher-order functional programming languages in the same space as *k*-CFA and related analyses. DDPA is provably sound and polynomial, but that alone does not guarantee its applicability to real-world programs. This project studies DDPA’s practicality in two dimensions: expressiveness (the analysis closely approximates the run-time) and performance (the analysis is fast to compute). To address expressiveness, we extended the analysis to directly support recursion, eliminating the need for encodings. To address performance, we developed a higher-level programming language that compiles to DDPA’s core language, ported over benchmarks that exercise all its features, and measured the reference implementation’s performance, comparing to other state-ofthe-art program analyses. DDPA is competitive and, in some cases, faster than the alternatives.},
        institution = {Johns Hopkins University},
        author = {{Leandro Facchinetti}},
        month = oct,
        year = {2016},
    }
  "http://zotero.org/users/4828827/items/AEVV98PS": |-
    @misc{leandro_facchinetti_higher-order_2016,
        title = {Higher-{Order} {Demand}-{Driven} {Program} {Analysis} ({Artifact})},
        url = {https://2016.ecoop.org/track/ecoop-2016-artifacts},
        abstract = {This artifact is a proof-of-concept implementation of DDPA, an on-demand program analysis for higher-order functional programs. The implementation, written in OCaml, includes a parser, evaluator, and DDPA analysis for the language defined in the companion paper (including the proper record semantics extension). The analysis may be performed using different levels of precision as specified by the user and is capable of rendering the control flow graphs and pushdown systems using the GraphViz language DOT. This artifact was used to verify the conclusions of the companion paper and produces visualizations matching those figures in the companion paper's overview.},
        author = {{Leandro Facchinetti} and {Zachary Palmer} and {Scott F. Smith}},
        month = jun,
        year = {2016},
        note = {Also appeared at the [Dagstuhl Artifacts Series](http://drops.dagstuhl.de/opus/volltexte/2016/6130/)},
    }
  "http://zotero.org/users/4828827/items/RKXIFGKR": |-
    @misc{leandro_facchinetti_what_2016,
        title = {What is {Your} {Function}? {Static} {Pattern} {Matching} on {Function} {Behavior}},
        url = {http://tfp2016.org/},
        abstract = {We define a new notion of *function pattern*, which supports run-time pattern matching on functions based on their behavior. The ability to run-time dispatch on function type information enables new programmer expressiveness, including support of overloading on higher-order functions as well as other useful patterns. We formally present a type inference system for function patterns. The system answers questions of function pattern matching by recursively invoking the type inference algorithm. The recursive invocation contains some delicate issues of self-referentiality that we address.},
        author = {{Leandro Facchinetti} and {Pottayil Harisanker Menon} and {Zachary Palmer} and {Alexander Rozenshteyn} and {Scott F. Smith}},
        month = jun,
        year = {2016},
    }
  "http://zotero.org/users/4828827/items/IZSR5PBU": |-
    @inproceedings{fernando_osorio_pesquisa_2011,
        title = {Pesquisa e {Desenvolvimento} de {Robôs} {Táticos} para {Ambientes} {Internos}},
        shorttitle = {Research and {Development} of {Tactical} {Robots} for {Indoor} {Environments}},
        abstract = {*Este artigo apresenta os trabalhos de pesquisa e desenvolvimento realizados junto ao INCT-SEC voltados para aplicações de monitoramento e segurança de ambientes internos (indoor) com o uso de robôs móveis. Os trabalhos desenvolvidos visam prover os robôs móveis de uma arquitetura de software que implemente um sistema de controle inteligente. O robô móvel deve poder ser controlado em modo tele-operado (operação remota semi-autônoma) ou em modo completamente autônomo. Este sistema deve ser capaz de detectar intrusos e situações anômalas, navegar no ambiente desviando dos obstáculos, garantindo assim a integridade do robô e dos elementos presentes no ambiente.*  
        This paper describes the INCT-SEC research and development efforts in order to create a mobile robotic platform applied to inspect and to protect indoor environments. We proposed a robotic control architecture and implemented some computational software modules which are used to provide “intelligent behaviors” to the mobile robots. The robot can be remotely controlled based on a semi-autonomous approach, and also it can perform the surveillance tasks in a completely autonomous mode. The system is able to detect intruders and anomalous situations, and also, perform the patrolling task avoiding obstacles and also preserving the integrity of the robot and other environment elements (e.g. people, objects).},
        booktitle = {Internal {Workshop} of {INCT}-{SEC}},
        author = {{Fernando Osório} and {Denis Wolf} and {Kalinka Castelo Branco} and {Jó Ueyama} and {Gustavo Pessin} and {Leandro Fernandes} and {Maurício Dias} and {Leandro Couto} and {Daniel Sales} and {Diogo Correa} and {Matheus Nin} and {Leandro Lourenço Silva} and {Leonardo Bonetti} and {Leandro Facchinetti} and {Fabiano Hessel}},
        month = dec,
        year = {2011},
    }
  "http://zotero.org/users/4828827/items/VUC75E8B": |-
    @misc{leandro_facchinetti_sistema_2010,
        title = {Sistema de {Navegação} {Visual} baseado em {Correlação} de {Imagens} {Visando} a {Aplicação} em {Veículos} {Autônomos} {Inteligentes}},
        shorttitle = {Visual {Navigation} {System} {Based} on {Image} {Correlation} {Targeted} to {Intelligent} {Autonomous} {Vehicles}},
        author = {{Leandro Facchinetti} and {Fernando Santos Osório}},
        month = nov,
        year = {2010},
    }
  "http://zotero.org/users/4828827/items/25ZBP9BS": |-
    @inproceedings{leandro_facchinetti_navegacao_2010,
        title = {Navegação {Visual} de {Robôs} {Móveis} {Autônomos} {Baseada} em {Métodos} de {Correlação} de {Imagens}},
        shorttitle = {Visual {Navigation} of {Autonomous} {Mobile} {Robots} {Based} on {Image} {Correlation} {Methods}},
        url = {http://www.jointconference.fei.edu.br/wci/index.html},
        abstract = {*Uma área importante de pesquisas na robótica é a navegação autônoma de veículos, onde o objetivo principal é fazer com que um robô móvel ou veículo seja capaz de se locomover sem a necessidade de alguém controlá-lo. Uma das abordagens que se destaca consiste em equipar o veículo com câmeras e a partir do processamento das imagens geradas orientar e controlar sua movimentação. Com este propósito, o presente trabalho propõe mecanismos para encontrar correlações entre imagens que ajudem a ajustar a rota (posição e orientação) de um veículo autônomo. A partir de uma região de interesse escolhida em uma imagem previamente armazenada do caminho a ser percorrido, o programa deve procurar uma área correspondente desta cena em outra imagem capturada em tempo real pelo veículo. A correlação entre as imagens previamente registradas do caminho e as imagens observadas pelo veículo, permitem que se determine o ajuste de sua orientação e o controle de seu avanço em uma determinada direção. Neste trabalho são propostos dois algoritmos de correlação que foram desenvolvidos e testados visando este tipo de aplicação, tendo seus desempenhos comparados. Buscou-se otimizar o desempenho destes algoritmos a fim de viabilizar a sua utilização em aplicações de controle de veículos móveis em tempo real.*},
        booktitle = {{III} {Workshop} on {Computational} {Intelligence}—{WCI}. {Joint} {Conference} 2010—{SBIA}—{SBRN}—{JRI}},
        author = {{Leandro Facchinetti} and {Fernando Santos Osório}},
        month = oct,
        year = {2010},
    }
  "http://zotero.org/users/4828827/items/YNQJ9ISI": |-
    @misc{leandro_facchinetti_pesquisa_2010,
        title = {Pesquisa e {Desenvolvimento} de {Robôs} {Móveis} {Autônomos} com {Navegação} {Baseada} em {Correlação} de {Imagens}},
        shorttitle = {Research and {Development} of {Autonomous} {Mobile} {Robots} with {Image}-{Correlation}-{Based} {Navigation}},
        author = {{Leandro Facchinetti} and {Fernando Santos Osório}},
        month = sep,
        year = {2010},
    }
  "http://zotero.org/users/4828827/items/2WHK3X28": |-
    @article{leandro_facchinetti_higher-order_2019,
        title = {Higher-{Order} {Demand}-{Driven} {Program} {Analysis}},
        abstract = {Developing accurate and efficient program analyses for languages with higher-order functions is known to be difficult. Here we define a new higher-order program analysis, Demand-Driven Program Analysis (DDPA), which extends well-known *demand-driven* lookup techniques found in first-order program analyses to higher-order programs. This task presents several unique challenges to obtain good accuracy, including the need for a new method for demand-driven lookup of non-local variable values. DDPA is flow- and context-sensitive and provably polynomial-time. To efficiently implement DDPA we develop a novel pushdown automaton metaprogramming framework, the Pushdown Reachability automaton (PDR). The analysis is formalized and proved sound, and an implementation is described.},
        journal = {ACM Transactions on Programming Languages and Systems (TOPLAS)},
        author = {{Leandro Facchinetti} and {Zachary Palmer} and {Scott Smith}},
        year = {2019},
        note = {Accepted for publication},
    }

attachments:
  "http://zotero.org/users/4828827/items/GJMBE3DC":
    PDF: "/publications/Facchinetti - SDL A DSL for Cryptographic Schemes.pdf"
  "http://zotero.org/users/4828827/items/TJW5USER":
    PDF: "/publications/Facchinetti et al. - 2017 - Relative Store Fragments for Singleton Abstraction.pdf"
  "http://zotero.org/users/4828827/items/NPG5Y85P":
    PDF: "/publications/Facchinetti - Towards Practical Higher-Order Demand-Driven Progr.pdf"
    Slides: "/publications/towards-practical-higher-order-demand-driven-program-analysis.key"
  "http://zotero.org/users/4828827/items/V865FGTI":
    PDF: "/publications/Facchinetti - Practical Demand-Driven Program Analysis with Recu.pdf"
  "http://zotero.org/users/4828827/items/AEVV98PS":
    PDF: "/publications/Leandro Facchinetti et al. - 2016 - Higher-Order Demand-Driven Program Analysis (Artif.pdf"
    Code: "/publications/DARTS-2-1-9-artifact-88e98fe9019cb2bb1e758be0ca6325f9.tgz"
  "http://zotero.org/users/4828827/items/RKXIFGKR":
    PDF: "/publications/Facchinetti et al. - What is Your Function Static Pattern Matching on .pdf"
  "http://zotero.org/users/4828827/items/IZSR5PBU":
    PDF: "/publications/Osório et al. - Pesquisa e Desenvolvimento de Robôs Táticos para A.pdf"
  "http://zotero.org/users/4828827/items/VUC75E8B":
    PDF: "/publications/Facchinetti and Osório - Sistema de Navegação Visual baseado em Correlação .pdf"
  "http://zotero.org/users/4828827/items/25ZBP9BS":
    PDF: "/publications/Facchinetti and Osório - 2010 - Navegação Visual de Robôs Móveis Autônomos Baseada.pdf"
  "http://zotero.org/users/4828827/items/2WHK3X28":
    PDF: "/publications/Facchinetti et al. - Higher-Order Demand-Driven Program Analysis.pdf"
---

<figure markdown="1">
![Avatar](avatar.png){:width="300"}
</figure>

I write [prose](#prose), [software](#software) and [music](#music). I am a Ph.D. candidate in Computer Science, at [The Programming Languages Laboratory](https://pl.cs.jhu.edu), at the [Johns Hopkins University](https://jhu.edu), advised by [Dr. Scott Smith](https://www.cs.jhu.edu/~scott/). We [research](#publications) a program analysis technique called [Demand-Driven Program Analysis](https://pl.cs.jhu.edu/projects/demand-driven-program-analysis/). Beyond research, I am interested in education, writing, computer programming, reading, music, typography, lettering, photography, video production, mindfulness, minimalism, and veganism. I live in Baltimore, Maryland, United States.

Newsletter
==========

Interested in my work? Subscribe to my newsletter!

<form method="POST" action="https://www-leafac-com.herokuapp.com/newsletter">
  <p>
    <input type="hidden" name="return" value="https://www.leafac.com/#newsletter">
    <input type="email" name="email" placeholder="Email" maxlength="500" size="30" required>
    <input type="text" name="name" placeholder="Name (optional)" maxlength="500" size="30"><br>
    <textarea name="description" placeholder="Tell me a little about yourself: Who are you? How did you find me? What kind of content to want to receive? (optional)" cols="70" rows="5"></textarea><br>
    <button>Subscribe</button>
  </p>
</form>

Prefer an Atom feed instead? Use **[Kill the Newsletter!](https://www.kill-the-newsletter.com)**

Contact
=======

**Personal Email:** <me@leafac.com>

**Work Email:** <leandro@jhu.edu>

Prose
=====

- [**A Minimal LaTeX Dissertation Template (for the Johns Hopkins University)**](/a-minimal-latex-dissertation-template-for-the-johns-hopkins-university/)
- [**Understanding the Type of `call/cc`**](/understanding-the-type-of-call-cc/)
- [**Playing the Game with PLT Redex**](/playing-the-game-with-plt-redex/)
- [**Email Migration: The Ultimate Solution to a Ridiculous Problem**](/email-migration/)

Software
========

Services
--------

- [**Kill the Newsletter!**](https://www.kill-the-newsletter.com)  
  Convert email newsletters into Atom feeds.  
  Featured in [Lifehacker](https://lifehacker.com/kill-the-newsletter-converts-newsletter-subscriptions-i-1788953342), [Hacker News](https://news.ycombinator.com/item?id=12949154), [Product Hunt](https://www.producthunt.com/posts/kill-the-newsletter), and [blogs](https://sathyasays.com/2018/05/22/convert-newsletters-to-rss-feeds-with-kill-the-newsletter/) [around](https://rsnijders.info/vakblog/2016/11/15/nieuwsbrieven-als-rss-feeds/) [the](https://www.schieb.de/755445/kill-the-newsletter-nachrichten-als-rss-feed) [world](https://www.fastweb.it/web-e-digital/kill-the-newsletter-il-sistema-di-archiviazione-di-newsletter/).

Racket Packages
---------------

- [**Pollen Component**](https://docs.racket-lang.org/pollen-component/)  
  Component-based development for [Pollen](https://docs.racket-lang.org/pollen/).

- [**CSS-expressions**](https://docs.racket-lang.org/css-expr/)  
  S-expression-based CSS.

- [**Extensible Functions**](https://docs.racket-lang.org/extensible-functions/)  
  A solution to the expression problem in Typed Racket.

Contributions
-------------

- **Racket:** [Racket](https://github.com/racket/racket/commits?author=leafac), [PLT Redex](https://github.com/racket/redex/commits?author=leafac), [DrRacket](https://github.com/racket/drracket/commits?author=leafac), [Profile](https://github.com/racket/profile/commits?author=leafac), [Pollen](https://github.com/mbutterick/pollen/commits?author=leafac), [Nanopass](https://github.com/nanopass/nanopass-framework-racket/commits?author=leafac).
- **Papers and articles:** [An Introduction to Redex with Abstracting Abstract Machines](https://github.com/dvanhorn/redex-aam-tutorial/commits?author=leafac), [NUPRL’s Website](https://github.com/nuprl/website/commits?author=leafac), [Abstracting Definitional Interpreters](https://github.com/plum-umd/abstracting-definitional-interpreters/commits?author=leafac), [Optimizing Abstract Abstract Machines](https://github.com/dvanhorn/oaam/commits?author=leafac).
- **Web Frameworks:** [Ruby on Rails](https://github.com/rails/rails/commits?author=leafac), [Javalin](https://github.com/tipsy/javalin/commits?author=leafac).
- **Homebrew:** [Homebrew Core](https://github.com/Homebrew/homebrew-core/commits?author=leafac), [Homebrew Casks](https://github.com/Homebrew/homebrew-cask/commits?author=leafac), [Homebrew Fonts](https://github.com/Homebrew/homebrew-cask-fonts/commits?author=leafac).

Archived
--------

- [**Org Password Manager**](https://github.com/leafac/org-password-manager)  
  Password manager for [Org Mode](https://orgmode.org/).

- [**Programmable Foot Keyboard**](https://github.com/leafac/programmable-foot-keyboard)  
  A programmable foot keyboard using [Adafruit’s Trinket](https://learn.adafruit.com/introducing-trinket).

Music
=====

Bushwhacking
------------

<video src="https://archive.org/download/bushwhacking/bushwhacking.mp4" controls preload="none"></video>

My First Robot
--------------

<audio src="https://archive.org/download/leafac-music/my-first-robot.mp3" controls preload="none"></audio>

Agora Há Algo a Temer
---------------------

<audio src="https://archive.org/download/leafac-music/agora-ha-algo-a-temer.mp3" controls preload="none"></audio>

<details markdown="1">
<summary>Lyrics</summary>
```
E D B
A D E

Observo à distância
A situação no meu país
E o que eu vejo
Não me deixa feliz

Salgadinhos verde-e-amarelo
Tentando calar o povo
Voltando trinta anos atrás
Precisam aprender de novo

E-B-C#m-A
D E

O medo agora é real
Agora há algo a Temer
O medo agora é real
Agora há algo a Temer

E D B
A D E

Pedem “Ordem e Progresso”
P’ra homens ricos, burros e preconceituosos
Isto às custas do resto
Que passam fome e pagam o pato de borracha

Somos vítimas de um golpe branco
Em todos os sentidos da palavras
Mas cacetetes não silenciam
Nossa música de efeito moral

E-B-C#m-A
D E

O medo agora é real
Agora há algo a Temer
O medo agora é real
Agora há algo a Temer

C#m C#m7+ C#m7 C#m6 B C°

Pela minha mãe
Pela minha filha, que hoje ’tá fazendo aniversário
Pelos torturadores
Por toda a família
Também pelos fieis que vão na minha igreja
E voluntariamente são assaltados
Contra o desarmamento
Pela maçonaria

Eu acho os seus valores
Tão defasados!

E-B-C#m-A
D E

O medo agora é real
Agora há algo a Temer
O medo agora é real
Agora há algo a Temer

O medo agora é real
Agora há algo a Temer
O medo agora é real
Agora há algo a Temer
```
</details>

O Fim da Tempestade
-------------------

<audio src="https://archive.org/download/leafac-music/o-fim-da-tempestade.mp3" controls preload="none"></audio>

<details markdown="1">
<summary>Samples</summary>
- <https://www.freesound.org/people/ermine/sounds/27418/>
- <https://www.freesound.org/people/AVstudent/sounds/344994/>
</details>

Criatividade
------------

<audio src="https://archive.org/download/leafac-music/criatividade.mp3" controls preload="none"></audio>

<details markdown="1">
<summary>Lyrics</summary>
```
A minha criatividade
Cria atividade
As minhas criações
Criam ações
A minha criação se reflete
No que minhas crias são
E com a idade
Aumenta a criativadade

A
A minha criatividade
Cria atividade
As minhas criações
Criam ações
A minha criação se reflete
No que minhas crias são
E com a idade
Aumenta a criativadade

F# G A
Sem imaginação
Eu fico sem chão
Sem imaginação
Eu fico sem chão
Sem imaginação
Eu fico sem chão
A criatividade é minha cria

E D

E
Eu me alimento
De conhecimento
Transformo informação
Em inspiração
Via transpiração

O meu argumento
É que não há atalho
A canção
É resultado de trabalho
Não de piração

O meu argumento
É que conhecimento
Cria transformação
E o meu trabalho
Transforma a forma
Reação

A
A minha criatividade
G         D
Cria atividade
A
As minhas criações
F      D
Criam ações
A
A minha criação se reflete
G                   D
No que minhas crias são
A
E com a idade
          F         G
Aumenta a criativadade

E Eb D C# C B Bb A
A forma, em forma, informa o conteúdo
Em forma, se forma, de forma informal
Formula, reforma, transforma a formula
De forma que, então, se torna real

G A

E Eb D C# C B Bb A
A forma, em forma, informa o conteúdo
Em forma, se forma, de forma informal
Formula, reforma, transforma a formula
De forma que, então, se torna real

G A G F# F E D

A
A minha criatividade
G         D
Cria atividade
A
As minhas criações
F      D
Criam ações
A
A minha criação se reflete
G                   D
No que minhas crias são
A
E com a idade
          F         G
Aumenta a criativadade
```
</details>

United
------

<audio src="https://archive.org/download/leafac-music/united.mp3" controls preload="none"></audio>

<details markdown="1">
<summary>Lyrics</summary>
```
G     D             G
A United bate qualquer preço
G            D         B7
Bate a concorrência também
Em    Em7+            Em7    A7
A United bate em seus clientes. Gente!
C            D        G
Cuidado que ela não bate bem!

G7

      C              F7+/C
O que a United chama de remanejamento
C            G
Eu acho de UFC
      C              F7+/C
O que a United chama de planejamento
G
É esperar acontecer

C             F7+/C
Se eu fosse voar com a United
C                    G
Eu levaria um soco inglês
C                       F7+/C
O moço da segurança nem reclamaria, ele diria:
G
“Boa sorte p’ra vocês”

C           G/B          Am
E quando eu entrasse no avião
  C             G/B            D
E houvesse um passageiro em meu lugar
C      G/B      Am
Eu estaria preparado
     D7  D7/4  D7
P’ra duelar

G     D             G
A United bate qualquer preço
G            D         B7
Bate a concorrência também
Em    Em7+            Em7    A7
A United bate em seus clientes. Gente!
C            D        G
Cuidado que ela não bate bem!

G7

C                  F7+/C
A United precisa encontrar
C             G
Uma solução pacífica
      C                                 F7+/C
A dificuldade que é a maior parte dos seus voos
G
É sobre o Atlântico

C                                  F7+/C
Truco, lutinha de dedo, *Mortal Kombat*,
                    C       G
Jogo de Tazo, um campeonato de Jenga
 C                              F7+/C
São todos jeitos muito mais recomendáveis
G
De resolver esta encrenca

    C           G/B        Am
Porque quando eu entrar no avião
  C           G/B            D
E houver um passageiro em meu lugar
C            G/B      Am
Eu não vou estar preparado
     D7  D7/4  D7
P’ra duelar

G     D             G
A United bate qualquer preço
G            D         B7
Bate a concorrência também
Em    Em7+            Em7    A7
A United bate em seus clientes. Gente!
C            D        G
Cuidado que ela não bate bem!

> SOLO

G     D             G
A United bate qualquer preço
G            D         B7
Bate a concorrência também
Em    Em7+            Em7    A7
A United bate em seus clientes. Gente!
C            D        G
Cuidado que ela não bate bem!
C            D        G
Cuidado que ela não bate bem!
```
</details>

Publications
============

{% assign publications = page.publications | sort: "issued.date-parts" | reverse %}
{% for publication in publications %}
- **{% if publication.shortTitle %}*{{ publication.title }}* ({{ publication.shortTitle }}){% else %}{{ publication.title }}{% endif %}.** {{ publication.author | map: "literal" | array_to_sentence_string }}. {% if publication.event %}{% if publication.URL %}[{{ publication.event }}]({{ publication.URL }}){% else %}{{ publication.event }}{% endif %}.{% endif %} {% if publication.container-title %}{% if publication.URL %}[{{ publication.container-title }}]({{ publication.URL }}){% else %}{{ publication.container-title }}{% endif %}.{% endif %} {% if publication.collection-title %}{% if publication.URL %}[{{ publication.collection-title }}]({{ publication.URL }}){% else %}{{ publication.collection-title }}{% endif %}.{% endif %} {% if publication.genre %}{{ publication.genre }}.{% endif %} {% if publication.publisher %}{{ publication.publisher }}.{% endif %} {% if publication.event-place %}{{ publication.event-place }}.{% endif %} {% if publication.note %}{{ publication.note }}.{% endif %} {{ publication.issued.date-parts[0][0] }}. {% for attachment in page.attachments[publication.id] %}[[{{ attachment[0] }}]({{ attachment[1] }})]{% endfor %}{% if publication.archive %}[[Publisher]({{ publication.archive }})]{% endif %}

  {% if publication.abstract %}
  <details markdown="1">
  <summary>Abstract</summary>
  {{ publication.abstract }}
  </details>
  {% endif %}

  <details markdown="1">
  <summary>BibTeX</summary>
  ```tex
  {{ page.bibtex[publication.id] }}
  ```
  </details>
{% endfor %}

Service
=======

Reviewer
--------

- [ACM Computing Surveys (CSUR)](https://csur.acm.org/). 2016.

Education
=========

Ph.D. Candidate in Computer Science · Programming Languages
-----------------------------------------------------------

*[Johns Hopkins University](https://jhu.edu).* 2014-09 – 2020-03 (estimated).

- I am part of the [Programming Languages Laboratory](https://pl.cs.jhu.edu/).
- My advisor is [Dr. Scott Smith](https://www.cs.jhu.edu/~scott/).
- We [research](#publications) a program analysis technique called [Demand-Driven Program Analysis](https://pl.cs.jhu.edu/projects/demand-driven-program-analysis/).
- I took courses in programming-language theory, logic, software engineering, cryptography, natural language processing, databases and presentation skills. For fun, I also took courses in music theory and meditation.

  <details markdown="1">
  <summary><strong>Watch my presentations on the Presentation Skills course</strong></summary>

  The recording quality is bad because I was not in control of it.  
  **Presentation for a General Audience**

  <video src="https://archive.org/download/leandro-improving-presentation-skills-for-scientists-and-engineers/general-audience.mp4" controls preload="none"></video>

  **Final Presentation**

  <video src="https://archive.org/download/leandro-improving-presentation-skills-for-scientists-and-engineers/final-presentation.mp4" controls preload="none"></video>

  </details>

- I have been [assisting on courses](#teaching-assistant) on Principles of Programming Languages and Object-Oriented Software Engineering since Fall 2015. I have lectured, helped to prepare exams and homework assignments, helped to grade, advised semester-long group projects, and held office hours.
- I did a qualifying project in cryptography advised by [Dr. Matthew D. Green](https://isi.jhu.edu/~mgreen/) and [Dr. J. Ayo Akinyele](http://hms.isi.jhu.edu/index.php/people/6.html).
- I am system administrator for the laboratory.
- For most of my Ph.D. program, I was supported by a fellowship from the Brazilian Government (CAPES). Process number: 13477/13-7.

M.S. in Computer Science · Programming Languages
------------------------------------------------

*[Johns Hopkins University](https://jhu.edu).* 2014-09 – 2016-10.

- The master’s degree is part of the Ph.D. program.

B.S. in Computer Science
------------------------

*[Universidade de São Paulo](https://www5.usp.br).* 2008-02 – 2012-09.

- I researched in the field of robotics, developing an algorithm for visual navigation for autonomous vehicles. My work was funded by a scholarship provided by the Brazilian Government (INCT-SEC) under a Scientific Initiation program.
- I played the drums in a group similar to a [*Escola de Samba*](https://en.wikipedia.org/wiki/Samba_school).

Teaching Experience
===================

Teaching Assistant
------------------

*[Johns Hopkins University](https://jhu.edu).* 2015-09 – 2019-09.

- On the Fall of 2018, I was the Teaching Assistant for the [Object Oriented Software Engineering](https://pl.cs.jhu.edu/oose/index.shtml) course.

  I received an **Whiting School of Engineering’s Professor Joel Dean Excellence in Teaching Award** for my performance as a Teaching Assitant on this course.

  I managed a team of four homework graders, assisted on managing a team of four group project advisors, and wrote part of the curriculum: I developed an application that served as the guiding example for several lectures and the group projects ([live version](https://leafac-oose-todo.herokuapp.com) · [source code](https://github.com/leafac/todo)), I wrote the first two assignments ([live version](https://leafac-oose-lights-out.herokuapp.com) · [handout](https://github.com/leafac/lights-out)), and I lectured and recorded video lectures on Git, JavaScript and application deployment.

  <details markdown="1">
  <summary><strong>Watch my lectures</strong></summary>

  The audio quality in some of these videos is bad because I was learning and experimenting with recording techniques and equipment.  
  **Deployment**

  <video src="https://archive.org/download/deployment-to-heroku/deployment.mp4" controls preload="none"></video>

  **JavaScript**  
  *Classroom Lecture*

  <video src="https://archive.org/download/javascript-video-series/javascript--lecture.mp4" controls preload="none"></video>

  *Video Lectures*

  1. **Introduction** <video src="https://archive.org/download/javascript-video-series/javascript--1--introduction.mp4" controls preload="none"></video>
  2. **`setTimeout`** <video src="https://archive.org/download/javascript-video-series/javascript--2--set-timeout.mp4" controls preload="none"></video>
  3. **Creating Promises** <video src="https://archive.org/download/javascript-video-series/javascript--3--creating-promises.mp4" controls preload="none"></video>
  4. **`var`** <video src="https://archive.org/download/javascript-video-series/javascript--4--var.mp4" controls preload="none"></video>
  5. **DOM · Part 1** <video src="https://archive.org/download/javascript-video-series/javascript--5--dom--part-1.mp4" controls preload="none"></video>
  6. **DOM · Part 2** <video src="https://archive.org/download/javascript-video-series/javascript--6--dom--part-2.mp4" controls preload="none"></video>
  7. **Web Sockets · Part 1** <video src="https://archive.org/download/javascript-video-series/javascript--7--web-sockets--part-1.mp4" controls preload="none"></video>
  8. **Web Sockets · Part 2** <video src="https://archive.org/download/javascript-video-series/javascript--8--web-sockets--part-2.mp4" controls preload="none"></video>
  9. **Classes · Part 1** <video src="https://archive.org/download/javascript-video-series/javascript--9--classes--part-1.mp4" controls preload="none"></video>
  10. **Classes · Part 2** <video src="https://archive.org/download/javascript-video-series/javascript--10--classes--part-2.mp4" controls preload="none"></video>
  11. **Classes · Part 3** <video src="https://archive.org/download/javascript-video-series/javascript--11--classes--part-3.mp4" controls preload="none"></video>
  12. **Classes · Part 4** <video src="https://archive.org/download/javascript-video-series/javascript--12--classes--part-4.mp4" controls preload="none"></video>
  13. **Modules** <video src="https://archive.org/download/javascript-video-series/javascript--13--modules.mp4" controls preload="none"></video>

  **Git**  
  *Classroom Lecture*

  <video src="https://archive.org/download/git-video-series/git--lecture.mp4" controls preload="none"></video>

  *Video Lectures*

  1. **Introduction** <video src="https://archive.org/download/git-video-series/git--1--introduction.mp4" controls preload="none"></video>
  2. **Setup** <video src="https://archive.org/download/git-video-series/git--2--setup.mp4" controls preload="none"></video>
  3. **Repository** <video src="https://archive.org/download/git-video-series/git--3--repository.mp4" controls preload="none"></video>
  4. **Commit** <video src="https://archive.org/download/git-video-series/git--4--commit.mp4" controls preload="none"></video>
  5. **Publishing to GitHub** <video src="https://archive.org/download/git-video-series/git--5--publish-to-github.mp4" controls preload="none"></video>
  6. **Cloning from GitHub** <video src="https://archive.org/download/git-video-series/git--6--cloning-from-github.mp4" controls preload="none"></video>
  7. **Coordinating Collaboration** <video src="https://archive.org/download/git-video-series/git--7--coordinating-collaboration.mp4" controls preload="none"></video>
  8. **Branches and Pull Requests** <video src="https://archive.org/download/git-video-series/git--8--branches-and-pull-requests.mp4" controls preload="none"></video>
  9. **Rebasing** <video src="https://archive.org/download/git-video-series/git--9--rebasing.mp4" controls preload="none"></video>
  10. **Conclusion** <video src="https://archive.org/download/git-video-series/git--10--conclusion.mp4" controls preload="none"></video>

  </details>

- On the Springs I assisted on the [Principles of Programming Languages](https://pl.cs.jhu.edu/pl/index.shtml) course, and on the Falls I assisted on the [Object Oriented Software Engineering](https://pl.cs.jhu.edu/oose/index.shtml) course.
- My degree of involvement with the courses varied over the years. I lectured, prepared and graded exams and homework assignments, managed a team of four course assistants for assignment grading, advised semester-long group projects, and held office hours.

Work Experience
===============

[Raise Sistemas](https://raisesistemas.com.br)
----------------------------------------------

*Software developer.* 2014-02 – 2014-08.

- [Raise Sistemas](https://raisesistemas.com.br) is a product start-up.
- I developed new features and maintained an existing medium-sized Ruby on Rails application.
- I improved the performance of a subsystem for importing users by a factor of 30x.
- I was part of an agile team that did regular code-reviews, continuous integration and continuous delivery.
- I worked remotely, while traveling.
- I had to leave Raise Sistemas after six months because I got accepted into a Ph.D. program.

Das Dad
-------

*Software Developer.* 2013-02 – 2013-12.

- Das Dad was a product start-up. Unfortunately, the angel investor behind it folded and the product was never completed.
- I contributed to a Ruby on Rails front-end application, and back-end services in Ruby and Java.
- The applications used natural language processing and artificial intelligence for recommendation, summarization and sentiment analysis.
- I worked on infrastructure, implementing systems for continuous integration and continuous delivery.
- I helped to manage outreach activities for the local programming community including coding dojos and hackathons.

[Universo Online (UOL)](https://www.uol.com.br/)
------------------------------------------------

*Junior System Analyst.* 2012-03 – 2013-02.

- [UOL](https://www.uol.com.br/) is a major Internet publishing company in Brazil.
- I used Java EE to build and maintain web products with millions of users.
- I improved the front-end development process by introducing new technologies and building internal tools.

[Daitan Group](http://www.daitangroup.com/)
-------------------------------------------

*Intern in Software Development.* 2011-07 – 2012-02.

- [Daitan Group](http://www.daitangroup.com/) is an outsourcing company for Telecom applications.
- I worked directly with customers from the Silicon Valley.
- I developed a web service in Java EE for a telecom platform and a PHP web administration tool for a video conference system.
- I taught a course about version control in Git.

Awards
======

- **Whiting School of Engineering’s Professor Joel Dean Excellence in Teaching Award.** 2019-05-06.

Certifications
==============

- **TOEFL.** Reading: 28/30. Listening: 29/30. Speaking: 24/30. Writing: 27/30. Total: 108/120. 2013-03.
- **GRE.** Verbal reasoning: 154/170. Quantitative reasoning: 166/170. Analytical writing: 3.5/6. 2013-09.
- **Oracle Certified Java Programmer.** Score: 90%. 2012-06.

Events
======

- **[The Racket School 2018: Create your own language](https://summer-school.racket-lang.org/2018/).** 2018-07-09 – 2018-07-13.
- **[24th Static Analysis Symposium](https://staticanalysis.org/sas2017/sas2017.html).** Zachary Palmer presented a paper that I co-authored, *Relative Store Fragments for Singleton Abstraction*. 2017-08-30 – 2017-09-01.
- **[The Racket School of Semantics and Languages 2017](https://summer-school.racket-lang.org/2017/).** 2017-07-10 – 2017-07-14.
- **[The 17th Symposium on Trends in Functional Programming (TFP 2016)](http://tfp2016.org/).** Alexander Rozenshteyn presented a paper that I co-authored, *What is Your Function? Static Pattern Matching on Function Behavior*. 2016-06-08, 2016-06-10.
- **JHU ACM Meeting.** I talked about Git and Racket. 2016.
- **[IBM Programming Languages Day 2015](https://researcher.watson.ibm.com/researcher/view_group_subpage.php?id=6432).** 2015-11-23.
- **The Developer’s Conference Florianópolis 2014.** I talked about HTTP/2 and the future of web technologies. 2014-05.
- **iMasters InterCon 2013.** 2013-11.
- **iMasters InterCon + Android 2013.** 2013-09.
- **RubyConf Brazil 2013.** 2013-08.
- **Coding Dojo at FAI.** Co-hosted a day of activities for undergraduate Computer Science students, including a lecture about Git and a Coding Dojo. 2013-08.
- **7Masters.** I talked about modern Java development techniques and tools. 2013-01.

  <details markdown="1">
  <summary><strong>Watch my talk</strong></summary>
  <video src="https://archive.org/download/7masters--java--leandro-facchinetti/7masters.mp4" controls preload="none"></video>
  </details>

- **Dev in Sampa 2012.** 2012-05.
- **RubyConf Brazil 2012.** 2012-08.
- **Coding Dojo@SP.** I promoted, hosted and participated in several Coding Dojos for the local developer community. 2012 – 2013.
- **GURU SP.** 2012 – 2013.
- ***Profissão Java* (Java Career).** 2012-08.
- ***Conexão Java* (Java Connection).** 2012-05.
- ***18º Simpósio Internacional de Iniciação Científica da Universidade de São Paulo* (18th International Scientific Initiation Symposium from Universidade de São Paulo).** I presented the paper *Sistema de Navegação Visual Baseado em Correlação de Imagens Visando a Aplicação em Veículos Autônomos Inteligentes (Visual Navigation System Based on Image Correlation Targeted to Intelligent Autonomous Vehicles)*. 2010-11.
- **[III Workshop on Computational Intelligence—WCI. Joint Conference 2010—SBIA—SBRN—JRI](http://www.jointconference.fei.edu.br/wci/index.html).** I presented the paper *Navegação Visual de Robôs Móveis Autônomos Baseada em Métodos de Correlação de Imagens (Visual Navigation of Autonomous Mobile Robots Based on Image Correlation Methods)*. 2010-10-24.
- ***IV Workshop de Iniciação Científica e Tecnológica de Computação* (WICT) (IV Scientific and Technologic Initiation Workshop).** I resented the paper *Pesquisa e Desenvolvimento de Robôs Móveis Autônomos com Navegação Baseada em Correlação de Imagens (Research and Development of Autonomous Mobile Robots with Image-Correlation-Based Navigation)*. 2010-09-22.
- **II Computer Science Bachelor’s Workshop from Universidade de São Paulo.** I represented students in discussions with faculty about improving the structure of the Computer Science curriculum. 2009.
- **PHP Conference Brazil.** 2006.

Courses
=======

- **Improving Presentation Skills for Scientists and Engineers.** Johns Hopkins University. 2018.
- **Writing in the Sciences.** Stanford University via Coursera. 2018.
- **Rudiments of Music Theory and Musicianship.** Johns Hopkins University. 2016.
- **Introduction to Ableton Live.** Berklee College of Music via Coursera. 2016.
- **Introduction to Music Production.** Berklee College of Music via Coursera. 2015.
- **Natural Language Processing.** Columbia University via Coursera. 2013.
- **FJ-25—Java Advanced—Persistence with Hibernate and JPA.** Caelum. 2012.
- **Software Engineering for Software as a Service (Part I).** University of California, Berkley via Coursera. 2012.
- **Secure Development for Web Programmers.** Universo Online (UOL). 2012.
- **Scrum and Agile Methodologies.** Universo Online (UOL). 2012.
- **ITIL.** Universo Online (UOL). 2012.
- **MC128—Introduction to Java EE.** Globalcode in the open4education program. 2012.
- **Java Programming Intro Course.** SENAI. 2006.
- **Tableless I.** Visie. 2006.
- **Advanced English Course.** CNA. 2004.

License
=======

**Source:** <https://github.com/leafac/www.leafac.com>

**Prose:** [GNU FDL](https://www.gnu.org/licenses/fdl.html)

**Code:** [GNU GPL](https://www.gnu.org/licenses/gpl.html)

```
Copyright (C) {{ site.time | date: "%Y" }} Leandro Facchinetti

Permission is granted to copy, distribute and/or modify this document
under the terms of the GNU Free Documentation License, Version 1.3
or any later version published by the Free Software Foundation;
with no Invariant Sections, no Front-Cover Texts, and no Back-Cover Texts.

A copy of the license is included in the section entitled "GNU
Free Documentation License".
```

```
Copyright (C) {{ site.time | date: "%Y" }} Leandro Facchinetti

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
```

Colophon
========

**Page Layout:**  Inspired by the works of [Matthew Butterick](https://typographyforlawyers.com/about.html) and [Edward Rolf Tufte](https://www.edwardtufte.com/).

**Serif Font:** [Charter](https://practicaltypography.com/charter.html).

**Monospaced Font:** [`Iosevka Term Slab`](https://typeof.net/Iosevka).

**Static website generator:** [Jekyll](https://jekyllrb.com).

**Host:** [GitHub Pages](https://pages.github.com).

**Text Editor:** [Visual Studio Code](https://code.visualstudio.com).

**Drawings:** [Procreate](https://procreate.art).

**Vector Graphics:** [Inkscape](https://inkscape.org).
