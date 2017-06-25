#lang pollen

◊define-meta[title]{Programming-Language Theory Explained for the Working Programmer: Simple Interpreter}
◊define-meta[date]{2017-06-25}

◊margin-note{This article assumes knowledge of the ◊link/internal["/prose/programming-language-theory-explained-for-the-working-programmer--principles-of-programming-languages"]{essential features of programming languages}. Experience with functional programming languages in general and ◊link["https://racket-lang.org/"]{Racket} in particular are helpful, but not required. Refer to Racket’s ◊link["https://docs.racket-lang.org/quick/index.html"]{quick introduction} for more.}

◊margin-note{◊link["https://git.leafac.com/www.leafac.com/plain/source/prose/programming-language-theory-explained-for-the-working-programmer--simple-interpreter/programming-language-theory-explained-for-the-working-programmer--simple-interpreter.rkt"]{Here} is the code for this entire article.}

◊new-thought{Interpreters are programs} for running programs. They receive a program as input, evaluate it, and output the results. How does this process work? In this article we start to address this question by writing a simple interpreter. The goal is to explore the underlying principles of computation and to understand how programming languages support ◊emphasis{communication}, which is their essential feature. We do not to produce a realistic interpreter for an industrial-grade language, but we introduce ideas and techniques that are generally applicable to everyday problem solving. In subsequent articles we will explore the question further, developing variants of the simple interpreter from this article. We avoid the mathematical notation and jargon usually associated with this kind of topic, driving the exposition by working code. So this article is approachable to all programmers.

