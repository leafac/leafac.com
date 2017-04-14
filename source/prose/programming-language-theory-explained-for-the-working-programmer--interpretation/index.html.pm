#lang pollen

◊define-meta[title]{Programming-Language Theory Explained for the Working Programmer: Interpretation}
◊define-meta[date]{2017-04-03}

◊margin-note{This article assumes knowledge in the ◊link/internal["/prose/programming-language-theory-explained-for-the-working-programmer--principles-of-programming-languages"]{essential features of programming languages}. Experience with functional programming languages in general and ◊link["https://racket-lang.org/"]{Racket} in particular are helpful, but not required. Refer to Racket’s ◊link["https://docs.racket-lang.org/quick/index.html"]{quick introduction} for more.}

◊margin-note{◊link["https://git.leafac.com/www.leafac.com/plain/source/prose/programming-language-theory-explained-for-the-working-programmer--interpretation/programming-language-theory-explained-for-the-working-programmer--interpretation.rkt"]{Here} is the code for this entire article.}

◊new-thought{Interpreters are programs} for running programs. They receive as input code, usually written by human programmers, and execute it, outputting the result of the computations defined by the code. How do interpreters work? In this article we address this question by writing a few different interpreters, with the goal of exploring the underlying principles of computing. In the process, we introduce techniques that are generally applicable to everyday problem solving. We avoid the mathematical notation and jargon usually associated with this kind of topic, driving the exposition by working code. So this article is approachable to all programmers.

