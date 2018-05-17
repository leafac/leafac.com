---
# 1. [Zotero] Export Items to CSL JSON & BibTeX
# 2. Upload ‘files’ to ‘files.leafac.com’
# 3. Convert CSL JSON into YAML: ‘ruby -r yaml -e 'puts YAML.dump(YAML.load(STDIN.read))'’
# 4. Copy ‘bibtex’ entry.
# 5. Create ‘attachments’ entry.
layout: default
title: "Research"
date: 2018-05-17
publications:
  - id: http://zotero.org/users/4828827/items/GJMBE3DC
    type: report
    title: 'SDL: A DSL for Cryptographic Schemes'
    publisher: The Johns Hopkins University
    genre: Research project report to fulfill a qualifying requirement of the Ph.D.
      program
    abstract: 'In the past few years there has been an increasing interest in automating
      the development and implementation of cryptographic schemes, which traditionally
      are manual, difficult and error-prone tasks. Projects including AutoBatch and
      AutoGroup+ mechanically generate cryptographic schemes, and use a Domain-Specific
      Language (DSL) called the Scheme Description Language (SDL) to represent them;
      but, despite being a critical component in these systems, SDL is significantly
      limited. We introduce a redesigned SDL which addresses these shortcomings: we
      extend the language with new features, provide a formal specification, define
      a type system and several other static analyses, allow it to express various kinds
      of cryptographic schemes, and present techniques for manipulation via term rewriting.
      Finally, we explore two applications: a simple transformer to assert the consistent
      use of group operators (additive vs. multiplicative notation); and a generalization
      of AutoBatch, which includes more sophisticated term rewriting. Operations that
      previously required hundreds of lines of code in the original AutoBatch implementation
      are expressed with our techniques in less then ten lines. Overall, the redesigned
      SDL is a more solid and practical foundation upon which to build cryptographic-system
      development automations.'
    author:
    - literal: Leandro Facchinetti
    issued:
      date-parts:
      - - '2017'
        - 11
        - 14
    bibtex: |-
      @techreport{leandro_facchinetti_sdl:_2017,
      	type = {Research project report to fulfill a qualifying requirement of the {Ph}.{D}. program},
      	title = {{SDL}: {A} {DSL} for {Cryptographic} {Schemes}},
      	abstract = {In the past few years there has been an increasing interest in automating the development and implementation of cryptographic schemes, which traditionally are manual, difficult and error-prone tasks. Projects including AutoBatch and AutoGroup+ mechanically generate cryptographic schemes, and use a Domain-Specific Language (DSL) called the Scheme Description Language (SDL) to represent them; but, despite being a critical component in these systems, SDL is significantly limited. We introduce a redesigned SDL which addresses these shortcomings: we extend the language with new features, provide a formal specification, define a type system and several other static analyses, allow it to express various kinds of cryptographic schemes, and present techniques for manipulation via term rewriting. Finally, we explore two applications: a simple transformer to assert the consistent use of group operators (additive vs. multiplicative notation); and a generalization of AutoBatch, which includes more sophisticated term rewriting. Operations that previously required hundreds of lines of code in the original AutoBatch implementation are expressed with our techniques in less then ten lines. Overall, the redesigned SDL is a more solid and practical foundation upon which to build cryptographic-system development automations.},
      	institution = {The Johns Hopkins University},
      	author = {{Leandro Facchinetti}},
      	month = nov,
      	year = {2017},
      }
    attachments: [["PDF", "Facchinetti - SDL A DSL for Cryptographic Schemes.pdf"]]
  - id: http://zotero.org/users/4828827/items/TJW5USER
    type: paper-conference
    title: Relative Store Fragments for Singleton Abstraction
    container-title: 24th Static Analysis Symposium
    archive: https://link.springer.com/chapter/10.1007%2F978-3-319-66706-5_6
    abstract: 'A *singleton abstraction* occurs in a program analysis when some results
      of the analysis are known to be exact: an abstract binding corresponds to a single
      concrete binding. In this paper, we develop a novel approach to constructing singleton
      abstractions via *relative store fragments*. Each store fragment is a *locally*
      exact store abstraction in that it contains only those abstract variable bindings
      necessary to address a particular question at a particular program point; it is
      *relative* to that program point and the point of view may be shifted. We show
      how an analysis incorporating relative store fragments achieves flow-, context-,
      path- and must-alias sensitivity, and can be used as a basis for environment analysis,
      without any machinery put in place for those specific aims. We build upon recent
      advances in *demand-driven* higher-order program analysis to achieve this construction
      as it is fundamentally tied to demand-driven lookup of variable values.'
    URL: http://staticanalysis.org/sas2017/sas2017.html
    author:
    - literal: Leandro Facchinetti
    - literal: Zachary Palmer
    - literal: Scott F. Smith
    issued:
      date-parts:
      - - '2017'
        - 11
        - 1
    bibtex: |-
      @inproceedings{leandro_facchinetti_relative_2017,
          title = {Relative {Store} {Fragments} for {Singleton} {Abstraction}},
          url = {http://staticanalysis.org/sas2017/sas2017.html},
          abstract = {A *singleton abstraction* occurs in a program analysis when some results of the analysis are known to be exact: an abstract binding corresponds to a single concrete binding. In this paper, we develop a novel approach to constructing singleton abstractions via *relative store fragments*. Each store fragment is a *locally* exact store abstraction in that it contains only those abstract variable bindings necessary to address a particular question at a particular program point; it is *relative* to that program point and the point of view may be shifted. We show how an analysis incorporating relative store fragments achieves flow-, context-, path- and must-alias sensitivity, and can be used as a basis for environment analysis, without any machinery put in place for those specific aims. We build upon recent advances in *demand-driven* higher-order program analysis to achieve this construction as it is fundamentally tied to demand-driven lookup of variable values.},
          booktitle = {24th {Static} {Analysis} {Symposium}},
          author = {{Leandro Facchinetti} and {Zachary Palmer} and {Scott F. Smith}},
          month = nov,
          year = {2017},
      }
    attachments: [["PDF", "Facchinetti et al. - 2017 - Relative Store Fragments for Singleton Abstraction.pdf"]]
  - id: http://zotero.org/users/4828827/items/NPG5Y85P
    type: speech
    title: Towards Practical Higher-Order Demand-Driven Program Analysis
    publisher-place: The Johns Hopkins University
    genre: Preliminary research proposal for Graduate Board Oral (GBO) examination,
      a qualifying requirement for the Ph.D. program
    event-place: The Johns Hopkins University
    abstract: We propose to research an abstract-interpretation-based static analysis
      for higher-order programming languages which performs demand-driven (backward)
      variable lookups, addressing issues of performance and expressiveness towards
      a foundational theory for practical analysis tools. State-of-the-art program analyses
      in the higher-order space generally carry variable environments forward, and only
      recently our research introduced an alternative backward approach, but, while
      preliminary investigation indicates that our technique has fundamentally different
      and promising trade-offs, the connection between forward and backward analysis
      is not well understood; we intend to examine this question, contemplating a hybrid
      approach which would combine the strengths of both methods. We also propose to
      address shortcomings of the existing backward technique, in particular regarding
      recursive programs, by introducing improved models for calling contexts and by
      adapting parameters in the course of variable lookup. Finally, we plan to probe
      other grounding theoretical frameworks besides the pushdown-automata reachability
      we currently use, including logic programming and grammar-based strategies.
    author:
    - literal: Leandro Facchinetti
    issued:
      date-parts:
      - - '2017'
        - 10
        - 27
    bibtex: |-
      @misc{leandro_facchinetti_towards_2017,
      	address = {The Johns Hopkins University},
      	type = {Preliminary research proposal for {Graduate} {Board} {Oral} ({GBO}) examination, a qualifying requirement for the {Ph}.{D}. program},
      	title = {Towards {Practical} {Higher}-{Order} {Demand}-{Driven} {Program} {Analysis}},
      	abstract = {We propose to research an abstract-interpretation-based static analysis for higher-order programming languages which performs demand-driven (backward) variable lookups, addressing issues of performance and expressiveness towards a foundational theory for practical analysis tools. State-of-the-art program analyses in the higher-order space generally carry variable environments forward, and only recently our research introduced an alternative backward approach, but, while preliminary investigation indicates that our technique has fundamentally different and promising trade-offs, the connection between forward and backward analysis is not well understood; we intend to examine this question, contemplating a hybrid approach which would combine the strengths of both methods. We also propose to address shortcomings of the existing backward technique, in particular regarding recursive programs, by introducing improved models for calling contexts and by adapting parameters in the course of variable lookup. Finally, we plan to probe other grounding theoretical frameworks besides the pushdown-automata reachability we currently use, including logic programming and grammar-based strategies.},
      	author = {{Leandro Facchinetti}},
      	month = oct,
      	year = {2017},
      }
    attachments: [["PDF", "Facchinetti - Towards Practical Higher-Order Demand-Driven Progr.pdf"], ["Slides", "towards-practical-higher-order-demand-driven-program-analysis.key"]]
  - id: http://zotero.org/users/4828827/items/V865FGTI
    type: report
    title: Practical Demand-Driven Program Analysis with Recursion
    publisher: The Johns Hopkins University
    genre: Research project report to fulfill a qualifying requirement of the Ph.D.
      program
    abstract: 'Demand-Driven Program Analysis (DDPA) is a context-sensitive control-ﬂow
      analysis for higher-order functional programming languages in the same space as
      *k*-CFA and related analyses. DDPA is provably sound and polynomial, but that
      alone does not guarantee its applicability to real-world programs. This project
      studies DDPA’s practicality in two dimensions: expressiveness (the analysis closely
      approximates the run-time) and performance (the analysis is fast to compute).
      To address expressiveness, we extended the analysis to directly support recursion,
      eliminating the need for encodings. To address performance, we developed a higher-level
      programming language that compiles to DDPA’s core language, ported over benchmarks
      that exercise all its features, and measured the reference implementation’s performance,
      comparing to other state-ofthe-art program analyses. DDPA is competitive and,
      in some cases, faster than the alternatives.'
    author:
    - literal: Leandro Facchinetti
    issued:
      date-parts:
      - - '2016'
        - 10
        - 7
    bibtex: |-
      @techreport{leandro_facchinetti_practical_2016,
      	type = {Research project report to fulfill a qualifying requirement of the {Ph}.{D}. program},
      	title = {Practical {Demand}-{Driven} {Program} {Analysis} with {Recursion}},
      	abstract = {Demand-Driven Program Analysis (DDPA) is a context-sensitive control-ﬂow analysis for higher-order functional programming languages in the same space as *k*-CFA and related analyses. DDPA is provably sound and polynomial, but that alone does not guarantee its applicability to real-world programs. This project studies DDPA’s practicality in two dimensions: expressiveness (the analysis closely approximates the run-time) and performance (the analysis is fast to compute). To address expressiveness, we extended the analysis to directly support recursion, eliminating the need for encodings. To address performance, we developed a higher-level programming language that compiles to DDPA’s core language, ported over benchmarks that exercise all its features, and measured the reference implementation’s performance, comparing to other state-ofthe-art program analyses. DDPA is competitive and, in some cases, faster than the alternatives.},
      	institution = {The Johns Hopkins University},
      	author = {{Leandro Facchinetti}},
      	month = oct,
      	year = {2016},
      }
    attachments: [["PDF", "Facchinetti - Practical Demand-Driven Program Analysis with Recu.pdf"]]
  - id: http://zotero.org/users/4828827/items/AEVV98PS
    type: book
    title: Higher-Order Demand-Driven Program Analysis (Artifact)
    collection-title: ECOOP 2016 Artifacts
    archive: http://2016.ecoop.org/event/ecoop-2016-artifacts-higher-order-demand-driven-program-analysis
    abstract: This artifact is a proof-of-concept implementation of DDPA, an on-demand
      program analysis for higher-order functional programs. The implementation, written
      in OCaml, includes a parser, evaluator, and DDPA analysis for the language defined
      in the companion paper (including the proper record semantics extension). The
      analysis may be performed using different levels of precision as specified by
      the user and is capable of rendering the control flow graphs and pushdown systems
      using the GraphViz language DOT. This artifact was used to verify the conclusions
      of the companion paper and produces visualizations matching those figures in the
      companion paper's overview.
    URL: https://2016.ecoop.org/track/ecoop-2016-artifacts
    note: Also appeared at the [Dagstuhl Artifacts Series](http://drops.dagstuhl.de/opus/volltexte/2016/6130/)
    author:
    - literal: Leandro Facchinetti
    - literal: Zachary Palmer
    - literal: Scott F. Smith
    issued:
      date-parts:
      - - '2016'
        - 6
        - 20
    bibtex: |-
      @misc{leandro_facchinetti_higher-order_2016,
      	title = {Higher-{Order} {Demand}-{Driven} {Program} {Analysis} ({Artifact})},
      	url = {https://2016.ecoop.org/track/ecoop-2016-artifacts},
      	abstract = {This artifact is a proof-of-concept implementation of DDPA, an on-demand program analysis for higher-order functional programs. The implementation, written in OCaml, includes a parser, evaluator, and DDPA analysis for the language defined in the companion paper (including the proper record semantics extension). The analysis may be performed using different levels of precision as specified by the user and is capable of rendering the control flow graphs and pushdown systems using the GraphViz language DOT. This artifact was used to verify the conclusions of the companion paper and produces visualizations matching those figures in the companion paper's overview.},
      	author = {{Leandro Facchinetti} and {Zachary Palmer} and {Scott F. Smith}},
      	month = jun,
      	year = {2016},
      	note = {Also appeared at the [Dagstuhl Artifacts Series](http://drops.dagstuhl.de/opus/volltexte/2016/6130/)},
      }
    attachments: [["PDF", "Leandro Facchinetti et al. - 2016 - Higher-Order Demand-Driven Program Analysis (Artif.pdf"], ["TGZ", "DARTS-2-1-9-artifact-88e98fe9019cb2bb1e758be0ca6325f9.tgz"]]
  - id: http://zotero.org/users/4828827/items/RKXIFGKR
    type: speech
    title: What is Your Function? Static Pattern Matching on Function Behavior
    event: The 17th Symposium on Trends in Functional Programming (TFP 2016)
    abstract: "We define a new notion of *function pattern*, which supports run-time
      pattern matching on functions based on their behavior. The ability to run-time
      dispatch on function type information enables new programmer expressiveness, including
      support of overloading on higher-order functions as well as other useful patterns.
      \ \nWe formally present a type inference system for function patterns. The system
      answers questions of function pattern matching by recursively invoking the type
      inference algorithm. The recursive invocation contains some delicate issues of
      self-referentiality that we address."
    URL: http://tfp2016.org/
    author:
    - literal: Leandro Facchinetti
    - literal: Pottayil Harisanker Menon
    - literal: Zachary Palmer
    - literal: Alexander Rozenshteyn
    - literal: Scott F. Smith
    issued:
      date-parts:
      - - '2016'
        - 6
        - 8
    bibtex: |-
      @misc{leandro_facchinetti_what_2016,
      	title = {What is {Your} {Function}? {Static} {Pattern} {Matching} on {Function} {Behavior}},
      	url = {http://tfp2016.org/},
      	abstract = {We define a new notion of *function pattern*, which supports run-time pattern matching on functions based on their behavior. The ability to run-time dispatch on function type information enables new programmer expressiveness, including support of overloading on higher-order functions as well as other useful patterns.  
      We formally present a type inference system for function patterns. The system answers questions of function pattern matching by recursively invoking the type inference algorithm. The recursive invocation contains some delicate issues of self-referentiality that we address.},
      	author = {{Leandro Facchinetti} and {Pottayil Harisanker Menon} and {Zachary Palmer} and {Alexander Rozenshteyn} and {Scott F. Smith}},
      	month = jun,
      	year = {2016},
      }
    attachments: [["PDF", "Facchinetti et al. - What is Your Function Static Pattern Matching on .pdf"]]
  - id: http://zotero.org/users/4828827/items/IZSR5PBU
    type: paper-conference
    title: Pesquisa e Desenvolvimento de Robôs Táticos para Ambientes Internos
    container-title: Internal Workshop of INCT-SEC
    abstract: "*Este artigo apresenta os trabalhos de pesquisa e desenvolvimento realizados
      junto ao INCT-SEC voltados para aplicações de monitoramento e segurança de ambientes
      internos (indoor) com o uso de robôs móveis. Os trabalhos desenvolvidos visam
      prover os robôs móveis de uma arquitetura de software que implemente um sistema
      de controle inteligente. O robô móvel deve poder ser controlado em modo tele-operado
      (operação remota semi-autônoma) ou em modo completamente autônomo. Este sistema
      deve ser capaz de detectar intrusos e situações anômalas, navegar no ambiente
      desviando dos obstáculos, garantindo assim a integridade do robô e dos elementos
      presentes no ambiente.*  \nThis paper describes the INCT-SEC research and development
      efforts in order to create a mobile robotic platform applied to inspect and to
      protect indoor environments. We proposed a robotic control architecture and implemented
      some computational software modules which are used to provide “intelligent behaviors”
      to the mobile robots. The robot can be remotely controlled based on a semi-autonomous
      approach, and also it can perform the surveillance tasks in a completely autonomous
      mode. The system is able to detect intruders and anomalous situations, and also,
      perform the patrolling task avoiding obstacles and also preserving the integrity
      of the robot and other environment elements (e.g. people, objects)."
    shortTitle: Research and Development of Tactical Robots for Indoor Environments
    author:
    - literal: Fernando Osório
    - literal: Denis Wolf
    - literal: Kalinka Castelo Branco
    - literal: Jó Ueyama
    - literal: Gustavo Pessin
    - literal: Leandro Fernandes
    - literal: Maurício Dias
    - literal: Leandro Couto
    - literal: Daniel Sales
    - literal: Diogo Correa
    - literal: Matheus Nin
    - literal: Leandro Lourenço Silva
    - literal: Leonardo Bonetti
    - literal: Leandro Facchinetti
    - literal: Fabiano Hessel
    issued:
      date-parts:
      - - '2011'
        - 12
        - 7
    bibtex: |-
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
    attachments: [["PDF", "Osório et al. - Pesquisa e Desenvolvimento de Robôs Táticos para A.pdf"]]
  - id: http://zotero.org/users/4828827/items/VUC75E8B
    type: speech
    title: Sistema de Navegação Visual baseado em Correlação de Imagens Visando a Aplicação
      em Veículos Autônomos Inteligentes
    event: "*18º Simpósio Internacional de Iniciação Científica da Universidade de São
      Paulo* (SIICUSP) (18th International Scientific Initiation Symposium from Universidade
      de São Paulo)"
    shortTitle: Visual Navigation System Based on Image Correlation Targeted to Intelligent
      Autonomous Vehicles
    author:
    - literal: Leandro Facchinetti
    - literal: Fernando Santos Osório
    issued:
      date-parts:
      - - '2010'
        - 11
        - 16
    bibtex: |-
      @misc{leandro_facchinetti_sistema_2010,
      	title = {Sistema de {Navegação} {Visual} baseado em {Correlação} de {Imagens} {Visando} a {Aplicação} em {Veículos} {Autônomos} {Inteligentes}},
      	shorttitle = {Visual {Navigation} {System} {Based} on {Image} {Correlation} {Targeted} to {Intelligent} {Autonomous} {Vehicles}},
      	author = {{Leandro Facchinetti} and {Fernando Santos Osório}},
      	month = nov,
      	year = {2010},
      }
    attachments: [["PDF", "Facchinetti and Osório - Sistema de Navegação Visual baseado em Correlação .pdf"]]
  - id: http://zotero.org/users/4828827/items/25ZBP9BS
    type: paper-conference
    title: Navegação Visual de Robôs Móveis Autônomos Baseada em Métodos de Correlação
      de Imagens
    container-title: III Workshop on Computational Intelligence—WCI. Joint Conference
      2010—SBIA—SBRN—JRI
    abstract: "*Uma área importante de pesquisas na robótica é a navegação autônoma
      de veículos, onde o objetivo principal é fazer com que um robô móvel ou veículo
      seja capaz de se locomover sem a necessidade de alguém controlá-lo. Uma das abordagens
      que se destaca consiste em equipar o veículo com câmeras e a partir do processamento
      das imagens geradas orientar e controlar sua movimentação. Com este propósito,
      o presente trabalho propõe mecanismos para encontrar correlações entre imagens
      que ajudem a ajustar a rota (posição e orientação) de um veículo autônomo. A partir
      de uma região de interesse escolhida em uma imagem previamente armazenada do caminho
      a ser percorrido, o programa deve procurar uma área correspondente desta cena
      em outra imagem capturada em tempo real pelo veículo. A correlação entre as imagens
      previamente registradas do caminho e as imagens observadas pelo veículo, permitem
      que se determine o ajuste de sua orientação e o controle de seu avanço em uma
      determinada direção. Neste trabalho são propostos dois algoritmos de correlação
      que foram desenvolvidos e testados visando este tipo de aplicação, tendo seus
      desempenhos comparados. Buscou-se otimizar o desempenho destes algoritmos a fim
      de viabilizar a sua utilização em aplicações de controle de veículos móveis em
      tempo real.*"
    URL: http://www.jointconference.fei.edu.br/wci/index.html
    shortTitle: Visual Navigation of Autonomous Mobile Robots Based on Image Correlation
      Methods
    author:
    - literal: Leandro Facchinetti
    - literal: Fernando Santos Osório
    issued:
      date-parts:
      - - '2010'
        - 10
        - 24
    bibtex: |-
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
    attachments: [["PDF", "Facchinetti and Osório - 2010 - Navegação Visual de Robôs Móveis Autônomos Baseada.pdf"]]
  - id: http://zotero.org/users/4828827/items/YNQJ9ISI
    type: speech
    title: Pesquisa e Desenvolvimento de Robôs Móveis Autônomos com Navegação Baseada
      em Correlação de Imagens
    event: "*IV Workshop de Iniciação Científica e Tecnológica de Computação* (WICT)
      (IV Scientific and Technologic Initiation Workshop)"
    shortTitle: Research and Development of Autonomous Mobile Robots with Image-Correlation-Based
      Navigation
    author:
    - literal: Leandro Facchinetti
    - literal: Fernando Santos Osório
    issued:
      date-parts:
      - - '2010'
        - 9
        - 22
    bibtex: |-
      @misc{leandro_facchinetti_pesquisa_2010,
      	title = {Pesquisa e {Desenvolvimento} de {Robôs} {Móveis} {Autônomos} com {Navegação} {Baseada} em {Correlação} de {Imagens}},
      	shorttitle = {Research and {Development} of {Autonomous} {Mobile} {Robots} with {Image}-{Correlation}-{Based} {Navigation}},
      	author = {{Leandro Facchinetti} and {Fernando Santos Osório}},
      	month = sep,
      	year = {2010},
      }
---

Publications
============

{% for publication in page.publications %}
- **{% if publication.shortTitle %}*{{ publication.title }}* ({{ publication.shortTitle }}){% else %}{{ publication.title }}{% endif %}**. {{ publication.author | map: "literal" | array_to_sentence_string }}. {% if publication.event %}{% if publication.URL %}[{{ publication.event }}]({{ publication.URL | url_encode }}){% else %}{{ publication.event }}{% endif %}.{% endif %} {% if publication.container-title %}{% if publication.container-title %}[{{ publication.container-title }}]({{ publication.URL | url_encode }}){% else %}{{ publication.container-title }}{% endif %}.{% endif %} {% if publication.collection-title %}{% if publication.URL %}[{{ publication.collection-title }}]({{ publication.URL | url_encode }}){% else %}{{ publication.collection-title }}{% endif %}.{% endif %} {% if publication.genre %}{{ publication.genre }}.{% endif %} {% if publication.publisher %}{{ publication.publisher }}.{% endif %} {% if publication.event-place %}{{ publication.event-place }}.{% endif %} {% if publication.note %}{{ publication.note }}.{% endif %} {{ publication.issued.date-parts[0][0] }}. {% for attachment in publication.attachments %}[[{{ attachment[0] }}](https://f001.backblazeb2.com/file/files-leafac-com/research/{{ attachment[1] | url_encode }})]{% endfor %}{% if publication.archive %}[[Publisher]({{ publication.archive | url_encode }})]{% endif %}

  {% if publication.abstract %}
  <details markdown="1">
  <summary>Abstract</summary>
  {{ publication.abstract }}
  </details>
  {% endif %}

  <details markdown="1">
  <summary>BibTeX</summary>
  ```tex
  {{ publication.bibtex }}
  ```
  </details>
{% endfor %}

Service
=======

Reviewer
--------

- [ACM Computing Surveys (CSUR)](https://csur.acm.org/). 2016.