◊section['language]{Language}

◊new-thought{To start writing} our interpreter, we need to answer two questions: Which language do we use to write it? Which language does it interpret? For the former, we choose Racket. It has features that make interpreters easier to read, for example, ◊technical-term{pattern matching} and ◊technical-term{quasiquoting}—which we introduce in due time. This choice is solely based on convenience, this article could be rewritten in any other programming language.

More interesting than the choice of base language is the choice of target language. Our interpreter evaluates programs written in which language? We are not interested in language design, our objective is not to understand how particular language features are interpreted. Instead, we are interested in studying interpretation itself, and in understanding how interpreters support the fundamental principles behind computation. So the target language should be as ◊technical-term{simple} as possible.

We choose ◊technical-term{simplicity} over ◊technical-term{convenience}. Our target language preferably includes as few features as possible, so that our interpreter is small and understandable, and changing it requires minimal effort. The price we pay is that our target language is ◊technical-term{difficult} to use; programs written in it are verbose and unintelligible. This would be a bad choice for everyday programming tasks, but it is a good target language for this article, because, despite its simplicity, it remains a programming language with enough features to support arbitrary computations.

◊margin-note{For more on our target language, refer to ◊link/internal["/prose/programming-language-theory-explained-for-the-working-programmer--principles-of-programming-languages"]{◊publication{Programming-Language Theory Explained for the Working Programmer: Principles of Programming Languages}}.}

There exist many languages that fit our requirements. From all of them, we choose one that is particularly elegant, for its compactness. This target language represents a minimal core with only the following features: (1) definitions of anonymous functions of single argument and single return value; (2) applications of these functions; and (3) variable references. The following listing is an example of a program in this language:

◊margin-note{The lambda (◊code/inline{λ}) is the only Greek letter and the most unusual notation in the code in this article. It is worth introducing a short notation for anonymous functions because we write them frequently. This notation also justifies the formal name for our target language: ◊technical-term{Lambda calculus}.}

◊code/block/highlighted['racket]{
(λ (x) x)
}

◊margin-note{
 Our choice of notation is based on Racket’s notation, so our target language is a subset of Racket. This means that programs in our target language are also programs in Racket, which helps to check the correctness of our interpreter and to explore interactively. (Though this latter application is limited by how Racket prints functions—it just outputs ◊code/inline{#<procedure>}, instead of the function definition.)

 Another consequence of this decision is that our target language implicitly inherits many design choices from Racket. For example, in function application, we evaluate the argument to a value first. Different design choices would lead to different interpreters, which would change the meaning of some programs. For example, some programs that run forever in our target language would terminate had we decided to only evaluate function arguments to values when they are needed. We follow Racket’s design decisions because they are similar to those of most popular programming languages.
}

The program above defines a function which has no name (anonymous function). Function definitions are enclosed in parentheses, and start with the Greek letter lambda (◊code/inline{λ}). After the ◊code/inline{λ} there is the name of the argument received by the function, also in parentheses, ◊code/inline{(x)}. Finally, there is the function body, an expression specifying which computation the function performs. In the example, the computation is to just return the argument ◊code/inline{x}, unaltered.

In our target language, functions are values. They are the only kind of value; there are no numbers, booleans, strings, data structures and other constructs usually found in programming languages. This highlights how ◊technical-term{simple} the language is. Despite its simplicity, our target language is ◊link/internal["/prose/programming-language-theory-explained-for-the-working-programmer--principles-of-programming-languages"]{capable of performing arbitrary computations}. In the case of the listing above, the function definition is the whole program. This is similar to how the following is a complete program in languages including Racket, Ruby, JavaScript and Python:

◊code/block/highlighted['racket]{
5
}

The listing above defines a full program in the mentioned languages. Its result is the number ◊code/inline{5}, because numbers are values in these languages.  Functions are values in our target language, so the result of our first program is the function ◊code/inline{(λ (x) x)}.

Our first program is an example of function definition—◊code/inline{(λ ...)}—and of variable reference—the ◊code/inline{x} in the function body. There is only one other feature in our target language, function application. It is represented by a function and an argument enclosed in parentheses. For example, if ◊code/inline{f} is a function and ◊code/inline{a} is an argument, then ◊code/inline{(f a)} is a function application. This is equivalent to the mathematical notation used by many popular programming languages: ◊code/inline{f(a)}. The following listing is a full program illustrating function application in our target language:

◊code/block/highlighted['racket]{
((λ (x) x) (λ (y) y))
}

◊margin-note{The substitution of argument names in the function body for the argument provided in the function application is known as ◊technical-term{β reduction}. This process connects names to their meanings, allowing for access of data at a distance and, ultimately, for arbitrary ◊emphasis{communication} in the program. The connection between names and their meanings is the fundamental power of the Lambda calculus and has deep implications. Refer to ◊link["https://blogs.janestreet.com/whats-in-a-name/"]{◊publication{What’s in a name?}} for more.}

This program is an application of the function ◊code/inline{(λ (x) x)} to the argument ◊code/inline{(λ (y) y)}. The interpretation of this is the same as in mathematics and most programming languages: to replace every occurrence of the argument name ◊code/inline{x} in ◊code/inline{(λ (x) x)}’s body with the argument ◊code/inline{(λ (y) y)}. Because ◊code/inline{(λ (x) x)}’s body is just ◊code/inline{x}, the result of this program is ◊code/inline{(λ (y) y)}.

◊paragraph-separation[]

◊new-thought{We covered all features} of our target language, but there are two corner cases that we need to address: variable-name reuse and variable references that have not been defined. The first case, variable-name reuse, can occur in two ways, the simplest of which is illustrated by the following listing:

◊code/block/highlighted['racket]{
((λ (x) x) (λ (x) x))
}

This is a variation on the program we used above to discuss function application. The only difference is that the variable ◊code/inline{y} has been consistently renamed to ◊code/inline{x}, so the name ◊code/inline{x} is used by both functions. These names occur in separate functions, so they do not interfere with each other. The same reasoning as before applies, and the result of this program is ◊code/inline{(λ (x) x)}. This is the same result as the previous example, except that the variable ◊code/inline{y} is consistently renamed to ◊code/inline{x} in the result as well.

A more interesting corner case occurs when a variable name is reused not by functions which sit side-by-side, as in the example above, but by nested functions. Consider the following function:

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

◊margin-note{Programs including variable references to undefined names are said to be ◊technical-term{open}. Since the meaning of ◊code/inline{x} in our example is not defined, the program is ◊technical-term{open} to different interpretations. If we said that ◊code/inline{x} is ◊code/inline{5}, then the program would result in ◊code/inline{5}. If we said that ◊code/inline{x} is ◊code/inline{"hello"}, then the program would result in ◊code/inline{"hello"}. Our interpreter only works on programs that do not contain these variable references to undefined names, which are said to be ◊technical-term{closed}.}

The program consists of a variable reference to ◊code/inline{x}, but ◊code/inline{x} has not been defined, it is not an argument to any function. This program has no precise meaning on its own, so our interpreter fails to evaluate it. This decision is consistent with that of most programming languages. Racket, for example, errors when trying to run the program above: “◊code/inline{x}: unbound identifier in module.”

◊section['representation]{Representation}

◊new-thought{How do we represent} in our base language (Racket) the programs from our target language? Generally, programs are plain text files, which interpreters read from the disk. They transform the text of the program into data structures in memory, through processes called ◊technical-term{lexical analysis} (◊technical-term{lexing}) and ◊technical-term{syntactic analysis} (◊technical-term{parsing}). This would be easy to do because our target language is a subset of Racket, which comes with ◊technical-term{lexical} and ◊technical-term{syntactical analyzers} for itself. But we take an even easier approach, and represent our programs as data structures in Racket directly. The language has a feature to make this representation convenient: ◊link["https://docs.racket-lang.org/guide/qq.html"]{◊technical-term{quasiquoting}}. Consider the example of function application in our target language from the ◊reference['language]{previous section}:

◊code/block/highlighted['racket]{
((λ (x) x) (λ (y) y))
}

To turn this program in our target language into a data structure in Racket, we introduce a quasiquote (◊code/inline{`}):

◊margin-note{Our target language is a subset of Racket, so ◊code/inline{((λ (x) x) (λ (y) y))} is a program both in our target language and in Racket. Quasiquote turns this Racket program into data for other Racket programs to process. The data is the program in our target language, which our interpreter will evaluate. This process demonstrates that ◊emphasis{code can be data, and data can be code}. Data and code are two sides of the same coin.}

◊margin-note{The data structures that quasiquoting create in our examples are (potentially nested) lists and symbols. The equivalent in other programming languages would be (potentially nested) lists and strings, for example, ◊code/inline{[["λ", ["x"], "x"], ["λ", ["y"], "y"]]}.}

◊code/block/highlighted['racket]{
`((λ (x) x) (λ (y) y))
}

The snippet above is a Racket program which defines a program in our target language. Programs in our target language are data from Racket’s perspective, so the Racket program above by itself just outputs ◊code/inline{`((λ (x) x) (λ (y) y))}. In a ◊reference['interpreter]{later section} we will implement an interpreter which receives this data structure as input.

◊margin-note{Unquoting is similar to string interpolation in other languages, for example, Ruby. But on data structures, as opposed to strings.}

◊margin-note{◊emphasis{Everyday programming takeaway}: Bring the problem domain into the language. For example, instead of separate plain-text configuration files, use the host programming language. Tools of the Ruby ecosystem excel at this; the main way to interact and configure them is Ruby code. The result are programs which compose better, in ways not anticipated by the designers.}

Besides the convenient and terse notation, another advantage of using ◊technical-term{quasiquoting} to represent programs in our target language is that we can use Racket programs to build programs in our target language. For this, we use ◊technical-term{unquoting} (◊code/inline{,}), which interpolates Racket expressions in parts of the data structure. For example, consider the following rewrite of the program above:

◊code/block/highlighted['racket]{
(define argument `(λ (y) y))
`((λ (x) x) ,argument)
}


This listing has the same meaning as the previous program. First, it defines a variable named ◊code/inline{argument}, whose value is a data structure representing a program fragment in our target language: ◊code/inline{(λ (y) y)}. Then, it uses ◊technical-term{quasiquote} and ◊technical-term{unquote} to define the program ◊code/inline{((λ (x) x) (λ (y) y))} in our target language. The ◊technical-term{quasiquote} (◊code/inline{`}) starts a program in our target language embedded in Racket (a data structure), and the ◊technical-term{unquote} (◊code/inline{,}) escapes back to Racket. The result of the expression under the ◊technical-term{unquote} is interpolated in place. In the given example, the expression under the ◊technical-term{unquote} is just a reference to the variable defined right above: ◊code/inline{argument}. So its value (the program fragment ◊code/inline{(λ (y) y)} in our target language) is interpolated in place, resulting in the program ◊code/inline{((λ (x) x) (λ (y) y))} in our target language.

As a consequence of using ◊technical-term{quasiquote} and ◊technical-term{unquote} to build programs in our target language, it is not possible to write a whole class of syntax errors in our target language. For example, the program ◊code/inline{`(λ (x) x} has unbalanced parentheses, but our interpreter does not have to handle this case, because it is a syntax error in Racket itself. This would not be the case had we decided to represent programs in our target language as plain text files on disk: a parser would have to detect the issue.

Nevertheless, there are many problematic programs that one can still write. For example, the program ◊code/inline{(λ (x y) x)} is not syntactically valid in our target language, because it defines a function which receives two arguments (◊code/inline{x} and ◊code/inline{y}), and our target language only supports functions with a single argument. In the following section we implement a program to detect these classes of errors and validate the well-formedness of programs in our target language before the interpreter can evaluate them.

◊section['well-formedness-checker]{Well-Formedness Checker}

◊margin-note{◊emphasis{Everyday programming takeaway}: Separate the checking of exceptional cases from the computation. Program confidently, instead of defensively.}

◊new-thought{Before we start} the implementation of our first interpreter, we address the issue of checking whether a program is well-formed. In this section, we introduce a well-formedness checker, which runs before the interpreter, so it does not have to account for error cases. Also, the well-formedness checker is illustrative of the techniques we use to process programs in our language.

The well-formedness checker has two responsibilities: (1) check whether the program is syntactically valid; and (2) check whether all variables are defined before use. The first check rejects programs which are not in the forms defined by our target language. For example, ◊code/inline{(λ (a b) a)} is invalid because it is an anonymous function with two arguments (◊code/inline{a} and ◊code/inline{b}), whereas our target language only allows for functions with one argument. Another example of syntactically invalid program is ◊code/inline{(f a b)}, which is a call to function ◊code/inline{f} with arguments ◊code/inline{a} and ◊code/inline{b}; this too is disallowed because functions only receive one argument.

The second responsibility of the well-formedness checker is to check whether all variables are defined before use. As mentioned in the ◊reference['language]{previous section}, the interpreter does not support these programs, which are said to be ◊technical-term{open}. With this knowledge, we are ready to implement the ◊code/inline{well-formed?} function:

◊margin-note{◊emphasis{Everyday programming takeaway}: When an abstraction is evident, delegate to auxiliary functions instead of mixing responsibilities. In ◊code/inline{well-formed?}, it is better to delegate to ◊code/inline{syntactically-valid?} and ◊code/inline{closed?} than to implement their functionalities directly. In general, give names to concepts whenever those names make sense.}

◊code/block/highlighted['racket]{
(define (well-formed? program)
  (and (syntactically-valid? program) (closed? program)))
}

This implementation is simplistic, because it receives a ◊code/inline{program} as input and just delegates the responsibilities described above to two auxiliary functions ◊code/inline{syntactically-valid?} and ◊code/inline{closed?}. For the rest of this section, we implement these two auxiliary functions.

◊paragraph-separation[]

◊new-thought{We start with} ◊code/inline{syntactically-valid?}:

◊margin-note{Texts after the semicolon (◊code/inline{;}) are comments.}

◊code/block/highlighted['racket]{
(define (syntactically-valid? program-fragment)
    ; TODO
  )
}

This function receives as argument a ◊code/inline{program-fragment}, which is not necessarily a whole program. It makes sense to ask whether a smaller part of a bigger program is syntactically valid, for example, from the program ◊code/inline{(λ (a) (a a))}, we can ask whether ◊code/inline{(a a)} is syntactically valid (it is).

◊margin-note{◊emphasis{Everyday programming takeaway}: Start with the simplest, trivial cases.}

Let us first consider the simplest case, in which the ◊code/inline{program-fragment} is just a variable, for example, the ◊code/inline{program-fragment} ◊code/inline{x}. This fragment on its own is syntactically valid, despite not being well-formed for being open (◊code/inline{x} is used but not defined). To check the syntactical validity, the function just has to check that the ◊code/inline{program-fragment} is a symbol which stands for a variable, as opposed to, for example, a number:

◊code/block/highlighted['racket]{
(define (syntactically-valid? program-fragment)
  (symbol? program-fragment))
}

This simple implementation is just calling Racket’s ◊code/inline{symbol?} function, and it is already enough to check the syntactical validity of variables:

◊code/block/highlighted['racket]{
> (syntactically-valid? `x)
#t
> (syntactically-valid? `42)
#f
}

◊paragraph-separation[]

◊new-thought{The next form of} ◊code/inline{program-fragment} we address in ◊code/inline{syntactically-valid?} is the anonymous function definition, for example:

◊code/block/highlighted['racket]{
(λ (x) (x x))
}

Though, before ◊code/inline{syntactically-valid?} even considers the syntactical validity of the anonymous function definition, it needs to detect that the given ◊code/inline{program-fragment} is of this kind—as opposed to, for example, a variable reference, which we considered above. To this end, we introduce ◊technical-term{pattern matching}. The simplest form of ◊technical-term{pattern matching} is the following:

◊margin-note{
 ◊technical-term{Pattern matching} is a generalization of ◊technical-term{destructuring assignment}. The following listing is an example of ◊technical-term{destructuring assignment} in languages including Ruby, Python and JavaScript:

 ◊code/block/highlighted['racket]{
name, age = ["Wheatley", 6]
 }

 In this program, ◊code/inline{["Wheatley", 6]} is a list composed of the values ◊code/inline{"Wheatley"} and ◊code/inline{6}. The ◊technical-term{destructuring assignment} works by ◊technical-term{destructuring} the list and ◊technical-term{assigning} its elements to the variables ◊code/inline{name} and ◊code/inline{age}, respectively.

 ◊technical-term{Pattern matching} extends ◊technical-term{destructuring assignment} to support arbitrary data structures, beyond lists, tuples and the few other data structures generally supported by ◊technical-term{destructuring assignment}.
}

◊margin-note{The quasiquotation notation for patterns that ◊technical-term{destruct} data structures is the same as the quasiquotation notation for ◊technical-term{constructing} data structures from program fragments, for example, ◊code/inline{`(λ (,argument-name) ,body)}.}

◊code/block/highlighted['racket]{
(match-define `(λ (,argument-name) ,body) `(λ (x) (x x)))
}

This form matches the program ◊code/inline{`(λ (x) (x x))} in our target language with the pattern ◊code/inline{`(λ (,argument-name) ,body)}. As a result, the Racket variable ◊code/inline{argument-name} is bound to the variable name ◊code/inline{x} in our target language; and the Racket variable ◊code/inline{body} is bound to the program fragment ◊code/inline{(x x)}.

In ◊code/inline{syntactically-valid?}, the data structure which is ◊technical-term{subject} of the ◊technical-term{pattern match} (◊code/inline{program-fragment}) might have different forms. Moreover, we want to perform different computations depending on the kind of ◊code/inline{program-fragment}. So the ◊code/inline{match-define} form does not suffice, we have to reach for the ◊code/inline{match} form. The following is an example of ◊code/inline{pattern matching} with the ◊code/inline{match} form:

◊margin-note{The ◊code/inline{match} form is similar to multiway branches (for example, ◊code/inline{switch} and ◊code/inline{case}) in other programming languages. And it works with arbitrary ◊technical-term{patterns} for arbitrary data structures, the same as ◊code/inline{match-define}.}

◊figure{◊svg{match.svg}}

The ◊technical-term{pattern match} with the ◊code/inline{match} form works by matching the ◊technical-term{subject} with each of the ◊technical-term{patterns}, in order. The first ◊technical-term{pattern} that matches determines which ◊technical-term{match clause} has its ◊technical-term{body} executed. In the example above, the ◊technical-term{subject} and the ◊technical-term{patterns} are simple data: numbers. The first ◊technical-term{match clause} whose ◊technical-term{pattern} matches the ◊technical-term{subject} is ◊code/inline{[5 "five"]}, so the ◊technical-term{result} of the ◊technical-term{pattern match} is the ◊technical-term{clause body} ◊code/inline{"five"}.

The example above demonstrates that the ◊code/inline{match} form in Racket has two uses: (1) multiway branching; and (2) destructing data structures. Using it, we can detect in which case the ◊code/inline{program-fragment} given to ◊code/inline{syntactically-valid?} falls. There are only three possibilities, which are the three constructs in our language: (1) definitions of anonymous functions of single argument and single return value; (2) applications of these functions; and (3) variable references.

◊margin-note{The syntax ◊code/inline{#;} comments out the whole form ◊code/inline{[___]} that follows it, where ◊code/inline{___} stands for omitted code. This is necessary because a ◊technical-term{match clause} without a ◊technical-term{body} is not valid Racket syntax. We remove the ◊code/inline{#;} comment markers as we implement ◊code/inline{syntactically-valid?} for different kinds of ◊code/inline{program-fragment}s.}

◊code/block/highlighted['racket]{
(define (syntactically-valid? program-fragment)
  (match program-fragment
    #;[`(λ (,argument-name) ,body)
       ; TODO: (1) Anonymous function definition.
       ]
    #;[`(,function ,argument)
       ; TODO: (2) Function application.
       ]
    #;[`,variable
       ; TODO: (3) Variable reference.
       ]))
}

In the listing above, the ◊technical-term{subject} of the pattern match is the ◊code/inline{program-fragment}, and there are three ◊technical-term{match clauses}, corresponding to the three kinds of ◊code/inline{program-fragment}s. The first ◊technical-term{pattern} is ◊code/inline{`(λ (,argument-name) ,body)}, which matches anonymous function definitions. For example, if ◊code/inline{program-fragment} is ◊code/inline{(λ (x) (x x))}, then ◊code/inline{argument-name} represents ◊code/inline{x} and ◊code/inline{body} stands for ◊code/inline{(x x)}. The other two patterns work similarly.

We already have an implementation for ◊code/inline{variable}s, so we can fill in the last hole in the template above:

◊code/block/highlighted['racket]{
(define (syntactically-valid? program-fragment)
  (match program-fragment
    #;[`(λ (,argument-name) ,body)
       ; TODO: (1) Anonymous function definition.
       ]
    #;[`(,function ,argument)
       ; TODO: (2) Function application.
       ]
    [`,variable
     (symbol? variable)]))
}

The ◊code/inline{syntactically-valid?} function is once again working on the ◊code/inline{program-fragment}s consisting of ◊code/inline{variable}s, which we considered above:

◊code/block/highlighted['racket]{
> (syntactically-valid? `x)
#t
> (syntactically-valid? `42)
#f
}

◊paragraph-separation[]

◊new-thought{Now that} ◊code/inline{syntactically-valid?} can distinguish between the different forms of ◊code/inline{program-fragment}, we return to the issue of checking the syntactical validity of anonymous function definitions. Two conditions must hold: (1) the ◊code/inline{argument-name} must be a symbol (similar to variable references); and (2) the ◊code/inline{body} must be a ◊code/inline{syntactically-valid?} ◊code/inline{program-fragment}.

For the first condition, we can use Racket’s ◊code/inline{symbol?} function, as we did before for variable references. For the second, we can call ◊code/inline{syntactically-valid?} recursively on the ◊code/inline{program-fragment} which is the anonymous function ◊code/inline{body}:

◊full-width{
 ◊code/block/highlighted['racket]{
(define (syntactically-valid? program-fragment)
  (match program-fragment
    [`(λ (,argument-name) ,body)
     (and (symbol? argument-name) (syntactically-valid? body))]
    #;[`(,function ,argument)
       ; TODO: (2) Function application.
       ]
    [`,variable
     (symbol? variable)]))
 }
}

To test our implementation, we use the syntactically valid anonymous function ◊code/inline{(λ (x) x)} and the syntactically ◊emphasis{invalid} anonymous function ◊code/inline{(λ (x y) x)}, which has more arguments than the one allowed:

◊code/block/highlighted['racket]{
> (syntactically-valid? `(λ (x) x))
#t
> (syntactically-valid? `(λ (x y) x))
#f
}

◊paragraph-separation[]

◊new-thought{To complete the implementation} of ◊code/inline{syntactically-valid?}, we consider the case of function applications. The condition for syntactical validity in this case is just that both ◊code/inline{function} and ◊code/inline{argument} are syntactically valid themselves, and we can use ◊code/inline{syntactically-valid?} recursively to check for that:

◊full-width{
 ◊code/block/highlighted['racket]{
(define (syntactically-valid? program-fragment)
  (match program-fragment
    [`(λ (,argument-name) ,body)
     (and (symbol? argument-name) (syntactically-valid? body))]
    [`(,function ,argument)
     (and (syntactically-valid? function) (syntactically-valid? argument))]
    [`,variable
     (symbol? variable)]))
 }
}