◊section['language]{Language}

◊new-thought{We need to choose} a language in which to write our interpreters. We choose Racket because it has features that make interpreters easier to read, for example, ◊technical-term{pattern matching} and ◊technical-term{quasiquoting}—which we introduce later. But there is nothing special about Racket, this article could be rewritten in any other programming language.

More important than the choice of base language is the choice of target language. What language are we going to interpret? We are not interested in language design in this article, our objective is not understand how particular features are interpreted. Instead, we are interested in studying interpretation itself, understanding the fundamental principles behind computation. So the target language should be as ◊technical-term{simple} as possible.

We choose ◊technical-term{simplicity} over ◊technical-term{convenience}. Our target language preferably includes few features, so that our interpreters remain small and understandable, and we can change how they work with minimal effort. This entails that our target language is ◊technical-term{difficult} to use; programs written in it are verbose and unintelligible. It would be a bad choice for everyday programming tasks, but it is good target language for this article, as long as it remains a programming language with enough features to represent arbitrary computations.

◊margin-note{For more on our target language, refer to ◊link/internal["/prose/programming-language-theory-explained-for-the-working-programmer--principles-of-programming-languages"]{◊publication{Programming-Language Theory Explained for the Working Programmer: Principles of Programming Languages}}.}

There exist many languages that fit our requirements. From all of them, we choose one that is particularly elegant, for its compactness. This target language represents a minimal core with only the essential features of programming languages: (1) definitions of anonymous functions of single argument and single return value; (2) applications of these functions; and (3) variable references. The following listing is an example of a program in this language:

◊code/block/highlighted['racket]{
(λ (x) x)
}

◊margin-note{The lambda (◊code/inline{λ}) is the only Greek letter and the most unusual notation in this article. It is worth introducing a short notation for anonymous functions because we write them frequently. This notation also justifies the formal name for our target language: ◊technical-term{Lambda calculus}.}

◊margin-note{
 Our choice of notation is based on Racket’s notation, so our target language is a subset of Racket. This means that programs in our target language are also programs in Racket, which is useful to check the correctness of our interpreters and for interactive exploration. But this latter application is limited by the way Racket prints functions—it just outputs ◊code/inline{#<procedure>}, instead of the function definition.

 Another consequence of this decision is that our target language inherits many implicit design choices from Racket. For example, we evaluate the argument to a value before passing it into the function, we only evaluate function applications at the top level—and not those that occur within function bodies before the function is applied—and more. Different choices would lead to different interpreters, with different consequences to the programs. For example, some programs that run forever in our target language would terminate had we decided to only evaluate function arguments to values when they are needed, as opposed to before passing them into the function. We follow Racket’s design decisions because they are similar to those of most popular programming languages.
}

The program above defines a function which has no name (anonymous function). Function definitions are delineated by parentheses, and start with the Greek letter lambda (◊code/inline{λ}). After the ◊code/inline{λ} there is the name of the argument received by the function, also in parentheses—◊code/inline{(x)} in the example. Finally, there is the function body, an expression specifying which computation the function performs. In the example, the computation is just to return the argument ◊code/inline{x}, unaltered.

In our target language, functions are values. They are the only kind of values; there are no numbers, booleans, strings, data structures and other constructs usually found in programming languages. This highlights how ◊technical-term{simple} this language is. Despite its simplicity, our target language is ◊link/internal["/prose/programming-language-theory-explained-for-the-working-programmer--principles-of-programming-languages"]{capable of performing arbitrary computations}. In the case of the listing above, the defined function is the whole program. This is similar how the following is a complete program in languages including Racket, Ruby, JavaScript and Python:

◊code/block/highlighted['racket]{
5
}

The listing above defines a full program in the mentioned languages. Its result is the number ◊code/inline{5}, because numbers are values in these languages. In our target language functions are values, so the result of our first program in our target language is the function ◊code/inline{(λ (x) x)}.

Our first program is an example of function definition (◊code/inline{(λ ...)}) and variable reference (the ◊code/inline{x} in the function body). There is only one other feature in our target language, function application. It is represented by function and argument enclosed in parentheses. For example, if ◊code/inline{f} is a function and ◊code/inline{a} is an argument, then ◊code/inline{(f a)} is a function application. This is equivalent to the mathematical notation also used by many popular programming languages: ◊code/inline{f(a)}. The following listing is a full program illustrating function application in our target language:

◊code/block/highlighted['racket]{
((λ (x) x) (λ (y) y))
}

◊margin-note{The replacement of argument names in the function body for the argument provided in the function application is the mechanism that allows for arbitrary ◊emphasis{communication} of data in the program.}

This program is an application of the function ◊code/inline{(λ (x) x)} to the argument ◊code/inline{(λ (y) y)}. The interpretation of this is the same as in mathematics and most programming languages: replace every occurrence of the argument name ◊code/inline{x} in ◊code/inline{(λ (x) x)}’s body with the argument ◊code/inline{(λ (y) y)}. Because ◊code/inline{(λ (x) x)}’s body is just ◊code/inline{x}, the result of this program is ◊code/inline{(λ (y) y)}.

◊paragraph-separation[]

◊new-thought{We covered all features} of our target language, but there are two corner cases that we need to address: variable names that repeat and variable references that have not been defined. The first case, variable names that repeat, can occur in two ways. The simplest way is illustrated by the following listing:

◊code/block/highlighted['racket]{
((λ (x) x) (λ (x) x))
}

This is a variation on the program we used above to discuss function application. The only difference is the variable ◊code/inline{y} is consistently renamed to ◊code/inline{x}, so the name ◊code/inline{x} is used by both functions. These names occur in separate functions, so they do not interfere with each other. The same reasoning as before applies, and the result of this program is ◊code/inline{(λ (x) x)}. This is the same result as the previous example, except that the variable ◊code/inline{y} is consistently renamed to ◊code/inline{x} in the result as well.

A more interesting corner case occurs when a variable name is reused in nested functions. Consider the following function:

◊code/block/highlighted['racket]{
(λ (x) (λ (x) x))
}

◊margin-note{

 ◊svg{shadowing.svg}

 ◊no-indent[] This phenomenon is known as ◊technical-term{shadowing}, because the argument of the inner function ◊technical-term{shadows} the argument of the outer function. In the inner function body there is no way to refer to the outer function argument.
}

Is the ◊code/inline{x} in the inner function body referring to the argument of the inner function or to the argument of the outer function? The answer is that variable references always refer to the nearest argument whose name (◊code/inline{x}, in the example) matches. So the ◊code/inline{x} in the inner function body is referring to the argument of the inner function.

The final corner case is a variable reference to an undefined name. The following program is an example of this:

◊code/block/highlighted['racket]{
x
}

◊margin-note{Programs including variable references to undefined names are said to be ◊technical-term{open}. Since the meaning of ◊code/inline{x} in our example is not defined, the program is ◊technical-term{open} to different interpretations. If we said that ◊code/inline{x} is ◊code/inline{5}, then the program would result in ◊code/inline{5}. If we said that ◊code/inline{x} is ◊code/inline{"hello"}, then the program would result in ◊code/inline{"hello"}. Our interpreter only works over programs that do not contain these variable references to undefined names, which are said to be ◊technical-term{closed}.}

The program consists of a variable reference to ◊code/inline{x}, but ◊code/inline{x} has not been defined, it is not an argument to any function. This program has no precise meaning on its own, so our interpreters fail to evaluate it. This decision is consistent with most programming languages. Racket, for example, errors when trying to run the program above: “◊code/inline{x}: unbound identifier in module.”

◊paragraph-separation[]

◊new-thought{How do we represent} programs in our language? Generally, programs are plain text files, which interpreters read from disk. Then they transform the text of the program into data structures in memory, through processes called ◊technical-term{lexical analysis} and ◊technical-term{syntactic analysis}. This would be easy to do because we our target language is a subset of Racket, and the language comes with ◊technical-term{lexical} and ◊technical-term{syntactical analyzers} for itself. But we take an even easier approach, and represent our programs as data structures in Racket directly. The language has a feature to make this representation convenient: ◊link["https://docs.racket-lang.org/guide/qq.html"]{◊technical-term{quasiquoting}}. Consider the example of function application in our target language from above:

◊code/block/highlighted['racket]{
((λ (x) x) (λ (y) y))
}

To turn this program in our target language into a data structure in Racket, we introduce a quasiquote (◊code/inline{`}), as in the following Racket program:

◊margin-note{Our target language is a subset of Racket, so ◊code/inline{((λ (x) x) (λ (y) y))} is a program both in our target language and in Racket. Quasiquote turns this Racket program into data. This data is the program in our target language, over which our interpreter will work. This process demonstrates that ◊emphasis{code can be data, and data can be code}. The two—data and code—are sides of the same coin.}

◊code/block/highlighted['racket]{
`((λ (x) x) (λ (y) y))
}

Another advantage of using ◊technical-term{quasiquoting} to represent programs in our target language is that we can use Racket programs to build programs in our target language. For this, we use ◊technical-term{unquoting} (◊code/inline{,}), which interpolates Racket expressions in parts of the data structure. For example, consider the following rewrite of the program above:

◊code/block/highlighted['racket]{
(define argument `(λ (y) y))
`((λ (x) x) ,argument)
}

◊margin-note{An important consequence of using ◊technical-term{quasiquote} and ◊technical-term{unquote} in Racket to build programs in our target language is that it is not possible to write programs with syntax errors, as those would be syntax errors in Racket itself. This would not be the case had we decided to represent programs in our target language as plain text files.}

This listing has the same meaning as the previous program. First, it defines a variable named ◊code/inline{argument}, whose value is a data structure representing a program fragment in our target language: ◊code/inline{(λ (y) y)}. Then, it uses ◊technical-term{quasiquote} and ◊technical-term{unquote} to define the program ◊code/inline{((λ (x) x) (λ (y) y))} in our target language. The ◊technical-term{quasiquote} (◊code/inline{`}) starts a program in our target language embedded in Racket (a data structure), and the ◊technical-term{unquote} (◊code/inline{,}) escapes back to Racket. The result of the expression under the ◊technical-term{unquote} is interpolated in place. In the given example, the expression under the ◊technical-term{unquote} is just a reference to the variable defined right above: ◊code/inline{argument}. So its value (the program fragment ◊code/inline{(λ (y) y)} in our target language) is interpolated in place, resulting in the program ◊code/inline{((λ (x) x) (λ (y) y))} in our target language.

◊section['first-interpreter]{First Interpreter}

◊new-thought{Our first interpreter} is a function which receives as argument a program like those defined on the ◊reference['language]{previous section} and returns a value in our language. We build it incrementally, driven by the example programs from the ◊reference['language]{previous section}. The first program is an example of anonymous function definition:

◊code/block/highlighted['racket]{
(λ (x) x)
}

Anonymous function definitions are already values in our language, so the interpreter can return the given expression unaltered:

◊code/block/highlighted['racket]{
(define (interpret expression)
  expression)
}

This implementation is enough to interpret our first example program correctly:

◊margin-note{The quote (◊code/inline{'}) in the result means the same as the quasiquote (◊code/inline{`}), except that it does not support unquoting (◊code/inline{,}). For the purposes of this article, read the quote the same as the quasiquote: “the following is a program in our target language.”}

◊code/block/highlighted['racket]{
> (interpret `(λ (x) x))
'(λ (x) x)
}

The next program we address in our interpreter implementation is the function application:

◊code/block/highlighted['racket]{
((λ (x) x) (λ (y) y))
}

Before the interpreter starts working on the function application, it needs to detect that the given ◊code/inline{expression} is of this kind—as opposed to an anonymous function declaration, for example. To this end, we introduce ◊technical-term{pattern matching}. The simplest form of ◊technical-term{pattern matching} is the following:

◊margin-note{
 ◊technical-term{Pattern matching} is a generalization of ◊technical-term{destructuring assignment}. The following listing is an example of ◊technical-term{destructuring assignment} in languages including Ruby, Python and JavaScript:

 ◊code/block/highlighted['racket]{
name, age = ["Wheatley", 6]
 }

 In this program, ◊code/inline{["Wheatley", 6]} is a list composed of the values ◊code/inline{"Wheatley"} and ◊code/inline{6}. The ◊technical-term{destructuring assignment} works by ◊technical-term{destructuring} the list and ◊technical-term{assigning} its elements to the variables ◊code/inline{name} and ◊code/inline{age}, respectively.

 ◊technical-term{Pattern matching} extends ◊technical-term{destructuring assignment} to support arbitrary data structures, beyond lists, tuples and other data structures generally supported by ◊technical-term{destructuring assignment}.
}

◊margin-note{The quasiquotation notation for patterns that ◊technical-term{destruct} data structures is the same as the quasiquotation notation for ◊technical-term{constructing} data structures, for example, ◊code/inline{`(λ (,argument) ,body)}.}

◊code/block/highlighted['racket]{
(match-define `(,function ,argument)
              `((λ (x) x) (λ (y) y)))
}

This form matches the program in our target language ◊code/inline{`((λ (x) x) (λ (y) y))} with the pattern ◊code/inline{`(,function ,argument)}. As a result, the variable ◊code/inline{function} is bound to the program fragment ◊code/inline{(λ (x) x)} and the variable ◊code/inline{argument} is bound to the program fragment ◊code/inline{(λ (y) y)}.

In our case, the data structure which is ◊technical-term{subject} of the ◊technical-term{pattern match} (◊code/inline{expression}) might have different forms. Moreover, we want to perform different computations depending on the kind of ◊code/inline{expression}. So the ◊code/inline{match-define} form does not suffice, we have to reach for the ◊code/inline{match} form, which was designed for this purpose. The following is an example of ◊code/inline{pattern matching} with the ◊code/inline{match} form:

◊margin-note{The ◊code/inline{match} form is similar to multiway branches (for example, ◊code/inline{switch} and ◊code/inline{case}) in popular programming languages.}

◊figure{◊svg{match.svg}}

The ◊technical-term{pattern match} with the ◊code/inline{match} form works by matching the ◊technical-term{subject} to each of the ◊technical-term{patterns}, in order. The first ◊technical-term{pattern} that matches determines which ◊technical-term{match clause} has its ◊technical-term{body} executed. In the example above, the ◊technical-term{subject} and the ◊technical-term{patterns} are simple data structures: numbers. The first ◊technical-term{match clause} whose ◊technical-term{pattern} matches the ◊technical-term{subject} is ◊code/inline{[5 "five"]}, so the result of the ◊technical-term{pattern match} is the ◊technical-term{clause body} ◊code/inline{"five"}.

The example above demonstrate that the ◊code/inline{match} form in Racket has two uses: (1) multiway branching; and (2) destructing data structures. Using it, we can detect in which case the given ◊code/inline{expression} falls. There are only possibilities, the three constructs in our language: (1) definitions of anonymous functions of single argument and single return value; (2) applications of these functions; and (3) variable references.

◊;{

◊code/block/highlighted['racket]{
(define (interpret expression)
  (match expression
    [`(λ (,argument) ,body)
     ; TODO: (1) Anonymous function definitions.
     ]
    [`(,function ,argument)
     ; TODO: (2) Function application.
     ]
    [variable
     ; TODO: (3) Variable references.
     ]))
}

In the listing above, the ◊technical-term{subject} of the pattern match is ◊code/inline{expression}, and there are three ◊technical-term{match clauses}, corresponding to the three kinds of ◊code/inline{expression}s. The first ◊technical-term{pattern} is ◊code/inline{`(λ (,argument) ,body)}, which matches anonymous function definitions. For example, if ◊code/inline{expression} is ◊code/inline{(λ (x) (x x))}, then ◊code/inline{argument} represents ◊code/inline{x} and ◊code/inline{body} stands for ◊code/inline{(x x)}. The other two patterns work similarly.

◊paragraph-separation[]

◊new-thought{We start by addressing} the first ◊technical-term{match clause}, regarding anonymous function definitions. The purpose of ◊code/inline{interpret} is to evaluate the given ◊code/inline{expression} to a value. If the given ◊code/inline{expression} is an anonymous function definition, then it is already a value in our language. All ◊code/inline{interpret} has to do in that case is to return ◊code/inline{expression} unaltered:

◊code/block/highlighted['racket]{
(define (interpret expression)
  (match expression
    [`(λ (,argument) ,body)
     expression]
    [`(,function ,argument)
     ; TODO: (2) Function application.
     ]
    [variable
     ; TODO: (3) Variable references.
     ]))
}

◊margin-note{To run this partial implementation in Racket, remove the ◊technical-term{match clauses} that have not been implemented yet. Otherwise the missing ◊technical-term{clause bodies} cause errors.}

This partial ◊code/inline{interpret} implementation is enough to interpret our first example: ◊code/inline{(λ (x) x)}. It returns ◊code/inline{(λ (x) x)} itself, unaltered.

◊paragraph-separation[]

◊new-thought{The next case} we address is function application. The following is an example of function application in our language:

◊code/block/highlighted['racket]{
((λ (x) x) (λ (y) y)) ;; => (λ (y) y)
}

The applied function is ◊code/inline{(λ (x) x)} and the argument is ◊code/inline{(λ (y) y)}. The meaning is the same as mathematics and most programming languages: in the function body (in this case, the body is ◊code/inline{x}) substitute every occurrence of the argument name (in this case, the argument name is ◊code/inline{x}) for the given argument (in this case, the given argument is ◊code/inline{(λ (y) y)}).

The ◊technical-term{pattern} we use to match function application is ◊code/inline{`(,function ,argument)}. So, in our example, the variable name ◊code/inline{function} is bound to the value ◊code/inline{(λ (x) x)} and the variable name ◊code/inline{argument} is bound to the value ◊code/inline{(λ (y) y)}. Our first task is to ◊technical-term{destruct} ◊code/inline{function} to find its argument name and body:

◊code/block/highlighted['racket]{
(match-define `(λ (,argument-name) ,body)
  function)
}

Then, we can call an auxiliary function to perform the substitution:

◊code/block/highlighted['racket]{
(define (interpret expression)
  (match expression
    [`(λ (,argument) ,body)
     expression]
    [`(,function ,argument)
     (match-define `(λ (,argument-name) ,body)
       function)
     (substitute body argument-name argument)]
    [variable
     ; TODO: (3) Variable references.
     ]))
}

The ◊code/inline{substitute} auxiliary function receives as argument a function ◊code/inline{body} and returns a modified version of it in which each occurrence of the given ◊code/inline{argument-name} has been substituted with the given ◊code/inline{argument}. To implement ◊code/inline{substitute}, we use the same strategy as in ◊code/inline{interpret}. We start by ◊technical-term{pattern matching} on the given ◊code/inline{body} to distinguish between the possible kinds:

◊margin-note{The skeleton for the ◊code/inline{substitute} implementation is the same as the skeleton for the ◊code/inline{interpret} implementation. This is not a coincidence. Both functions work by traversing the data structures that represents the programs in our language. The difference between ◊code/inline{substitute} and ◊code/inline{interpret} is the computations they perform during this traversal. We could factor these common parts out of ◊code/inline{substitute} and ◊code/inline{interpret}, resulting in what is called the ◊technical-term{visitor pattern}. We do not do this for clarity and simplicity.}

◊code/block/highlighted['racket]{
(define (substitute
         body argument-name argument)
  (match body
    [`(λ (,other-argument-name) ,other-body)
     ; TODO: (1) Anonymous function definitions.
     ]
    [`(,function ,other-argument)
     ; TODO: (2) Function application.
     ]
    [variable
     ; TODO: (3) Variable references.
     ]))
}
}

◊; TODO: Are all components of pattern matches properly tagged as ◊technical-term{}?
◊; TODO: Reorder explanation of pattern matching.
◊; TODO: Add listings with calls to “interpret”.

◊; TODO: References.
◊; - SEwPR.
◊; - SICP.
◊; - PL book.