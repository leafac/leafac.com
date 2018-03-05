#lang pollen

◊define-meta[title]{Research}
◊define-meta[date]{2018-03-04}

◊section['publications]{Publications}

◊(define (publication . elements)
   (match elements
     [`((title ,key ,title ...)
        (authors ,authors ...)
        (venue ,venue ...)
        (the-date ,the-date ...)
        (abstract ,abstract ...) ...)
      (txexpr* '@ empty
               (apply subsection key title)
               (txexpr '@ empty authors) "."
               (new-line)
               (apply emphasis venue) ". " (txexpr '@ empty the-date) "."
               (if (empty? abstract)
                   (txexpr '@)
                   (txexpr* '@ empty (new-line) (txexpr '@ empty (first abstract)))))]))

◊publication[
 ◊title['publication--paper--relative-store-fragment-for-singleton-abstraction]{◊reference["/research/relative-store-fragment-for-singleton-abstraction/relative-store-fragment-for-singleton-abstraction.pdf"]{Relative Store Fragment for Singleton Abstraction}}
 ◊authors{Leandro Facchinetti, Zachary Palmer and Scott F. Smith}
 ◊venue{◊reference["http://staticanalysis.org/sas2017/sas2017.html"]{24th Static Analysis Symposium}}
 ◊the-date{2017}
 ◊abstract{A ◊technical-term{singleton abstraction} occurs in a program analysis when some results of the analysis are known to be exact: an abstract binding corresponds to a single concrete binding. In this paper, we develop a novel approach to constructing singleton abstractions via ◊technical-term{relative store fragments}. Each store fragment is a ◊emphasis{locally} exact store abstraction in that it contains only those abstract variable bindings necessary to address a particular question at a particular program point; it is ◊technical-term{relative} to that program point and the point of view may be shifted. We show how an analysis incorporating relative store fragments achieves flow-, context-, path- and must-alias sensitivity, and can be used as a basis for envi- ronment analysis, without any machinery put in place for those specific aims. We build upon recent advances in ◊technical-term{demand-driven} higher-order pro- gram analysis to achieve this construction as it is fundamentally tied to demand-driven lookup of variable values.}
]

◊publication[
 ◊title['publication--paper--practical-demand-driven-program-analysis-with-recursion]{◊reference["/research/practical-demand-driven-program-analysis-with-recursion/practical-demand-driven-program-analysis-with-recursion.pdf"]{Practical Demand-Driven Program Analysis with Recursion}}
 ◊authors{Leandro Facchinetti}
 ◊venue{Research project report to fulfill a qualifying requirement of the Ph.D. program at The Johns Hopkins University}
 ◊the-date{2016}
 ◊abstract{Demand-Driven Program Analysis (DDPA) is a context-sensitive control-flow analysis for higher-order functional programming languages in the same space as k-CFA and related analyses. DDPA is provably sound and polynomial, but that alone does not guarantee its applicability to real-world programs. This project studies DDPA’s practicality in two dimensions: expressiveness (the analysis closely approximates the run-time) and performance (the analysis is fast to compute). To address expressiveness, we extended the analysis to directly support recursion, eliminating the need for encodings. To address performance, we developed a higher-level programming language that compiles to DDPA’s core language, ported over benchmarks that exercise all its features, and measured the reference implementation’s performance, comparing to other state-of-the-art program analyses. DDPA is competitive and, in some cases, faster than the alternatives.}
]

◊publication[
 ◊title['publication--paper--higher-order-demand-driven-program-analysis--dagstuhl]{◊reference["http://drops.dagstuhl.de/opus/volltexte/2016/6130/"]{Higher-Order Demand-Driven Program Analysis—Artifact}}
 ◊authors{Leandro Facchinetti, Zachary Palmer and Scott F. Smith}
 ◊venue{◊reference["http://drops.dagstuhl.de/opus/institut_darts.php?fakultaet=10"]{Dagstuhl Artifacts Series}}
 ◊the-date{2016}
 ◊abstract{This artifact is a proof-of-concept implementation of DDPA, an on-demand program analysis for higher-order functional programs. The implementation, written in OCaml, includes a parser, evaluator, and DDPA analysis for the language defined in the companion paper (including the proper record semantics extension). The analysis may be performed using different levels of precision as specified by the user and is capable of rendering the control flow graphs and pushdown systems using the GraphViz language DOT. This artifact was used to verify the conclusions of the companion paper and produces visualizations matching those figures in the companion paper’s overview.}
]

◊publication[
 ◊title['publication--paper--higher-order-demand-driven-program-analysis--ecoop]{◊reference["http://2016.ecoop.org/event/ecoop-2016-artifacts-higher-order-demand-driven-program-analysis"]{Higher-Order Demand-Driven Program Analysis—Artifact}}
 ◊authors{Leandro Facchinetti, Zachary Palmer and Scott F. Smith}
 ◊venue{◊reference["http://2016.ecoop.org/"]{30th European Conference on Object-Oriented Programming (ECOOP)}}
 ◊the-date{2016}
 ◊abstract{This artifact is a proof-of-concept implementation of DDPA, an on-demand program analysis for higher-order functional programs. The implementation, written in OCaml, includes a parser, evaluator, and DDPA analysis for the language defined in the companion paper (including the proper record semantics extension). The analysis may be performed using different levels of precision as specified by the user and is capable of rendering the control flow graphs and pushdown systems using the GraphViz language DOT. This artifact was used to verify the conclusions of the companion paper and produces visualizations matching those figures in the companion paper’s overview.}
]

◊publication[
 ◊title['publication--paper--what-is-your-function]{◊reference["/research/what-is-your-function/what-is-your-function.pdf"]{What is Your Function? Static Pattern Matching on Function Behavior}}
 ◊authors{Leandro Facchinetti, Pottayil Harisanker Menon, Zachary Palmer, Alexander Rozenshteyn and Scott F. Smith}
 ◊venue{◊reference["http://tfp2016.org/"]{The 17th Symposium on Trends in Functional Programming (TFP 2016)}}
 ◊the-date{2016}
 ◊abstract{
  We define a new notion of ◊technical-term{function pattern}, which supports run-time pattern matching on functions based on their behavior. The ability to run-time dispatch on function type information enables new programmer expressiveness, including support of overloading on higher-order functions as well as other useful patterns.

  We formally present a type inference system for function patterns. The system answers questions of function pattern matching by recursively invoking the type inference algorithm. The recursive invocation contains some delicate issues of self-referentiality that we address.
 }
]

◊publication[
 ◊title['publication--paper--pesquisa-e-desenvolvimento-de-robos-taticos-para-ambientes-internos]{◊reference["/research/pesquisa-e-desenvolvimento-de-robos-taticos-para-ambientes-internos/pesquisa-e-desenvolvimento-de-robos-taticos-para-ambientes-internos.pdf"]{◊foreign{Pesquisa e Desenvolvimento de Robôs Táticos para Ambientes Internos} (Research and Development of Tactical Robots for Indoor Environments)}}
 ◊authors{Fernando Osório, Denis Wolf, Kalinka Castelo Branco, Jó Ueyama, Gustavo Pessin, Leandro Fernandes, Maurício Dias, Leandro Couto, Daniel Sales, Diogo Correa, Matheus Nin, Leandro Lourenço Silva, Leonardo Bonetti, Leandro Facchinetti and Fabiano Hessel}
 ◊venue{Internal Workshop of INCT-SEC}
 ◊the-date{2011}
]

◊publication[
 ◊title['publication--paper--sistema-de-navegacao-visual-baseado-em-correlacao-de-imagens-visando-a-aplicacao-em-veiculos-autonomos-inteligentes]{◊reference["/research/sistema-de-navegacao-visual-baseado-em-correlacao-de-imagens-visando-a-aplicacao-em-veiculos-autonomos-inteligentes/sistema-de-navegacao-visual-baseado-em-correlacao-de-imagens-visando-a-aplicacao-em-veiculos-autonomos-inteligentes.pdf"]{◊foreign{Sistema de Navegação Visual Baseado em Correlação de Imagens Visando a Aplicação em Veículos Autônomos Inteligentes} (Visual Navigation System Based on Image Correlation Targeted to Intelligent Autonomous Vehicles)}}
 ◊authors{Leandro Facchinetti and Fernando Santos Osório}
 ◊venue{◊foreign{18º Simpósio Internacional de Iniciação Científica da Universidade de São Paulo} (18th International Scientific Initiation Symposium from Universidade de São Paulo)}
 ◊the-date{2010-11}
]

◊publication[
 ◊title['publication--paper--navegacao-visual-de-robos-moveis-autonomos-baseada-em-metodos-de-correlacao-de-imagens]{◊reference["/research/navegacao-visual-de-robos-moveis-autonomos-baseada-em-metodos-de-correlacao-de-imagens/navegacao-visual-de-robos-moveis-autonomos-baseada-em-metodos-de-correlacao-de-imagens.pdf"]{◊foreign{Navegação Visual de Robôs Móveis Autônomos Baseada em Métodos de Correlação de Imagens} (Visual Navigation of Autonomous Mobile Robots Based on Image Correlation Methods)}}
 ◊authors{Leandro Facchinetti and Fernando Santos Osório}
 ◊venue{◊reference["http://www.jointconference.fei.edu.br/wci/index.html"]{III Workshop on Computational Intelligence—WCI. Joint Conference 2010—SBIA—SBRN—JRI}}
 ◊the-date{2010-10-24}
]

◊publication[
 ◊title['publication--paper--pesquisa-e-desenvolvimento-de-robos-moveis-autonomos-com-navegacao-baseada-em-correlacao-de-imagens]{◊foreign{Pesquisa e Desenvolvimento de Robôs Móveis Autônomos com Navegação Baseada em Correlação de Imagens} (Research and Development of Autonomous Mobile Robots with Image-Correlation-Based Navigation)}
 ◊authors{Leandro Facchinetti and Fernando Santos Osório}
 ◊venue{◊foreign{IV Workshop de Iniciação Científica e Tecnológica de Computação (WICT)} (IV Scientific and Technologic Initiation Workshop)}
 ◊the-date{2010-09-22}
]

◊section['service]{Service}

◊subsection['reviewer]{Reviewer}

◊(define (reviewer . elements)
   (match elements
     [`((title ,title ...) (the-date ,the-date ...))
      (txexpr* '@ empty (txexpr '@ empty title) ". " (txexpr '@ empty the-date) ".")]))

◊reviewer[
 ◊title{◊reference["http://csur.acm.org/"]{ACM Computing Surveys (CSUR)}}
 ◊the-date{2016}
]