To test this final case, we again consider one syntactically valid and one syntactically ◊emphasis{invalid} ◊code/inline{program-fragment}:

◊code/block/highlighted['racket]{
> (syntactically-valid? `(f a))
#t
> (syntactically-valid? `(f a b))
#f
}

The function call ◊code/inline{(f a b)} is syntactically invalid because it has one argument more than allowed.

The implementation of ◊code/inline{syntactically-valid?} is complete. Let us turn to ◊code/inline{closed?}, the other well-formedness condition.

◊paragraph-separation[]

◊new-thought{The implementation of the} ◊code/inline{closed?} function is simple because it delegates most of the work to an auxiliary function, a strategy similar to the one used in ◊code/inline{well-formed?}. Specifically, ◊code/inline{closed?} receives as argument a ◊code/inline{program} and calls ◊code/inline{free-variables} on it. This auxiliary function returns the set of free variables in the program, in other words, the set of variables which are used before definition. If this set is empty, then the program is closed:

◊margin-note{Racket comes with ◊link["https://docs.racket-lang.org/reference/sets.html"]{functions for sets}, including ◊code/inline{set} to create them, ◊code/inline{set-empty?} to check their emptiness and so forth.}

◊margin-note{◊emphasis{Everyday programming takeaway}: Appreciate the difference between data structures and their purposes. A list would work as well as a set for representing ◊code/inline{free-variables}, but a set is conceptually more meaningful, because there is no notion of order and repeated elements would be redundant.}

