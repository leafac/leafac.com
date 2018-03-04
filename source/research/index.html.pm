#lang pollen

◊define-meta[title]{Research}
◊define-meta[date]{2018-03-04}

◊(define publication/paper (default-tag-function '@))
◊(define publication/paper/title subsection)
◊(define (publication/paper/authors . elements)
(apply (default-tag-function '@) `(,@elements ".")))
◊(define (publication/paper/venue . elements)
(apply (default-tag-function '@) `(,(new-line)
                                   ,(apply emphasis elements) ". ")))
◊(define (publication/paper/date . elements)
(apply (default-tag-function '@) `(,@elements ".")))
◊(define (publication/paper/abstract . elements)
(apply (default-tag-function '@) `(,(new-line) ,@elements)))
◊(define service/reviewer (default-tag-function '@))
◊(define (service/reviewer/title . elements)
  (apply (default-tag-function '@) `(,@elements ". ")))
◊(define (service/reviewer/date . elements)
  (apply (default-tag-function '@) `(,@elements ".")))
◊section['publications]{Publications}

◊publication/paper[
 ◊publication/paper/title['publication--paper--relative-store-fragment-for-singleton-abstraction]{◊reference["/research/relative-store-fragment-for-singleton-abstraction/relative-store-fragment-for-singleton-abstraction.pdf"]{Relative Store Fragment for Singleton Abstraction}}
 ◊publication/paper/authors{Leandro Facchinetti, Zachary Palmer and Scott F. Smith}
 ◊publication/paper/venue{◊reference["http://staticanalysis.org/sas2017/sas2017.html"]{24th Static Analysis Symposium}}
 ◊publication/paper/date{2017}
 ◊publication/paper/abstract{A ◊technical-term{singleton abstraction} occurs in a program analysis when some results of the analysis are known to be exact: an abstract binding corresponds to a single concrete binding. In this paper, we develop a novel approach to constructing singleton abstractions via ◊technical-term{relative store fragments}. Each store fragment is a ◊emphasis{locally} exact store abstraction in that it contains only those abstract variable bindings necessary to address a particular question at a particular program point; it is ◊technical-term{relative} to that program point and the point of view may be shifted. We show how an analysis incorporating relative store fragments achieves flow-, context-, path- and must-alias sensitivity, and can be used as a basis for envi- ronment analysis, without any machinery put in place for those specific aims. We build upon recent advances in ◊technical-term{demand-driven} higher-order pro- gram analysis to achieve this construction as it is fundamentally tied to demand-driven lookup of variable values.}
]

◊publication/paper[
 ◊publication/paper/title['publication--paper--practical-demand-driven-program-analysis-with-recursion]{◊reference["/research/practical-demand-driven-program-analysis-with-recursion/practical-demand-driven-program-analysis-with-recursion.pdf"]{Practical Demand-Driven Program Analysis with Recursion}}
 ◊publication/paper/authors{Leandro Facchinetti}
 ◊publication/paper/venue{Research project report to fulfill a qualifying requirement of the Ph.D. program at The Johns Hopkins University}
 ◊publication/paper/date{2016}
 ◊publication/paper/abstract{Demand-Driven Program Analysis (DDPA) is a context-sensitive control-flow analysis for higher-order functional programming languages in the same space as k-CFA and related analyses. DDPA is provably sound and polynomial, but that alone does not guarantee its applicability to real-world programs. This project studies DDPA’s practicality in two dimensions: expressiveness (the analysis closely approximates the run-time) and performance (the analysis is fast to compute). To address expressiveness, we extended the analysis to directly support recursion, eliminating the need for encodings. To address performance, we developed a higher-level programming language that compiles to DDPA’s core language, ported over benchmarks that exercise all its features, and measured the reference implementation’s performance, comparing to other state-of-the-art program analyses. DDPA is competitive and, in some cases, faster than the alternatives.}
]

◊publication/paper[
 ◊publication/paper/title['publication--paper--higher-order-demand-driven-program-analysis--dagstuhl]{◊reference["http://drops.dagstuhl.de/opus/volltexte/2016/6130/"]{Higher-Order Demand-Driven Program Analysis—Artifact}}
 ◊publication/paper/authors{Leandro Facchinetti, Zachary Palmer and Scott F. Smith}
 ◊publication/paper/venue{◊reference["http://drops.dagstuhl.de/opus/institut_darts.php?fakultaet=10"]{Dagstuhl Artifacts Series}}
 ◊publication/paper/date{2016}
 ◊publication/paper/abstract{This artifact is a proof-of-concept implementation of DDPA, an on-demand program analysis for higher-order functional programs. The implementation, written in OCaml, includes a parser, evaluator, and DDPA analysis for the language defined in the companion paper (including the proper record semantics extension). The analysis may be performed using different levels of precision as specified by the user and is capable of rendering the control flow graphs and pushdown systems using the GraphViz language DOT. This artifact was used to verify the conclusions of the companion paper and produces visualizations matching those figures in the companion paper’s overview.}
]

◊publication/paper[
 ◊publication/paper/title['publication--paper--higher-order-demand-driven-program-analysis--ecoop]{◊reference["http://2016.ecoop.org/event/ecoop-2016-artifacts-higher-order-demand-driven-program-analysis"]{Higher-Order Demand-Driven Program Analysis—Artifact}}
 ◊publication/paper/authors{Leandro Facchinetti, Zachary Palmer and Scott F. Smith}
 ◊publication/paper/venue{◊reference["http://2016.ecoop.org/"]{30th European Conference on Object-Oriented Programming (ECOOP)}}
 ◊publication/paper/date{2016}
 ◊publication/paper/abstract{This artifact is a proof-of-concept implementation of DDPA, an on-demand program analysis for higher-order functional programs. The implementation, written in OCaml, includes a parser, evaluator, and DDPA analysis for the language defined in the companion paper (including the proper record semantics extension). The analysis may be performed using different levels of precision as specified by the user and is capable of rendering the control flow graphs and pushdown systems using the GraphViz language DOT. This artifact was used to verify the conclusions of the companion paper and produces visualizations matching those figures in the companion paper’s overview.}
]

◊publication/paper[
 ◊publication/paper/title['publication--paper--what-is-your-function]{◊reference["/research/what-is-your-function/what-is-your-function.pdf"]{What is Your Function? Static Pattern Matching on Function Behavior}}
 ◊publication/paper/authors{Leandro Facchinetti, Pottayil Harisanker Menon, Zachary Palmer, Alexander Rozenshteyn and Scott F. Smith}
 ◊publication/paper/venue{◊reference["http://tfp2016.org/"]{The 17th Symposium on Trends in Functional Programming (TFP 2016)}}
 ◊publication/paper/date{2016}
 ◊publication/paper/abstract{
  We define a new notion of ◊technical-term{function pattern}, which supports run-time pattern matching on functions based on their behavior. The ability to run-time dispatch on function type information enables new programmer expressiveness, including support of overloading on higher-order functions as well as other useful patterns.

  We formally present a type inference system for function patterns. The system answers questions of function pattern matching by recursively invoking the type inference algorithm. The recursive invocation contains some delicate issues of self-referentiality that we address.
 }
]

◊publication/paper[
 ◊publication/paper/title['publication--paper--pesquisa-e-desenvolvimento-de-robos-taticos-para-ambientes-internos]{◊reference["/research/pesquisa-e-desenvolvimento-de-robos-taticos-para-ambientes-internos/pesquisa-e-desenvolvimento-de-robos-taticos-para-ambientes-internos.pdf"]{◊foreign{Pesquisa e Desenvolvimento de Robôs Táticos para Ambientes Internos} (Research and Development of Tactical Robots for Indoor Environments)}}
 ◊publication/paper/authors{Fernando Osório, Denis Wolf, Kalinka Castelo Branco, Jó Ueyama, Gustavo Pessin, Leandro Fernandes, Maurício Dias, Leandro Couto, Daniel Sales, Diogo Correa, Matheus Nin, Leandro Lourenço Silva, Leonardo Bonetti, Leandro Facchinetti and Fabiano Hessel}
 ◊publication/paper/venue{Internal Workshop of INCT-SEC}
 ◊publication/paper/date{2011}
]

◊publication/paper[
 ◊publication/paper/title['publication--paper--sistema-de-navegacao-visual-baseado-em-correlacao-de-imagens-visando-a-aplicacao-em-veiculos-autonomos-inteligentes]{◊reference["/research/sistema-de-navegacao-visual-baseado-em-correlacao-de-imagens-visando-a-aplicacao-em-veiculos-autonomos-inteligentes/sistema-de-navegacao-visual-baseado-em-correlacao-de-imagens-visando-a-aplicacao-em-veiculos-autonomos-inteligentes.pdf"]{◊foreign{Sistema de Navegação Visual Baseado em Correlação de Imagens Visando a Aplicação em Veículos Autônomos Inteligentes} (Visual Navigation System Based on Image Correlation Targeted to Intelligent Autonomous Vehicles)}}
 ◊publication/paper/authors{Leandro Facchinetti and Fernando Santos Osório}
 ◊publication/paper/venue{◊foreign{18º Simpósio Internacional de Iniciação Científica da Universidade de São Paulo} (18th International Scientific Initiation Symposium from Universidade de São Paulo)}
 ◊publication/paper/date{2010-11}
]

◊publication/paper[
 ◊publication/paper/title['publication--paper--navegacao-visual-de-robos-moveis-autonomos-baseada-em-metodos-de-correlacao-de-imagens]{◊reference["/research/navegacao-visual-de-robos-moveis-autonomos-baseada-em-metodos-de-correlacao-de-imagens/navegacao-visual-de-robos-moveis-autonomos-baseada-em-metodos-de-correlacao-de-imagens.pdf"]{◊foreign{Navegação Visual de Robôs Móveis Autônomos Baseada em Métodos de Correlação de Imagens} (Visual Navigation of Autonomous Mobile Robots Based on Image Correlation Methods)}}
 ◊publication/paper/authors{Leandro Facchinetti and Fernando Santos Osório}
 ◊publication/paper/venue{◊reference["http://www.jointconference.fei.edu.br/wci/index.html"]{III Workshop on Computational Intelligence—WCI. Joint Conference 2010—SBIA—SBRN—JRI}}
 ◊publication/paper/date{2010-10-24}
]

◊publication/paper[
 ◊publication/paper/title['publication--paper--pesquisa-e-desenvolvimento-de-robos-moveis-autonomos-com-navegacao-baseada-em-correlacao-de-imagens]{◊foreign{Pesquisa e Desenvolvimento de Robôs Móveis Autônomos com Navegação Baseada em Correlação de Imagens} (Research and Development of Autonomous Mobile Robots with Image-Correlation-Based Navigation)}
 ◊publication/paper/authors{Leandro Facchinetti and Fernando Santos Osório}
 ◊publication/paper/venue{◊foreign{IV Workshop de Iniciação Científica e Tecnológica de Computação (WICT)} (IV Scientific and Technologic Initiation Workshop)}
 ◊publication/paper/date{2010-09-22}
]

◊section['service]{Service}

◊subsection['reviewer]{Reviewer}

◊service/reviewer[
 ◊service/reviewer/title{◊reference["http://csur.acm.org/"]{ACM Computing Surveys (CSUR)}}
 ◊service/reviewer/date{2016}
]