◊code/block/highlighted['racket]{
(define (closed? program)
  (set-empty? (free-variables program)))
}

Of course, now we have to implement ◊code/inline{free-variables}. It receives as argument a program fragment and returns the set of variables used before definition in it. We follow the technique we used to implement ◊code/inline{syntactically-valid?}, starting with the simplest program possible: ◊code/inline{x}. This program contains only one free variable, ◊code/inline{x} itself. So ◊code/inline{free-variables} just has to return a set containing it:

◊code/block/highlighted['racket]{
(define (free-variables program-fragment)
  (set program-fragment))
}

We can test ◊code/inline{free-variables} with the simple program considered thus far:

◊margin-note{The quote (◊code/inline{'}) in the result means the same as the quasiquote (◊code/inline{`}), except that it does not support unquoting (◊code/inline{,}). For the purposes of this article, the two are mean the same: “the next form is a program in our target language (or a fragment thereof).”}

◊code/block/highlighted['racket]{
> (free-variables `x)
(set 'x)
}

Next, we address the case of function application, for example ◊code/inline{(f a)}. We face the same issue as before, when implementing ◊code/inline{syntactically-valid?}: we need to distinguish between the different forms of ◊code/inline{program-fragment}s. The solution is the same, pattern matching with the ◊code/inline{match} form:

◊code/block/highlighted['racket]{
(define (free-variables program-fragment)
  (match program-fragment
    #;[`(λ (,argument-name) ,body)
       ; TODO: (1) Anonymous function definition.
       ]
    #;[`(,function ,argument)
       ; TODO: (2) Function application.
       ]
    #;[`,variable
       ; TODO: (3) Variable reference.
       ]))
}

Once again, we already have an implementation for the ◊code/inline{variable} case:

◊code/block/highlighted['racket]{
(define (free-variables program-fragment)
  (match program-fragment
    #;[`(λ (,argument-name) ,body)
       ; TODO: (1) Anonymous function definition.
       ]
    #;[`(,function ,argument)
       ; TODO: (2) Function application.
       ]
    [`,variable
     (set variable)]))
}

And, with this implementation, the ◊code/inline{variable} case is still working:

◊code/block/highlighted['racket]{
> (free-variables `x)
(set 'x)
}

Coming back to the case of function application, consider the program ◊code/inline{(f a)}. The ◊code/inline{function} expression in this program is just a variable reference to ◊code/inline{f}, and the ◊code/inline{argument} is just a variable reference to ◊code/inline{a}. Both are free variables, so the set of free variables for the entire program is ◊code/inline{(set 'a 'f)}.

In general, the ◊code/inline{free-variables} of a function application are those from the ◊code/inline{function} expression, ◊emphasis{and} those from the ◊code/inline{argument} expression. We can call ◊code/inline{free-variables} recursively on the ◊code/inline{function} and ◊code/inline{argument} expressions and union the resulting sets:

◊full-width{
 ◊code/block/highlighted['racket]{
(define (free-variables program-fragment)
  (match program-fragment
    #;[`(λ (,argument-name) ,body)
       ; TODO: (1) Anonymous function definition.
       ]
    [`(,function ,argument)
     (set-union (free-variables function) (free-variables argument))]
    [`,variable
     (set variable)]))
 }
}

Let us test this implementation:

◊code/block/highlighted['racket]{
> (free-variables `(f a))
(set 'a 'f)
}

Finally, we consider the case of anonymous function definitions. In the program ◊code/inline{(λ (x) y)}, the variable ◊code/inline{y} is free, but in the program ◊code/inline{(λ (x) x)} there are no free variables. The reason is that the anonymous function definition ◊code/inline{(λ (x) ___)} is defining a variable named ◊code/inline{x}, so any occurrence of ◊code/inline{x} in the body ◊code/inline{___} is ◊technical-term{closed}.

In general, the set of free variables for an anonymous function definition is the set of free variables in its body ◊emphasis{minus} the variable it defines:

◊code/block/highlighted['racket]{
(define (free-variables program-fragment)
  (match program-fragment
    [`(λ (,argument-name) ,body)
     (set-remove (free-variables body) argument-name)]
    [`(,function ,argument)
     (set-union (free-variables function) (free-variables argument))]
    [`,variable
     (set variable)]))
}

We can test this case with the examples mentioned above:

◊code/block/highlighted['racket]{
> (free-variables `(λ (x) y))
(set 'y)
> (free-variables `(λ (x) x))
(set)
}

◊paragraph-separation[]

◊new-thought{This completes the implementation} of ◊code/inline{free-variables} and, consequently, the implementations of ◊code/inline{closed?} and ◊code/inline{well-formed?} as well. Hereafter, we only discuss interpretation of programs which are valid with respect to the ◊code/inline{well-formed?} predicate.

More importantly, note the similarities between the implementations of ◊code/inline{syntactically-valid?} and ◊code/inline{free-variables}. Both of these functions have to traverse the given ◊code/inline{program-fragment}, and they accomplish it using the same technique: first, ◊code/inline{match} on the given ◊code/inline{program-fragment} to detect of which form it is; then, call itself recursively if it is necessary to traverse smaller ◊code/inline{program-fragment}s contained within the given ◊code/inline{program-fragment}. Abstractly, these functions that ◊technical-term{traverse} the given ◊code/inline{program-fragment} have the shape:

◊margin-note{◊emphasis{Everyday programming takeaway}: Resist the temptation of over-abstracting code. While the ◊code/inline{traverse} template occurs repeatedly, it is better to copy and paste this template than to write an abstraction for it (a function, a macro and so forth). The result is more readable and flexible code. The cost of an abstraction would only be worth if we had ◊emphasis{a lot} of traversal functions.}

◊code/block/highlighted['racket]{
(define (traverse program-fragment)
  (match program-fragment
    [`(λ (,argument-name) ,body)
     ___ (traverse body) ___]
    [`(,function ,argument)
     ___ (traverse function) ___ (traverse argument) ___]
    [`,variable
     ___]))
}

Our interpreter and auxiliary functions will follow the ◊code/inline{traverse} pattern. We are ready to move to their implementation.

◊section['interpreter]{Interpreter}

◊new-thought{Our interpreter} is a function which receives a ◊code/inline{program} in our target language as argument and evaluates it to a value in our target language. We start with the template for ◊technical-term{traversing} a ◊code/inline{program}, which we established in the ◊reference['well-formedness-checker]{previous section}:

◊code/block/highlighted['racket]{
(define (interpret program)
  (match program
    #;[`(λ (,argument-name) ,body)
       ; TODO: (1) Anonymous function definition.
       ]
    #;[`(,function ,argument)
       ; TODO: (2) Function application.
       ]
    #;[`,variable
       ; TODO: (3) Variable reference.
       ]))
}

Let us first consider case (3), in which the ◊code/inline{program} is a ◊code/inline{variable}, for example, ◊code/inline{x}. In this case, the program is ◊technical-term{open}, and is not well-formed. Our interpreter does not need to handle programs which are not well-formed, because they have already been discarded by the ◊code/inline{well-formed?} checker. So we can completely eliminate this case:

◊margin-note{◊emphasis{Everyday programming takeaway}: Program confidently, instead of defensively. In a real-world scenario, ◊code/inline{interpret}’s inputs would be guarded by ◊code/inline{well-formed?} via, for example, a ◊link["https://docs.racket-lang.org/guide/contracts.html"]{contract}. It does not have to handle error cases, which simplifies the implementation and strengthens it: checking for the well-formedness condition occurs in a single place, if the rules change, there is only one place to update and consistency is guaranteed.}

◊code/block/highlighted['racket]{
(define (interpret program)
  (match program
    #;[`(λ (,argument-name) ,body)
       ; TODO: (1) Anonymous function definition.
       ]
    #;[`(,function ,argument)
       ; TODO: (2) Function application.
       ]))
}

Next, we address case (1), in which the program is the definition of an anonymous function, for example, ◊code/inline{(λ (x) x)}. Anonymous function definitions are already values in our language, so the interpreter can return the given ◊code/inline{program} unaltered:

◊code/block/highlighted['racket]{
(define (interpret program)
  (match program
    [`(λ (,argument-name) ,body)
     program]
    #;[`(,function ,argument)
       ; TODO: (2) Function application.
       ]))
}

This implementation is enough to interpret our first valid example program correctly:

◊code/block/highlighted['racket]{
> (interpret `(λ (x) x))
'(λ (x) x)
}

The final case is function application. The following is an example of function application in our language:

◊code/block/highlighted['racket]{
((λ (x) x) (λ (y) y)) ;; => (λ (y) y)
}

The applied function is ◊code/inline{(λ (x) x)} and the argument is ◊code/inline{(λ (y) y)}. The meaning of function application is the same as in mathematics and most programming languages: in the function body (in our example, the body is ◊code/inline{x}) substitute every occurrence of the argument name (in our example, ◊code/inline{x}) for the given argument (in our example, ◊code/inline{(λ (y) y)}).

The ◊technical-term{pattern} we use in ◊code/inline{interpret} to match function application is ◊code/inline{`(,function ,argument)}. So, in our example, the Racket variable ◊code/inline{function} is bound to ◊code/inline{(λ (x) x)} and the Racket variable ◊code/inline{argument} is bound to ◊code/inline{(λ (y) y)}. Our first task is to ◊technical-term{destruct} ◊code/inline{function} to retrieve its ◊code/inline{argument-name} and ◊code/inline{body}:

◊code/block/highlighted['racket]{
(match-define `(λ (,argument-name) ,body) function)
}

Then, we can call an auxiliary function to perform the substitution:

◊code/block/highlighted['racket]{
(define (interpret program)
  (match program
    [`(λ (,argument-name) ,body)
     program]
    [`(,function ,argument)
     (match-define `(λ (,argument-name) ,body) function)
     (substitute body argument-name argument)]))
}

The ◊code/inline{substitute} auxiliary function receives as argument a function ◊code/inline{body} and returns a modified version of it in which each occurrence of the given ◊code/inline{argument-name} has been substituted with the given ◊code/inline{argument}. To implement it, we use the same ◊technical-term{traversal} template:

◊code/block/highlighted['racket]{
(define (substitute body argument-name argument)
  (match body
    #;[`(λ (,other-argument-name) ,other-body)
       ; TODO: (1) Anonymous function definition.
       ]
    #;[`(,function ,other-argument)
       ; TODO: (2) Function application.
       ]
    #;[`,variable
       ; TODO: (3) Variable reference.
       ]))
}

In our running example, the call to ◊code/inline{substitute} has the following form: ◊code/inline{(substitute `x `x `(λ (y) y))}. So ◊code/inline{body} is ◊code/inline{x}, ◊code/inline{argument-name} is ◊code/inline{x} and ◊code/inline{argument} is ◊code/inline{`(λ (y) y)}. This ◊code/inline{body} falls into the third kind in the ◊technical-term{pattern match} above: variable reference. The expected result is the given ◊code/inline{argument}:

◊code/block/highlighted['racket]{
(define (substitute body argument-name argument)
  (match body
    #;[`(λ (,other-argument-name) ,other-body)
       ; TODO: (1) Anonymous function definition.
       ]
    #;[`(,function ,other-argument)
       ; TODO: (2) Function application.
       ]
    [`,variable
     argument]))
}

This is enough to interpret our example:

◊code/block/highlighted['racket]{
> (interpret `((λ (x) x) (λ (y) y)))
'(λ (y) y)
}

◊paragraph-separation[]

◊new-thought{But there are more details} regarding function application that we need to consider. The first is that the implementation of ◊code/inline{substitute} for variable references above is overly simplistic. It replaces every ◊code/inline{variable} with ◊code/inline{argument}, not only those ◊code/inline{variable}s equal to the ◊code/inline{argument-name}. For example, if the ◊code/inline{body} had been ◊code/inline{z}, then ◊code/inline{substitute} would have substituted it for the ◊code/inline{argument}, which would have been incorrect, since the ◊code/inline{argument-name} was ◊code/inline{x}. We can simulate this scenario by calling ◊code/inline{substitute} directly:

◊code/block/highlighted['racket]{
> (substitute `z `x `(λ (y) y))
'(λ (y) y)
}

To fix this, we check if the ◊code/inline{variable} we found in the ◊code/inline{body} is equal to the ◊code/inline{argument-name}. If it is, then we substitute, otherwise, we leave it unaltered:

◊full-width{
 ◊code/block/highlighted['racket]{
(define (substitute body argument-name argument)
  (match body
    #;[`(λ (,other-argument-name) ,other-body)
       ; TODO: (1) Anonymous function definition.
       ]
    #;[`(,function ,other-argument)
       ; TODO: (2) Function application.
       ]
    [`,variable
     (if (equal? argument-name variable) argument variable)]))
 }
}

With this modification, ◊code/inline{substitute} works as intended:

◊code/block/highlighted['racket]{
> (substitute `z `x `(λ (y) y))
'z
}

For the rest of its implementation, ◊code/inline{substitute} just calls itself recursively on the parts of the given ◊code/inline{body}. The effect is that it traverses the data structure representing our program fragment. This guarantees that every occurrence of ◊code/inline{argument-name} in ◊code/inline{body} is substituted, even those that occur deeper in the data structure:

◊full-width{
 ◊code/block/highlighted['racket]{
(define (substitute body argument-name argument)
  (match body
    [`(λ (,other-argument-name) ,other-body)
     `(λ (,other-argument-name) ,(substitute other-body argument-name argument))]
    [`(,function ,other-argument)
     `(,(substitute function argument-name argument)
       ,(substitute other-argument argument-name argument))]
    [`,variable
     (if (equal? argument-name variable) argument variable)]))
 }
}

The following listing includes examples of uses of ◊code/inline{substitute}. These examples require traversing the ◊code/inline{body} with the recursive calls to ◊code/inline{substitute} we implemented above, because the ◊code/inline{argument-name} ◊code/inline{x} occurs deeper in the ◊code/inline{body}. In the first example, it occurs inside an anonymous function definitions; and, in the second example, it occurs inside a function application:

◊code/block/highlighted['racket]{
> (substitute `(λ (z) x) `x `(λ (y) y))
'(λ (z) (λ (y) y))
> (substitute `(z x) `x `(λ (y) y))
'(z (λ (y) y))
}

◊paragraph-separation[]

◊new-thought{In our next program}, the ◊code/inline{function} to be applied is not immediately available. Instead, it is itself the result of a function application:

◊code/block/highlighted['racket]{
(((λ (x) x) (λ (y) y)) (λ (z) z)) ;; => (λ (z) z)
}

At the top level, this program is a function application, which matches the ◊code/inline{`(,function ,argument)} ◊technical-term{pattern}. The ◊code/inline{function} is ◊code/inline{((λ (x) x) (λ (y) y))} and the ◊code/inline{argument} is ◊code/inline{(λ (z) z)}. The ◊code/inline{function} is not immediately available, it is a function application ◊code/inline{((λ (x) x) (λ (y) y))} itself. We can use ◊code/inline{interpret} on ◊code/inline{function} to evaluate it into a value:

◊full-width{
 ◊code/block/highlighted['racket]{
(define (interpret program)
  (match program
    [`(λ (,argument-name) ,body)
     program]
    [`(,function ,argument)
     (define interpreted-function (interpret function))
     (match-define `(λ (,argument-name) ,body) interpreted-function)
     (substitute body argument-name argument)]))
 }
}

In the listing above, note the recursive call to ◊code/inline{interpret}. The result of this recursive call is a value, because ◊code/inline{interpret} returns values in our language. And values in our language are functions, which we can then ◊technical-term{destruct} with ◊code/inline{match-define}. With this change, ◊code/inline{interpret} works for our program:

◊code/block/highlighted['racket]{
> (interpret `(((λ (x) x) (λ (y) y)) (λ (z) z)))
'(λ (z) z)
}

An issue similar to the one addressed above occurs in the ◊code/inline{argument} of a function application. It might not be an immediate value, but a computation. For example, consider the following program:

◊code/block/highlighted['racket]{
((λ (x) x) ((λ (y) y) (λ (z) z))) ;; => (λ (z) z)
}

In this function application, the ◊code/inline{argument} is ◊code/inline{((λ (y) y) (λ (z) z))}, which is not a value. So we have to call ◊code/inline{interpret} on the ◊code/inline{argument} before the substitution as well:

◊full-width{
 ◊code/block/highlighted['racket]{
(define (interpret program)
  (match program
    [`(λ (,argument-name) ,body)
     program]
    [`(,function ,argument)
     (define interpreted-function (interpret function))
     (define interpreted-argument (interpret argument))
     (match-define `(λ (,argument-name) ,body) interpreted-function)
     (substitute body argument-name interpreted-argument)]))
 }
}

Our interpreter now works for the given example:

◊code/block/highlighted['racket]{
> (interpret `((λ (x) x) ((λ (y) y) (λ (z) z))))
'(λ (z) z)
}

◊paragraph-separation[]

◊new-thought{For our next program}, the result of a function application is another function application:

◊code/block/highlighted['racket]{
((λ (i) ((λ (x) x) (λ (y) y))) (λ (z) z)) ;; => (λ (y) y)
}

◊margin-note{The transformation of wrapping a program with a function which ignores its argument and is immediately applied to a throwaway argument always preserves the meaning of the original program. This process is called ◊technical-term{η-conversion}. More specifically, it is an ◊technical-term{η-abstraction}, as opposed to an ◊technical-term{η-reduction}, which is going in the opposite direction—removing the wrapping function and the throwaway argument.}

This program is similar to our first example of function application ◊code/inline{((λ (x) x) (λ (y) y))}. The difference is that it has been wrapped in a function which ignores its argument ◊code/inline{i}. This function is immediately applied to the throwaway argument ◊code/inline{(λ (z) z)}.

Our interpreter does not work on this program:

◊code/block/highlighted['racket]{
> (interpret `((λ (i) ((λ (x) x) (λ (y) y))) (λ (z) z)))
'((λ (x) x) (λ (y) y))
}

This output is the result of the substitution of the throwaway argument ◊code/inline{(λ (z) z)} in the body of the function ◊code/inline{(λ (i) ((λ (x) x) (λ (y) y)))}. There were no occurrences of the argument name ◊code/inline{i} in the body, because it is an ignored argument. So the result of the substitution is just the body, ◊code/inline{((λ (x) x) (λ (y) y))}. But the interpreter should not stop at this point, it needs to proceed interpreting these intermediary program, until it reaches a value. To accomplish this, we call ◊code/inline{interpret} recursively, with the result of the substitution:

◊full-width{
 ◊code/block/highlighted['racket]{
(define (interpret program)
  (match program
    [`(λ (,argument-name) ,body)
     program]
    [`(,function ,argument)
     (define interpreted-function (interpret function))
     (define interpreted-argument (interpret argument))
     (match-define `(λ (,argument-name) ,body) interpreted-function)
     (define substituted-body (substitute body argument-name interpreted-argument))
     (interpret substituted-body)]))
 }
}

◊margin-note{The recursion in ◊code/inline{interpret} is grounded because eventually it reaches a value, which it returns unaltered instead of following the second ◊technical-term{match clause}.}

Now ◊code/inline{interpret} works correctly for the running example:

◊code/block/highlighted['racket]{
> (interpret `((λ (i) ((λ (x) x) (λ (y) y))) (λ (z) z)))
'(λ (y) y)
}

◊paragraph-separation[]

◊new-thought{The next programs} we address are those concerning variable-name reuse. First, the case in which the reused name occurs in separate functions:

◊code/block/highlighted['racket]{
> (interpret `((λ (x) x) (λ (x) x)))
'(λ (x) x)
}

Our interpreter already handles this program correctly. But it does not work for the second case, in which the reused variable name occurs in a nested function. Consider the following program:

◊figure{◊svg{shadowing-interpretation.svg}}

We expect the result of this program to be ◊code/inline{(λ (z) z)}, and not ◊code/inline{(λ (y) y)}. But the current implementation outputs the wrong value:

◊code/block/highlighted['racket]{
> (interpret `(((λ (x) (λ (x) x)) (λ (y) y)) (λ (z) z)))
'(λ (y) y)
}

The reason for this is revealed after the inner function application:

◊code/block/highlighted['racket]{
> (interpret `((λ (x) (λ (x) x)) (λ (y) y)))
'(λ (x) (λ (y) y))
}

This program fragment is a function application, in which the ◊code/inline{function} is ◊code/inline{(λ (x) (λ (x) x))} and the ◊code/inline{argument} is ◊code/inline{(λ (y) y)}. The interpreter calls ◊code/inline{substitute} with the ◊code/inline{body} ◊code/inline{(λ (x) x)} and the ◊code/inline{argument-name} ◊code/inline{x}:

◊code/block/highlighted['racket]{
> (substitute `(λ (x) x) `x `(λ (y) y))
'(λ (x) (λ (y) y))
}

The ◊code/inline{x} in the body of the function ◊code/inline{(λ (x) x)} refers to its argument, not the outer declaration of ◊code/inline{x}, which we are currently substituting. The problem is in ◊code/inline{substitute}: when it finds a function definition whose ◊code/inline{other-argument-name} is the same as the given ◊code/inline{argument-name}, it should stop traversing the program fragment. It should not try to substitute occurrences of the ◊code/inline{argument-name} any further, because they refer to ◊code/inline{other-argument-name}:

◊full-width{
 ◊code/block/highlighted['racket]{
(define (substitute body argument-name argument)
  (match body
    [`(λ (,other-argument-name) ,other-body)
     (if (equal? argument-name other-argument-name)
         body
         `(λ (,other-argument-name) ,(substitute other-body argument-name argument)))]
    [`(,function ,other-argument)
     `(,(substitute function argument-name argument)
       ,(substitute other-argument argument-name argument))]
    [`,variable
     (if (equal? argument-name variable) argument variable)]))
 }
}

◊margin-note{While ◊code/inline{argument-name} and ◊code/inline{other-argument-name} have the same identifier (◊code/inline{x}, in the example), they are different bindings—similar to how two people might have the same name despite not being the same person. This observation that multiple bindings might have the same name is what makes ◊technical-term{shadowing} in particular and ◊technical-term{lexical scoping} in general work. This feature is important because it allows program fragments to ◊emphasis{compose} better. Writers of a function can name the arguments what they want, without global knowledge of the program and all identifiers in it. This is particularly desirable when different parts of a program are written by different people and may even come from different packages.}

Our program now works as we expected:

◊code/block/highlighted['racket]{
> (interpret `(((λ (x) (λ (x) x)) (λ (y) y)) (λ (z) z)))
'(λ (z) z)
}

◊paragraph-separation[]

◊new-thought{This concludes the implementation} of our interpreter. To test it in a realistic setting, we can use the final version of the program ◊link/internal["/prose/programming-language-theory-explained-for-the-working-programmer--principles-of-programming-languages"]{from the article that introduces our target language}, which calculates the sum ◊code/inline{1 + 2 + 3 + 4 + 5}:

◊margin-note{In this listing, we use Racket’s ◊code/inline{eval} function to transform the result of ◊code/inline{interpret}—a Racket data structure representing a program in our target language—into a Racket function. For example, ◊code/inline{(eval `(λ (x) x))} results in the Racket function ◊code/inline{(λ (x) x)}—note that there is no quasiquoting in this result, it is a native Racket function. We then use ◊code/inline{pretty-print} to inspect the outputs of our program. The ◊code/inline{pretty-print} is defined in ◊link/internal["/prose/programming-language-theory-explained-for-the-working-programmer--principles-of-programming-languages"]{the article that introduces our target language}.}

◊margin-note{To reproduce this result in DrRacket, enter the listing in the ◊technical-term{interactions} window (on the bottom or the right), instead of the ◊technical-term{definitions} window (on the top or the left). The reason is that ◊code/inline{eval}, as written, only works in the ◊technical-term{interactions} window.}

◊code/block/highlighted['racket]{
> (pretty-print
 (eval
  (interpret
   `((λ (number)
       (((λ (sum-up-to/rest)
           (λ (number)
             (((((λ (condition)
                   (λ (then)
                     (λ (else)
                       ((condition then)
                        else))))
                 ((λ (number)
                    ((number
                      (λ (ignored-argument)
                        (λ (first)
                          (λ (second)
                            second))))
                     (λ (first)
                       (λ (second) first))))
                  number))
                (λ (dummy)
                  (λ (function)
                    (λ (argument) argument))))
               (λ (dummy)
                 (((λ (number-left)
                     (λ (number-right)
                       (λ (function)
                         (λ (argument)
                           ((number-left
                             function)
                            ((number-right
                              function)
                             argument))))))
                   number)
                  ((sum-up-to/rest
                    sum-up-to/rest)
                   ((λ (number)
                      ((λ (pair)
                         (pair
                          (λ (left)
                            (λ (right) left))))
                       ((number
                         (λ (current-pair)
                           (((λ (left)
                               (λ (right)
                                 (λ (selector)
                                   ((selector
                                     left)
                                    right))))
                             ((λ (pair)
                                (pair
                                 (λ (left)
                                   (λ (right)
                                     right))))
                              current-pair))
                            (((λ (number-left)
                                (λ (number-right)
                                  (λ (function)
                                    (λ (argument)
                                      ((number-left
                                        function)
                                       ((number-right
                                         function)
                                        argument))))))
                              ((λ (pair)
                                 (pair
                                  (λ (left)
                                    (λ (right)
                                      right))))
                               current-pair))
                             (λ (function)
                               (λ (argument)
                                 (function
                                  argument)))))))
                        (((λ (left)
                            (λ (right)
                              (λ (selector)
                                ((selector
                                  left)
                                 right))))
                          (λ (function)
                            (λ (argument)
                              argument)))
                         (λ (function)
                           (λ (argument)
                             argument))))))
                    number)))))
              (λ (ignore-me) ignore-me))))
         (λ (sum-up-to/rest)
           (λ (number)
             (((((λ (condition)
                   (λ (then)
                     (λ (else)
                       ((condition then)
                        else))))
                 ((λ (number)
                    ((number
                      (λ (ignored-argument)
                        (λ (first)
                          (λ (second)
                            second))))
                     (λ (first)
                       (λ (second) first))))
                  number))
                (λ (dummy)
                  (λ (function)
                    (λ (argument) argument))))
               (λ (dummy)
                 (((λ (number-left)
                     (λ (number-right)
                       (λ (function)
                         (λ (argument)
                           ((number-left
                             function)
                            ((number-right
                              function)
                             argument))))))
                   number)
                  ((sum-up-to/rest
                    sum-up-to/rest)
                   ((λ (number)
                      ((λ (pair)
                         (pair
                          (λ (left)
                            (λ (right) left))))
                       ((number
                         (λ (current-pair)
                           (((λ (left)
                               (λ (right)
                                 (λ (selector)
                                   ((selector
                                     left)
                                    right))))
                             ((λ (pair)
                                (pair
                                 (λ (left)
                                   (λ (right)
                                     right))))
                              current-pair))
                            (((λ (number-left)
                                (λ (number-right)
                                  (λ (function)
                                    (λ (argument)
                                      ((number-left
                                        function)
                                       ((number-right
                                         function)
                                        argument))))))
                              ((λ (pair)
                                 (pair
                                  (λ (left)
                                    (λ (right)
                                      right))))
                               current-pair))
                             (λ (function)
                               (λ (argument)
                                 (function
                                  argument)))))))
                        (((λ (left)
                            (λ (right)
                              (λ (selector)
                                ((selector
                                  left)
                                 right))))
                          (λ (function)
                            (λ (argument)
                              argument)))
                         (λ (function)
                           (λ (argument)
                             argument))))))
                    number)))))
              (λ (ignore-me) ignore-me)))))
        number))
     (λ (function)
       (λ (argument)
         (function
          (function
           (function
            (function
             (function argument)))))))))))
15
}

The output is what we expected, ◊code/inline{15}. Our interpreter is fully functional for any program in our target language.

◊paragraph-separation[]

◊new-thought{But this interpreter is not revealing} all interesting aspects of interpretation. For example, it depends on Racket’s support for recursive functions to compute nested expressions—see the recursive calls in ◊code/inline{interpret}’s implementation. When our interpreter finds a function application, it starts processing it; if the ◊code/inline{function} or the ◊code/inline{argument} are function applications themselves, then it defers the rest of the processing of the outer function application, interprets the inner function applications, and then resumes the work on the outer function application. This whole process is implicit, hidden by the recursive nature of ◊code/inline{interpret}’s implementation. Furthermore, if given a ◊code/inline{program} which does not terminate, then ◊code/inline{interpret} itself does not terminate, and there is no way to inspect the computations that are happening during interpretation.

We will address these aspects of interpretation in subsequent articles, making our interpreter more transparent and revealing more interesting facets of computation.

◊section['conclusion]{Conclusion}

◊new-thought{We started with} a fundamental question: How do interpreters evaluate programs to values? The find an answer, we implemented a simple interpreter for a simple language. Despite the lack of features, this is machinery capable of general computation; adding support for numbers, data structures, more control-flow constructs and so forth would be a matter of convenience for humans, not enhancing the fundamental computational power. In the process of writing our interpreter, we used ◊technical-term{pattern matching} and devised a template for traversing hierarchical data structures. Finally, we observed the limitations of the interpreter we implemented; there are a few interesting aspects of evaluation that it conceals for relying on the host language (Racket). We will address these issues by modifying our interpreter in subsequent articles.

◊section['references]{References}

◊margin-note{For more on ◊acronym{PLT} Redex, read ◊link/internal["/prose/playing-the-game-with-plt-redex/"]{◊publication{Playing the Game with ◊acronym{PLT} Redex}}.}

◊new-thought{The approach to} interpretation followed by this article is inspired by ◊link["https://mitpress.mit.edu/sicp/full-text/book/book.html"]{◊publication{Structure and Interpretation of Computer Programs}}, the classic textbook. We follow a more modern approach using pattern matching, which is based on ◊link["https://redex.racket-lang.org/"]{◊acronym{PLT} Redex} and ◊link["https://mitpress.mit.edu/books/semantics-engineering-plt-redex"]{◊publication{Semantics Engineering with ◊acronym{PLT} Redex}}. A great source for learning about interpretation in depth is the ◊link["http://library.readscheme.org/page1.html"]{Lambda Papers}. People interested in reading more recent research papers need to understand the associated formal notation, for which the book ◊link["https://pl.cs.jhu.edu/pl/book/dist/"]{◊publication{Principles of Programming Languages}} is a gentle introduction (disclaimer, the author is my advisor).