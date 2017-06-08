#lang pollen

◊define-meta[title]{Programming-Language Theory Explained for the Working Programmer: Interpretation}
◊define-meta[date]{2017-06-08}

◊margin-note{This article assumes knowledge in the ◊link/internal["/prose/programming-language-theory-explained-for-the-working-programmer--principles-of-programming-languages"]{essential features of programming languages}. Experience with functional programming languages in general and ◊link["https://racket-lang.org/"]{Racket} in particular are helpful, but not required. Refer to Racket’s ◊link["https://docs.racket-lang.org/quick/index.html"]{quick introduction} for more.}

◊margin-note{◊link["https://git.leafac.com/www.leafac.com/plain/source/prose/programming-language-theory-explained-for-the-working-programmer--interpretation/programming-language-theory-explained-for-the-working-programmer--interpretation.rkt"]{Here} is the code for this entire article.}

◊new-thought{Interpreters are programs} which run programs. They receive as input code specifying the desired computations, execute them, and output the results. How do interpreters work? In this article we address this question by writing four different interpreters. The goal is to explore the underlying principles of computing, not to produce a realistic interpreter for an industrial-grade language. But, in the process, we introduce ideas and techniques that are generally applicable to everyday problem solving. We avoid the mathematical notation and jargon usually associated with this kind of topic, driving the exposition by working code. So this article is approachable to all programmers.

◊section['language]{Language}

◊new-thought{To start writing} our first interpreter, we need to answer two questions: Which language do we use to write it? Which language does it interpret? For the former, we choose Racket. It has features that make interpreters easier to read, for example, ◊technical-term{pattern matching} and ◊technical-term{quasiquoting}—which we introduce in due time. This choice is solely based on convenience, this article could be rewritten in any other programming language.

More interesting than the choice of base language is the choice of target language. Which language does our interpreter interpret? In this article, we are not interested in language design, our objective is not to understand how particular language features are interpreted. Instead, we are interested in studying interpretation itself, and understanding the fundamental principles behind computation. So the target language should be as ◊technical-term{simple} as possible.

We choose ◊technical-term{simplicity} over ◊technical-term{convenience}. Our target language preferably includes as few features as possible, so that our interpreters remain small and understandable, and changing them requires minimal effort. As a consequence, our target language is ◊technical-term{difficult} to use; programs written in it are verbose and unintelligible. It would be a bad choice for everyday programming tasks, but it is good target language for this article, because, despite its simplicity, it remains a programming language with enough features to support arbitrary computations.

◊margin-note{For more on our target language, refer to ◊link/internal["/prose/programming-language-theory-explained-for-the-working-programmer--principles-of-programming-languages"]{◊publication{Programming-Language Theory Explained for the Working Programmer: Principles of Programming Languages}}.}

There exist many languages that fit our requirements. From all of them, we choose one that is particularly elegant, for its compactness. This target language represents a minimal core with only the essential features of programming languages: (1) definitions of anonymous functions of single argument and single return value; (2) applications of these functions; and (3) variable references. The following listing is an example of a program in this language:

◊code/block/highlighted['racket]{
(λ (x) x)
}

◊margin-note{The lambda (◊code/inline{λ}) is the only Greek letter and the most unusual notation in this article. It is worth introducing a short notation for anonymous functions because we write them frequently. This notation also justifies the formal name for our target language: ◊technical-term{Lambda calculus}.}

◊margin-note{
 Our choice of notation is based on Racket’s notation, so our target language is a subset of Racket. This means that programs in our target language are also programs in Racket, which is useful to check the correctness of our interpreters and for interactive exploration. (Though this latter application is limited by the way Racket prints functions—it just outputs ◊code/inline{#<procedure>}, instead of the function definition.)

 Another consequence of this decision is that our target language inherits many implicit design choices from Racket. For example, we evaluate the argument to a value before passing it into the function, we only evaluate function applications reachable from the top level—and not those that occur within function bodies before the function is applied—and so forth. Different choices would lead to different interpreters, which would change the meaning of some programs. For example, some programs that run forever in our target language would terminate had we decided to only evaluate function arguments to values when they are needed, as opposed to before passing them into the function. We follow Racket’s design decisions because they are similar to those of most popular programming languages.
}

The program above defines a function which has no name (anonymous function). Function definitions are enclosed in parentheses, and start with the Greek letter lambda (◊code/inline{λ}). After the ◊code/inline{λ} there is the name of the argument received by the function, also in parentheses—◊code/inline{(x)} in the example. Finally, there is the function body, an expression specifying which computation the function performs. In the example, the computation is to just return the argument ◊code/inline{x}, unaltered.

In our target language, functions are values. They are the only kind of values; there are no numbers, booleans, strings, data structures and other constructs usually found in programming languages. This highlights how ◊technical-term{simple} the language is. Despite its simplicity, our target language is ◊link/internal["/prose/programming-language-theory-explained-for-the-working-programmer--principles-of-programming-languages"]{capable of performing arbitrary computations}. In the case of the listing above, the defined function is the whole program. This is similar to how the following is a complete program in languages including Racket, Ruby, JavaScript and Python:

◊code/block/highlighted['racket]{
5
}

The listing above defines a full program in the mentioned languages. Its result is the number ◊code/inline{5}, because numbers are values in these languages. In our target language functions are values, so the result of our first program in our target language is the function ◊code/inline{(λ (x) x)}.

Our first program is an example of function definition—◊code/inline{(λ ...)}—and variable reference—the ◊code/inline{x} in the function body. There is only one other feature in our target language, function application. It is represented by function and argument enclosed in parentheses. For example, if ◊code/inline{f} is a function and ◊code/inline{a} is an argument, then ◊code/inline{(f a)} is a function application. This is equivalent to the mathematical notation also used by many popular programming languages: ◊code/inline{f(a)}. The following listing is a full program illustrating function application in our target language:

◊code/block/highlighted['racket]{
((λ (x) x) (λ (y) y))
}

◊margin-note{The replacement of argument names in the function body for the argument provided in the function application is the mechanism that allows for arbitrary ◊emphasis{communication} of data in the program. This process is known as ◊technical-term{β reduction}. The connection between names and their meanings is the fundamental power of the Lambda calculus and has deep implications. Refer to ◊link["https://blogs.janestreet.com/whats-in-a-name/"]{◊publication{What’s in a name?}}, by Olin Shivers for more.}

This program is an application of the function ◊code/inline{(λ (x) x)} to the argument ◊code/inline{(λ (y) y)}. The interpretation of this is the same as in mathematics and most programming languages: replace every occurrence of the argument name ◊code/inline{x} in ◊code/inline{(λ (x) x)}’s body with the argument ◊code/inline{(λ (y) y)}. Because ◊code/inline{(λ (x) x)}’s body is just ◊code/inline{x}, the result of this program is ◊code/inline{(λ (y) y)}.

◊paragraph-separation[]

◊new-thought{We covered all features} of our target language, but there are two corner cases that we need to address: variable-name reuse and variable references that have not been defined. The first case, variable-name reuse, can occur in two ways. The simplest way is illustrated by the following listing:

◊code/block/highlighted['racket]{
((λ (x) x) (λ (x) x))
}

This is a variation on the program we used above to discuss function application. The only difference is that the variable ◊code/inline{y} is consistently renamed to ◊code/inline{x}, so the name ◊code/inline{x} is used by both functions. These names occur in separate functions, so they do not interfere with each other. The same reasoning as before applies, and the result of this program is ◊code/inline{(λ (x) x)}. This is the same result as the previous example, except that the variable ◊code/inline{y} is consistently renamed to ◊code/inline{x} in the result as well.

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

◊new-thought{How do we represent} programs in our language? Generally, programs are plain text files, which interpreters read from the disk. Then they transform the text of the program into data structures in memory, through processes called ◊technical-term{lexical analysis} and ◊technical-term{syntactic analysis}. This would be easy to do because our target language is a subset of Racket, and it comes with ◊technical-term{lexical} and ◊technical-term{syntactical analyzers} for itself. But we take an even easier approach, and represent our programs as data structures in Racket directly. The language has a feature to make this representation convenient: ◊link["https://docs.racket-lang.org/guide/qq.html"]{◊technical-term{quasiquoting}}. Consider the example of function application in our target language from above:

◊code/block/highlighted['racket]{
((λ (x) x) (λ (y) y))
}

To turn this program in our target language into a data structure in Racket, we introduce a quasiquote (◊code/inline{`}), as in the following Racket program:

◊margin-note{Our target language is a subset of Racket, so ◊code/inline{((λ (x) x) (λ (y) y))} is a program both in our target language and in Racket. Quasiquote turns this Racket program into data. This data is the program in our target language, over which our interpreter will work. This process demonstrates that ◊emphasis{code can be data, and data can be code}. Data and code are two sides of the same coin.}

◊code/block/highlighted['racket]{
`((λ (x) x) (λ (y) y))
}

Another advantage of using ◊technical-term{quasiquoting} to represent programs in our target language is that we can use Racket programs to build programs in our target language. For this, we use ◊technical-term{unquoting} (◊code/inline{,}), which interpolates Racket expressions in parts of the data structure. For example, consider the following rewrite of the program above:

◊code/block/highlighted['racket]{
(define argument `(λ (y) y))
`((λ (x) x) ,argument)
}

◊margin-note{Another consequence of using ◊technical-term{quasiquote} and ◊technical-term{unquote} in Racket to build programs in our target language is that it eliminates many syntax errors, as those would be syntax errors in Racket itself. This would not be the case had we decided to represent programs in our target language as plain text files on disk.}

This listing has the same meaning as the previous program. First, it defines a variable named ◊code/inline{argument}, whose value is a data structure representing a program fragment in our target language: ◊code/inline{(λ (y) y)}. Then, it uses ◊technical-term{quasiquote} and ◊technical-term{unquote} to define the program ◊code/inline{((λ (x) x) (λ (y) y))} in our target language. The ◊technical-term{quasiquote} (◊code/inline{`}) starts a program in our target language embedded in Racket (a data structure), and the ◊technical-term{unquote} (◊code/inline{,}) escapes back to Racket. The result of the expression under the ◊technical-term{unquote} is interpolated in place. In the given example, the expression under the ◊technical-term{unquote} is just a reference to the variable defined right above: ◊code/inline{argument}. So its value (the program fragment ◊code/inline{(λ (y) y)} in our target language) is interpolated in place, resulting in the program ◊code/inline{((λ (x) x) (λ (y) y))} in our target language.

◊; TODO: Stopped here. Write section about well-formedness check.

◊section['first-interpreter]{First Interpreter}

◊new-thought{Our first interpreter} is a function which receives as argument a program like those defined on the ◊reference['language]{previous section} and returns a value in our language. We build it incrementally, driven by examples, starting with an anonymous function definition:

◊code/block/highlighted['racket]{
(λ (x) x)
}

Anonymous function definitions are already values in our language, so the interpreter can return the given expression unaltered:

◊code/block/highlighted['racket]{
(define (interpret expression)
  expression)
}

This implementation is enough to interpret our first example program correctly:

◊margin-note{The quote (◊code/inline{'}) in the result means the same as the quasiquote (◊code/inline{`}), except that it does not support unquoting (◊code/inline{,}). For the purposes of this article, the two are mean the same: “the next form is a program in our target language.”}

◊code/block/highlighted['racket]{
> (interpret `(λ (x) x))
'(λ (x) x)
}

◊paragraph-separation[]

◊new-thought{The next program we address} in our interpreter implementation is the function application:

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

◊margin-note{The quasiquotation notation for patterns that ◊technical-term{destruct} data structures is the same as the quasiquotation notation for ◊technical-term{constructing} data structures from program fragments, for example, ◊code/inline{`(λ (,argument-name) ,body)}.}

◊code/block/highlighted['racket]{
(match-define `(,function ,argument)
              `((λ (x) x) (λ (y) y)))
}

This form matches the program in our target language ◊code/inline{`((λ (x) x) (λ (y) y))} with the pattern ◊code/inline{`(,function ,argument)}. As a result, the variable ◊code/inline{function} is bound to the program fragment ◊code/inline{(λ (x) x)} and the variable ◊code/inline{argument} is bound to the program fragment ◊code/inline{(λ (y) y)}.

In our interpreter, the data structure which is ◊technical-term{subject} of the ◊technical-term{pattern match} (◊code/inline{expression}) might have different forms. Moreover, we want to perform different computations depending on the kind of ◊code/inline{expression}. So the ◊code/inline{match-define} form does not suffice, we have to reach for the ◊code/inline{match} form, which was designed for this purpose. The following is an example of ◊code/inline{pattern matching} with the ◊code/inline{match} form:

◊margin-note{The ◊code/inline{match} form is similar to multiway branches (for example, ◊code/inline{switch} and ◊code/inline{case}) in other programming languages. And it works with arbitrary ◊technical-term{patterns} for arbitrary data structures.}

◊figure{◊svg{match.svg}}

The ◊technical-term{pattern match} with the ◊code/inline{match} form works by matching the ◊technical-term{subject} to each of the ◊technical-term{patterns}, in order. The first ◊technical-term{pattern} that matches determines which ◊technical-term{match clause} has its ◊technical-term{body} executed. In the example above, the ◊technical-term{subject} and the ◊technical-term{patterns} are simple data: numbers. The first ◊technical-term{match clause} whose ◊technical-term{pattern} matches the ◊technical-term{subject} is ◊code/inline{[5 "five"]}, so the ◊technical-term{result} of the ◊technical-term{pattern match} is the ◊technical-term{clause body} ◊code/inline{"five"}.

The example above demonstrates that the ◊code/inline{match} form in Racket has two uses: (1) multiway branching; and (2) destructing data structures. Using it, we can detect in which case the given ◊code/inline{expression} falls. There are only three possibilities, which are the three constructs in our language: (1) definitions of anonymous functions of single argument and single return value; (2) applications of these functions; and (3) variable references.

◊margin-note{Texts after the semicolon (◊code/inline{;}) are comments. And ◊code/inline{#;} comments out the whole form ◊code/inline{[___]} that follows it. This is necessary because a ◊technical-term{match clause} without a ◊technical-term{body} is not valid Racket syntax. We remove the ◊code/inline{#;} comment markers as we implement the interpreter for different kinds of expressions.}

◊code/block/highlighted['racket]{
(define (interpret expression)
  (match expression
    #;[`(λ (,argument-name) ,body)
       ; TODO: (1) Anonymous function definition.
       ]
    #;[`(,function ,argument)
       ; TODO: (2) Function application.
       ]
    #;[variable
       ; TODO: (3) Variable reference.
       ]))
}

In the listing above, the ◊technical-term{subject} of the pattern match is the ◊code/inline{expression}, and there are three ◊technical-term{match clauses}, corresponding to the three kinds of ◊code/inline{expression}s. The first ◊technical-term{pattern} is ◊code/inline{`(λ (,argument-name) ,body)}, which matches anonymous function definitions. For example, if ◊code/inline{expression} is ◊code/inline{(λ (x) (x x))}, then ◊code/inline{argument-name} represents ◊code/inline{x} and ◊code/inline{body} stands for ◊code/inline{(x x)}. The other two patterns work similarly.

We already have an implementation for anonymous function definitions, so we can fill in the first hole in the template above:

◊code/block/highlighted['racket]{
(define (interpret expression)
  (match expression
    [`(λ (,argument-name) ,body)
     expression]
    #;[`(,function ,argument)
       ; TODO: (2) Function application.
       ]
    #;[variable
       ; TODO: (3) Variable reference.
       ]))
}

The interpreter is working again for programs consisting of anonymous function declarations. It outputs the same value as before for our first example:

◊code/block/highlighted['racket]{
> (interpret `(λ (x) x))
'(λ (x) x)
}

◊paragraph-separation[]

◊new-thought{We now return} to function application. The following is the example of function application in our language which we are addressing:

◊code/block/highlighted['racket]{
((λ (x) x) (λ (y) y)) ;; => (λ (y) y)
}

The applied function is ◊code/inline{(λ (x) x)} and the argument is ◊code/inline{(λ (y) y)}. The meaning of function application is the same as in mathematics and most programming languages: in the function body (in our example, the body is ◊code/inline{x}) substitute every occurrence of the argument name (in our example, ◊code/inline{x}) for the given argument (in our example, ◊code/inline{(λ (y) y)}).

The ◊technical-term{pattern} we use in ◊code/inline{interpret} to match function application is ◊code/inline{`(,function ,argument)}. So, in our example, the variable name ◊code/inline{function} is bound to the value ◊code/inline{(λ (x) x)} and the variable name ◊code/inline{argument} is bound to the value ◊code/inline{(λ (y) y)}. Our first task is to ◊technical-term{destruct} ◊code/inline{function} to retrieve its argument name and body:

◊code/block/highlighted['racket]{
(match-define `(λ (,argument-name) ,body)
  function)
}

Then, we can call an auxiliary function to perform the substitution:

◊code/block/highlighted['racket]{
(define (interpret expression)
  (match expression
    [`(λ (,argument-name) ,body)
     expression]
    [`(,function ,argument)
     (match-define `(λ (,argument-name) ,body)
       function)
     (substitute body argument-name argument)]
    #;[variable
       ; TODO: (3) Variable reference.
       ]))
}

The ◊code/inline{substitute} auxiliary function receives as argument a function ◊code/inline{body} and returns a modified version of it in which each occurrence of the given ◊code/inline{argument-name} has been substituted with the given ◊code/inline{argument}. To implement ◊code/inline{substitute}, we use the same strategy as in ◊code/inline{interpret}. We start by ◊technical-term{pattern matching} on the given ◊code/inline{body} to distinguish between the possible kinds:

◊margin-note{
 The template for the ◊code/inline{substitute} implementation is the same as the template for the ◊code/inline{interpret} implementation. This is not a coincidence, both functions work by traversing the data structures that represents the programs in our language. In technical terms, both ◊code/inline{substitute} and ◊code/inline{interpret} are performing ◊technical-term{syntax-directed translations}, via a ◊technical-term{depth-first traversals} of the ◊technical-term{abstract syntax tree} of the programs in ◊technical-term{postorder}.

 The difference between ◊code/inline{substitute} and ◊code/inline{interpret} is only the computations they perform during this traversal, so we could factor out their common parts. We do not do this for clarity and simplicity.
}

◊code/block/highlighted['racket]{
(define (substitute
         body argument-name argument)
  (match body
    #;[`(λ (,other-argument-name) ,other-body)
       ; TODO: (1) Anonymous function definition.
       ]
    #;[`(,function ,other-argument)
       ; TODO: (2) Function application.
       ]
    #;[variable
       ; TODO: (3) Variable reference.
       ]))
}

In our running example, the call to ◊code/inline{substitute} has the following form: ◊code/inline{(substitute `x `x `(λ (y) y))}. So ◊code/inline{body} is ◊code/inline{x}, ◊code/inline{argument-name} is ◊code/inline{x} and ◊code/inline{argument} is ◊code/inline{`(λ (y) y)}. This ◊code/inline{body} falls into the third kind in the ◊technical-term{pattern match} above: variable references. The expected result is the given ◊code/inline{argument}:

◊code/block/highlighted['racket]{
(define (substitute
         body argument-name argument)
  (match body
    #;[`(λ (,other-argument-name) ,other-body)
       ; TODO: (1) Anonymous function definition.
       ]
    #;[`(,function ,other-argument)
       ; TODO: (2) Function application.
       ]
    [variable
     argument]))
}

This is enough to interpret our example:

◊code/block/highlighted['racket]{
> (interpret `((λ (x) x) (λ (y) y)))
'(λ (y) y)
}

◊paragraph-separation[]

◊new-thought{The implementation} of ◊code/inline{substitute} above is overly simplistic. It replaces every ◊code/inline{variable} with ◊code/inline{argument}, not only those ◊code/inline{variable}s equal to the ◊code/inline{argument-name}. For example, if the ◊code/inline{body} had been ◊code/inline{z}, then ◊code/inline{substitute} would have substituted it for the ◊code/inline{argument}, which would have been incorrect, since ◊code/inline{argument-name} was ◊code/inline{x}. We can simulate this scenario by calling ◊code/inline{substitute} directly:

◊code/block/highlighted['racket]{
> (substitute `z `x `(λ (y) y))
'(λ (y) y)
}

To fix this, we check if the ◊code/inline{variable} we found in the ◊code/inline{body} is equal to the ◊code/inline{argument-name}. If it is, then we substitute, otherwise, we leave it unaltered:

◊code/block/highlighted['racket]{
(define (substitute
         body argument-name argument)
  (match body
    #;[`(λ (,other-argument-name) ,other-body)
       ; TODO: (1) Anonymous function definition.
       ]
    #;[`(,function ,other-argument)
       ; TODO: (2) Function application.
       ]
    [variable
     (if (equal? argument-name variable)
         argument
         variable)]))
}

With this modification, ◊code/inline{substitute} works as we want:

◊code/block/highlighted['racket]{
> (substitute `z `x `(λ (y) y))
'z
}

For the rest of its implementation, ◊code/inline{substitute} just calls itself recursively on the parts of the given ◊code/inline{body}. The effect is that it traverses the data structure representing our program fragment. This guarantees that every occurrence of ◊code/inline{argument-name} in ◊code/inline{body} is substituted, even those that occur deeper in the data structure:

◊code/block/highlighted['racket]{
(define (substitute
         body argument-name argument)
  (match body
    [`(λ (,other-argument-name) ,other-body)
     `(λ (,other-argument-name)
        ,(substitute
          other-body argument-name argument))]
    [`(,function ,other-argument)
     `(,(substitute
         function argument-name argument)
       ,(substitute
         other-argument argument-name argument))]
    [variable
     (if (equal? argument-name variable)
         argument
         variable)]))
}

The following listing includes examples of ◊code/inline{substitute} in use. These examples require traversing the ◊code/inline{body} with the recursive calls to ◊code/inline{substitute} we implemented above, because the ◊code/inline{argument-name} (◊code/inline{x}) occurs deeper in the ◊code/inline{body}. In the first example, it occurs inside an anonymous function definitions; and, in the second example, it occurs inside a function application:

◊code/block/highlighted['racket]{
> (substitute `(λ (z) x) `x `(λ (y) y))
'(λ (z) (λ (y) y))
> (substitute `(z x) `x `(λ (y) y))
'(z (λ (y) y))
}

◊paragraph-separation[]

◊new-thought{In our next program}, the ◊code/inline{function} to be applied is not immediately available. Instead, it is the result of a function application:

◊code/block/highlighted['racket]{
(((λ (x) x) (λ (y) y)) (λ (z) z)) ;; => (λ (z) z)
}

At the top level, this program is a function application, which matches the ◊code/inline{`(,function ,argument)} ◊technical-term{pattern}. The ◊code/inline{function} is ◊code/inline{((λ (x) x) (λ (y) y))} and the argument is ◊code/inline{(λ (z) z)}. The ◊code/inline{function} is not immediately available, it is the result of the function application ◊code/inline{((λ (x) x) (λ (y) y))}. We can use ◊code/inline{interpret} on ◊code/inline{function} to evaluate it into a value:

◊code/block/highlighted['racket]{
(define (interpret expression)
  (match expression
    [`(λ (,argument-name) ,body)
     expression]
    [`(,function ,argument)
     (define interpreted-function
       (interpret function))
     (match-define `(λ (,argument-name) ,body)
       interpreted-function)
     (substitute body argument-name argument)]
    #;[variable
       ; TODO: (3) Variable reference.
       ]))
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

◊code/block/highlighted['racket]{
(define (interpret expression)
  (match expression
    [`(λ (,argument-name) ,body)
     expression]
    [`(,function ,argument)
     (define interpreted-function
       (interpret function))
     (define interpreted-argument
       (interpret argument))
     (match-define `(λ (,argument-name) ,body)
       interpreted-function)
     (substitute body argument-name interpreted-argument)]
    #;[variable
       ; TODO: (3) Variable reference.
       ]))
}

Our interpreter now works for the given example:

◊code/block/highlighted['racket]{
> (interpret `((λ (x) x) ((λ (y) y) (λ (z) z))))
'(λ (z) z)
}

◊paragraph-separation[]

◊new-thought{For our next program}, the result of a function application is another function application:

◊code/block/highlighted['racket]{
((λ (i) ((λ (x) x) (λ (y) y))) (λ (z) z))
;; => (λ (y) y)
}

◊margin-note{The transformation of wrapping a program with a function which ignores its argument and is immediately applied to a throwaway argument always preserves the meaning of the original program. This process is called ◊technical-term{η-conversion}. More specifically, it is an ◊technical-term{η-abstraction}, as opposed to an ◊technical-term{η-reduction}, which is going in the opposite direction—removing the wrapping function and the throwaway argument.}

This program is similar to our first example of function application ◊code/inline{((λ (x) x) (λ (y) y))}. The difference is that it has been wrapped into a function which ignores its argument ◊code/inline{i}. This function is immediately applied to the throwaway argument ◊code/inline{(λ (z) z)}.

Our interpreter does not work in this program:

◊code/block/highlighted['racket]{
> (interpret `((λ (i) ((λ (x) x) (λ (y) y))) (λ (z) z)))
'((λ (x) x) (λ (y) y))
}

This output is the result of the substitution of the throwaway argument ◊code/inline{(λ (z) z)} in the body of the function ◊code/inline{(λ (i) ((λ (x) x) (λ (y) y)))}. There were no occurrences of the argument name ◊code/inline{i} in the body, because it is an ignored argument. So the result of the substitution is just the body, ◊code/inline{((λ (x) x) (λ (y) y))}. But the interpreter should not stop at this point, it needs to proceed interpreting this program fragment, until it reaches a value. To accomplish this, we call ◊code/inline{interpret} recursively, with the result of the substitution:

◊code/block/highlighted['racket]{
(define (interpret expression)
  (match expression
    [`(λ (,argument-name) ,body)
     expression]
    [`(,function ,argument)
     (define interpreted-function
       (interpret function))
     (define interpreted-argument
       (interpret argument))
     (match-define `(λ (,argument-name) ,body)
       interpreted-function)
     (define substituted-body
       (substitute
        body argument-name
        interpreted-argument))
     (interpret substituted-body)]
    #;[variable
       ; TODO: (3) Variable reference.
       ]))
}

Now ◊code/inline{interpret} works correctly for the running example:

◊code/block/highlighted['racket]{
> (interpret `((λ (i) ((λ (x) x) (λ (y) y))) (λ (z) z)))
'(λ (y) y)
}

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

◊margin-note{While ◊code/inline{argument-name} and ◊code/inline{other-argument-name} have the same identifier (◊code/inline{x}, in the example), they are different bindings—similar to how two different people might have the same name. This observation that multiple bindings might have the same name is what makes ◊technical-term{shadowing} work. This feature is important because it allows program fragments to ◊emphasis{compose} better. Writers of a function can name the arguments how they want, without global knowledge of the program and all identifiers in it. This is particularly desirable when different parts of a program are written by different people and may even come from different packages.}

The ◊code/inline{x} in the body of the function ◊code/inline{(λ (x) x)} refers to its argument, not the outer declaration of ◊code/inline{x}, which we are currently substituting. So we need to change ◊code/inline{substitute}: when it finds a function definition whose ◊code/inline{other-argument-name} is the same as the given ◊code/inline{argument-name}, it should stop traversing the program fragment. It should not try to substitute occurrences of the ◊code/inline{argument-name} any further, because they refer to ◊code/inline{other-argument-name}:

◊code/block/highlighted['racket]{
(define (substitute
         body argument-name argument)
  (match body
    [`(λ (,other-argument-name) ,other-body)
     (if (equal? argument-name other-argument-name)
         body
         `(λ (,other-argument-name)
            ,(substitute
              other-body argument-name argument)))]
    [`(,function ,other-argument)
     `(,(substitute
         function argument-name argument)
       ,(substitute
         other-argument argument-name argument))]
    [variable
     (if (equal? argument-name variable)
         argument
         variable)]))
}

Our program now works as we expected:

◊code/block/highlighted['racket]{
> (interpret `(((λ (x) (λ (x) x)) (λ (y) y)) (λ (z) z)))
'(λ (z) z)
}

◊paragraph-separation[]

◊new-thought{There is one final} consideration for our interpreter: what should ◊code/inline{interpret} do when the given ◊code/inline{expression} is a ◊code/inline{variable}? For example, consider the following program:

◊code/block/highlighted['racket]{
x
}

In this case, there is no value the interpreter can output, because the meaning of ◊code/inline{x} is undefined. In general, the interpreter only receives an ◊code/inline{expression} which is a ◊code/inline{variable} if this ◊code/inline{variable} has its meaning undefined. Otherwise ◊code/inline{substitute} would have already substituted it for a value in a previous step of the interpretation.

Our interpreter does not handle the case of variables used before their definitions, so it should error. With this observation, we can complete our interpreter. The following listing is the full implementation:

◊margin-note{
 There is one edge case that our interpreter does not handle: undefined variables whose values are never necessary. For example, consider the program ◊code/inline{(λ (x) y)}. This program is a function definition, which is already a value, so the interpreter outputs ◊code/inline{(λ (x) y)} as the result. But the meaning of ◊code/inline{y} is not defined, so this result does not make sense on its own. For simplicity, we will not handle this case in the interpreter. We could perform this check prior to interpretation, in a pre-processing step that would check for the ◊technical-term{well-formedness} of the program. In our language, the only ◊technical-term{well-formedness} condition is whether the program is ◊technical-term{closed} or not. The implementation would consist of traversing the program—in a similar fashion to ◊code/inline{interpret} and ◊code/inline{substitute}—while keeping track of the variables that have already been defined and those that are used. Explaining this implementation is beyond the scope of this article, but it is available with the ◊link["https://git.leafac.com/www.leafac.com/plain/source/prose/programming-language-theory-explained-for-the-working-programmer--interpretation/programming-language-theory-explained-for-the-working-programmer--interpretation.rkt"]{rest of the code}.}

◊code/block/highlighted['racket]{
(define (interpret expression)
  (match expression
    [`(λ (,argument-name) ,body)
     expression]
    [`(,function ,argument)
     (define interpreted-function
       (interpret function))
     (define interpreted-argument
       (interpret argument))
     (match-define `(λ (,argument-name) ,body)
       interpreted-function)
     (define substituted-body
       (substitute
        body argument-name
        interpreted-argument))
     (interpret substituted-body)]
    [variable
     (raise-user-error
      (~a "Variable not found: " variable))]))

(define (substitute
         body argument-name argument)
  (match body
    [`(λ (,other-argument-name) ,other-body)
     (if (equal? argument-name other-argument-name)
         body
         `(λ (,other-argument-name)
            ,(substitute
              other-body argument-name argument)))]
    [`(,function ,other-argument)
     `(,(substitute
         function argument-name argument)
       ,(substitute
         other-argument argument-name argument))]
    [variable
     (if (equal? argument-name variable)
         argument
         variable)]))
}

◊paragraph-separation[]

◊new-thought{To check our interpret correct}, we can use the final version of the program ◊link/internal["/prose/programming-language-theory-explained-for-the-working-programmer--principles-of-programming-languages"]{from the article that introduces our target language}:

◊margin-note{In this listing, we use Racket’s ◊code/inline{eval} function to transform the result of ◊code/inline{interpret}—a Racket data structure representing a program in our target language—into a Racket function. For example, ◊code/inline{(eval `(λ (x) x))} results in the Racket function ◊code/inline{(λ (x) x)}—note that there is no quasiquoting in this result, it is a native Racket function. We then use ◊code/inline{pretty-print} to inspect the outputs of our program. The ◊code/inline{pretty-print} is defined in ◊link/internal["/prose/programming-language-theory-explained-for-the-working-programmer--principles-of-programming-languages"]{the article that introduces our target language}.}

◊margin-note{To reproduce this result in DrRacket, enter the listing in the ◊technical-term{interactions} window (on the bottom or the right), instead of the ◊technical-term{definitions} window (on the top or the left). The reason is ◊code/inline{eval}, as written, only works in the ◊technical-term{interactions} window.}

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

The output is what we expected, ◊code/inline{15}. Our interpreter is fully functional for any program in our target language. But this interpreter is not revealing all interesting aspects of interpretation. For example, it depends on Racket’s support for recursive functions to compute nested expressions—see the recursive calls in ◊code/inline{interpret}’s implementation. When our interpreter finds a function application, it starts processing it; if the ◊code/inline{function} or the ◊code/inline{argument} are function applications themselves, then it defers the rest of the processing of the outer function application, interprets the inner function applications, and then resumes the work on the outer function application. This whole process is implicit, hidden by the recursive nature of ◊code/inline{interpret}’s implementation.

The next section addresses these aspects, making our interpreter more transparent and revealing more interesting facets of interpretation.

◊section['debugger-like-interpreter]{Debugger-Like Interpreter}

◊margin-note{
 In technical terms, our first interpreter is a ◊technical-term{big-step interpreter}, because the whole interpretation happens in a single big traversal of the program. One call to ◊code/inline{interpret} suffices to interpret a whole program to a value.

 The ◊technical-term{debugger-like interpreter} of this section, in opposition, is called a ◊technical-term{small-step interpreter}. Each call to ◊code/inline{step}—which we implement later in this section—takes a single step towards a value, resolving a single function application. For convenience and to keep a compatible interface with the ◊technical-term{big-step interpreter}, we implement an ◊code/inline{interpret} function in this section. Like the ◊code/inline{interpret} from the ◊technical-term{big-step interpreter}, it also interprets expressions to values in a single call, but it does so by repeatedly calling ◊code/inline{step}. It is the ◊code/inline{step} function that characterizes the ◊technical-term{debugger-like interpreter} as a ◊technical-term{small-step interpreter}.
}

◊margin-note{Another motivation for a ◊technical-term{debugger-like interpreter} is that, in our first interpreter, the ◊technical-term{stack} of pending work was implicit in the base language (Racket) stack. In the ◊technical-term{debugger-like interpreter} the remaining work becomes a first-class citizen that we can reason about—in the form of a ◊technical-term{continuation}, which we introduce later in this section.}

◊new-thought{Our first interpreter} defined in the ◊reference['first-interpreter]{previous section} takes the simplest approach possible to interpretation. When considering a function application in which the ◊code/inline{function} or the ◊code/inline{argument} are function applications themselves, the ◊code/inline{interpret} function recursively calls itself. The effect is that the path the interpreter takes is opaque. The ◊code/inline{interpret} function receives a program and outputs a value, but the computations necessary to get to the result are not clear.

In this section, we rewrite our interpreter to take a different approach, more similar to that of ◊technical-term{step-debuggers}. ◊technical-term{Step-debuggers} are tools that aid program understanding and debugging, they allow the user to run a program step-by-step—either line-by-line or expression-by-expression. In our case, the level of granularity that is interesting is the function application, because function applications are the smallest pieces of computation that preserve meaning.

If we inspected interpretation in the midst of ◊code/inline{substitute}, we would potentially find meaningless program fragments in which there are undefined variables. For example, while substituting the argument name ◊code/inline{x} for the value ◊code/inline{(λ (y) y)} in the program fragment ◊code/inline{(x x)}, we could find the program fragment ◊code/inline{((λ (y) y) x)}, in which only the first use of ◊code/inline{x} has been substituted. The program fragment ◊code/inline{((λ (y) y) x)} has no meaning on its own, because the variable ◊code/inline{x} is undefined.

If we inspected interpretation after a few function applications, we would potentially miss some nuances of the process. So a single function application is the best level of granularity for a ◊technical-term{step} in our ◊technical-term{debugger-like interpreter}.

◊paragraph-separation[]

◊new-thought{To allow us to focus} on our study of interpretation, we start by reducing the scope of our ◊technical-term{debugger-like interpreter}. It does not need to handle the error case of programs including undefined variables. We assume that the programs the ◊technical-term{debugger-like interpreter} receives as arguments have already been checked by an external well-formedness checker. The implementation of this checker is not discussed in this article, but is available ◊link["https://git.leafac.com/www.leafac.com/plain/source/prose/programming-language-theory-explained-for-the-working-programmer--interpretation/programming-language-theory-explained-for-the-working-programmer--interpretation.rkt"]{in the implementation}.

◊paragraph-separation[]

◊new-thought{We start with} a function called ◊code/inline{step}. It has this name because its purpose is to take a single ◊technical-term{step} towards evaluating an ◊code/inline{expression} to a value, similar to the functionality of the ◊technical-term{step} button on a ◊technical-term{step-debugger}. The ◊code/inline{step} function is similar to ◊code/inline{interpret} as defined in the ◊reference['first-interpreter]{previous section}, but it only evaluates one function application, instead of all of them. The structure is the same as for other functions that traverse the program:

◊code/block/highlighted['racket]{
(define (step expression)
  (match expression
    #;[`(λ (,argument-name) ,body)
       ; TODO: (1) Anonymous function definition.
       ]
    #;[`(,function ,argument)
       ; TODO: (2) Function application.
       ]
    #;[variable
       ; TODO: (3) Variable reference.
       ]))
}

As noted before, ◊code/inline{step} will not handle the case of undefined variables. For simplicity, we consider that the given ◊code/inline{expression} has already been checked and is guaranteed to be well-formed. This allows us to eliminate the third ◊technical-term{match clause} entirely:

◊code/block/highlighted['racket]{
(define (step expression)
  (match expression
    #;[`(λ (,argument-name) ,body)
       ; TODO: (1) Anonymous function definition.
       ]
    #;[`(,function ,argument)
       ; TODO: (2) Function application.
       ]))
}

In the case of the first ◊technical-term{match clause}, an anonymous function definition is already a value, so ◊code/inline{step} only returns the given ◊code/inline{expression}, unaltered:

◊code/block/highlighted['racket]{
(define (step expression)
  (match expression
    [`(λ (,argument-name) ,body)
     expression]
    #;[`(,function ,argument)
       ; TODO: (2) Function application.
       ]))
}

This was the same approach taken by ◊code/inline{interpret} from our first interpreter. It means that an anonymous function application ◊technical-term{steps} to itself. In a ◊technical-term{step-debugger}, it would entail that clicking on the ◊technical-term{step} button would not change the ◊code/inline{expression}, because there would be no pending computation.

For the case of function application, ◊code/inline{step} cannot reuse the approach from our first interpreter. Instead, it works in three parts: first, find which function application should happen next; then, substitute the argument name for the argument in the function body; finally, build the resulting expression. This process is necessary because the components of a function application might be function applications themselves. For example, consider the following program:

◊code/block/highlighted['racket]{
(((λ (x) x) (λ (y) y)) (λ (z) z))
}

In this program, the function of the top-level application is ◊code/inline{((λ (x) x) (λ (y) y))}. This is a function application itself, and it needs to be resolved before we can perform the top-level application. The same issue would arise if the argument was a function application. So, when given the ◊code/inline{expression} above, the ◊code/inline{step} function does not evaluate it directly to a value as our first interpreter did. Instead, it identifies that the next computation immediately available is ◊code/inline{((λ (x) x) (λ (y) y))}, performs it, and outputs ◊code/inline{((λ (y) y) (λ (z) z))}. A subsequent call to ◊code/inline{step} would then reach the final value of the program: ◊code/inline{(λ (z) z)}.

In the general case, function applications might be arbitrarily nested, and more than one inner application might be ready for resolution, when both their ◊code/inline{function} and ◊code/inline{argument} are already values. So we delegate this choice of which application to resolve next to an auxiliary function ◊code/inline{split-expression}, which we define later. The function ◊code/inline{split-expression} has this name because it ◊informal{splits} the given ◊code/inline{expression} in two parts: the function application which we resolve next, and the rest of the expression.

◊margin-note{The representation for ◊technical-term{holes} using ◊code/inline{(hole)} does not conflict with existing constructs in our target language, because function applications would include an argument in the parentheses and variable references would not have parentheses.}

The function application which we resolve next is called ◊technical-term{reduction expression}, because ◊technical-term{reduction} is the technical term for what we have been informally calling ◊informal{resolving a function application}. We represent ◊technical-term{reduction expression} as any other program fragment, for example, ◊code/inline{`((λ (x) x) (λ (y) y))}. The rest of the program, in which we found the ◊technical-term{reduction expression}, is called ◊technical-term{continuation}, because it represents the computations that ◊code/inline{step} is going to perform ◊emphasis{after} the current one, on subsequent calls. We represent ◊technical-term{continuations} as a ◊informal{program with a hole}, and the ◊technical-term{hole} is identified by ◊code/inline{(hole)}, for example:

◊code/block/highlighted['racket]{
`((hole) (λ (z) z))
}

The ◊code/inline{split-expression} function has to return two values: the ◊technical-term{reduction expression} and the ◊technical-term{continuation}. In Racket, functions can return multiple values using the form ◊code/inline{values}, for example, ◊code/inline{(values `((λ (x) x) (λ (y) y)) `((hole) (λ (z) z)))}. To bind these results to variables, we use the ◊code/inline{define-values} form, for example:

◊code/block/highlighted['racket]{
(define-values (reduction-expression continuation)
  (values `((λ (x) x) (λ (y) y)) `((hole) (λ (z) z))))
}

The ◊code/inline{reduction-expression} returned by ◊code/inline{split-expression} is guaranteed to be a function application in which both the ◊code/inline{function} and ◊code/inline{argument} are immediately available—they are values, not other function applications. Furthermore, if we fill the ◊technical-term{hole} in the ◊code/inline{continuation} with the ◊code/inline{reduction-expression}, then we have our original ◊code/inline{expression} back; in other words, this decomposition does not lose any information.

Because the ◊code/inline{reduction-expression} is a function application ready for evaluation, we can use the same ◊code/inline{substitute} from the ◊reference['first-interpreter]{previous section} and substitute the ◊code/inline{argument-name} for the ◊code/inline{argument} in the ◊code/inline{body}. Then, we fill the ◊technical-term{hole} in the ◊code/inline{continuation} with the resulting program fragment. We use another auxiliary function ◊code/inline{fill-hole}, which we define later, for this last part. This is the complete listing for ◊code/inline{step}:

◊code/block/highlighted['racket]{
(define (step expression)
  (match expression
    [`(λ (,argument-name) ,body)
     expression]
    [`(,function ,argument)
     (define-values (reduction-expression continuation)
       (split-expression expression))
     (match-define `((λ (,argument-name) ,body) ,argument)
       reduction-expression)
     (define reduced-expression
       (substitute body argument-name argument))
     (fill-hole reduced-expression continuation)]))
}

◊paragraph-separation[]

◊new-thought{There are still} two missing pieces in our ◊technical-term{debugger-like interpreter}: the auxiliary functions ◊code/inline{split-expression} and ◊code/inline{fill-hole}. We start by addressing ◊code/inline{split-expression}.

First, note that ◊code/inline{split-expression} is only called with ◊code/inline{expression}s which are function applications; otherwise, the ◊code/inline{expression}s would have been anonymous function definitions, which are values, and ◊code/inline{step} would have returned them unaltered, without calling ◊code/inline{split-expression}. The task of ◊code/inline{split-expression} is to chose which of the potentially arbitrarily nested function applications to compute next. The only constraint is that the function application must be ready for computation, which means both the ◊code/inline{function} and the ◊code/inline{argument} are already values, and not other nested function applications.

But multiple function applications might be in this state in a given ◊code/inline{expression}, and ◊code/inline{split-expression} could chose any of them. Which application to evaluate next is a design decision and we follow Racket’s approach: go from left to right, and chose the innermost function application. Other orders would work equally well, but this corresponds more closely to programmers’ intuitions.

The structure of the ◊code/inline{split-expression} function is similar to ◊code/inline{step}, in the sense that it receives an ◊code/inline{expression} as argument and them ◊technical-term{pattern matches} on it using the ◊code/inline{match} form. But the ◊technical-term{patterns} in ◊code/inline{split-expression} are different, because it consider different cases: (1) both the ◊code/inline{function} and the ◊code/inline{argument} are already values and the given ◊code/inline{expression} is ready for evaluation; (2) the ◊code/inline{function} is already a value, but the ◊code/inline{argument} is an application that needs to be resolved; (3) the ◊code/inline{function} is not a value yet, it needs to be resolved. To implement theses cases, we rely on the ◊code/inline{match} form following the first ◊technical-term{match clause} whose ◊technical-term{pattern} matches:

◊code/block/highlighted['racket]{
(define (split-expression expression)
  (match expression
    #;[`((λ (,argument-name/function) ,body/function)
         (λ (,argument-name/argument) ,body/argument))
       ; TODO: (1) Both function and argument are values.
       ]
    #;[`((λ (,argument-name/function) ,body/function)
         ,argument)
       ; TODO: (2) Function is a value, but argument is not.
       ]
    #;[`(,function ,argument)
       ; TODO: (3) Function is not a value.
       ]))
}

This order guarantees left-to-right evaluation, because we only consider the case of a ◊code/inline{function} which is not an immediate value (3) ◊emphasis{after} we have considered the case in which it ◊emphasis{is} an immediate value (2).

In the first case, both ◊code/inline{function} and ◊code/inline{argument} are already values—functions—which means the ◊code/inline{expression} is ready for evaluation. So ◊code/inline{split-expression} returns the ◊code/inline{expression} as the ◊code/inline{reduction-expression} and the ◊code/inline{continuation} is just ◊code/inline{(hole)}, because there is no other context around the given ◊code/inline{expression}:

◊code/block/highlighted['racket]{
(define (split-expression expression)
  (match expression
    [`((λ (,argument-name/function) ,body/function)
       (λ (,argument-name/argument) ,body/argument))
     (values expression `(hole))]
    #;[`((λ (,argument-name/function) ,body/function)
         ,argument)
       ; TODO: (2) Function is a value, but argument is not.
       ]
    #;[`(,function ,argument)
       ; TODO: (3) Function is not a value.
       ]))
}

In the second case, the ◊code/inline{function} is already a value, but the ◊code/inline{argument} is not, so the next immediately resolvable function application—the ◊code/inline{reduction-expression}—must be in the program fragment represented by ◊code/inline{argument}. The ◊code/inline{split-expression} function recursively calls itself with ◊code/inline{argument} and propagates the resulting ◊code/inline{reduction-expression} and ◊code/inline{continuation}, taking care of wrapping the ◊code/inline{continuation} with the function application in ◊code/inline{expression}:

◊code/block/highlighted['racket]{
(define (split-expression expression)
  (match expression
    [`((λ (,argument-name/function) ,body/function)
       (λ (,argument-name/argument) ,body/argument))
     (values expression `(hole))]
    [`((λ (,argument-name/function) ,body/function)
       ,argument)
     (define-values (reduction-expression continuation)
       (split-expression argument))
     (values reduction-expression
             `((λ (,argument-name/function) ,body/function)
               ,continuation))]
    #;[`(,function ,argument)
       ; TODO: (3) Function is not a value.
       ]))
}

The final case is similar to the second, except that the subject of the recursive call is ◊code/inline{function}. The strategy is the same: call ◊code/inline{split-expression} itself with the ◊code/inline{function} and forward the resulting ◊code/inline{reduction-expression} and ◊code/inline{continuation}, taking care of wrapping the ◊code/inline{continuation} with the function application in ◊code/inline{expression}:

◊code/block/highlighted['racket]{
(define (split-expression expression)
  (match expression
    [`((λ (,argument-name/function) ,body/function)
       (λ (,argument-name/argument) ,body/argument))
     (values expression `(hole))]
    [`((λ (,argument-name/function) ,body/function)
       ,argument)
     (define-values (reduction-expression continuation)
       (split-expression argument))
     (values reduction-expression
             `((λ (,argument-name/function) ,body/function)
               ,continuation))]
    [`(,function ,argument)
     (define-values (reduction-expression continuation)
       (split-expression function))
     (values reduction-expression
             `(,continuation ,argument))]))
}

◊paragraph-separation[]

◊new-thought{The final auxiliary function} is ◊code/inline{fill-hole}, which, given an program fragment and a ◊code/inline{continuation} (a program fragment with a ◊technical-term{hole} in it), fills in the hole in the ◊code/inline{continuation} with the program fragment. For example, given the program fragment ◊code/inline{(λ (y) y)} the ◊code/inline{continuation} ◊code/inline{((hole) (λ (z) z))}, ◊code/inline{fill-hole} returns ◊code/inline{((λ (y) y) (λ (z) z))}. The structure for the function is:

◊code/block/highlighted['racket]{
(define (fill-hole program-fragment continuation)
  (match continuation
    #;[`(hole)
       ; TODO: (1) Hole.
       ]
    #;[`(λ (,argument-name) ,body)
       ; TODO: (2) Anonymous function definition.
       ]
    #;[`(,function ,argument)
       ; TODO: (3) Function application.
       ]
    #;[variable
       ; TODO: (4) Variable reference.
       ]))
}

This structure is similar to all other functions that traverse the program structure, it is a pattern match on the argument ◊code/inline{continuation}. Besides the three usual cases (anonymous function definition, function application and variable reference), ◊code/inline{fill-hole} has to handle the ◊technical-term{holes} which occur in ◊code/inline{continuation}s. When that is the case, it just returns the given ◊code/inline{program-fragment}:

◊code/block/highlighted['racket]{
(define (fill-hole program-fragment continuation)
  (match continuation
    [`(hole)
     program-fragment]
    #;[`(λ (,argument-name) ,body)
       ; TODO: (2) Anonymous function definition.
       ]
    #;[`(,function ,argument)
       ; TODO: (3) Function application.
       ]
    #;[variable
       ; TODO: (4) Variable reference.
       ]))
}

◊margin-note{It would be correct to recursively call ◊code/inline{fill-hole} in the case that the ◊code/inline{continuation} is an anonymous function definition. But it is not necessary, so we avoid the extra work.}

In the second case, the ◊code/inline{continuation} is an anonymous function definition. The ◊code/inline{split-expression} function only splits ◊code/inline{expression}s in function applications, never inside an anonymous function definition, so a ◊technical-term{hole} can never occur inside an anonymous function definition, and ◊code/inline{fill-hole} can just return the ◊code/inline{continuation}, unaltered:

◊code/block/highlighted['racket]{
(define (fill-hole program-fragment continuation)
  (match continuation
    [`(hole)
     program-fragment]
    [`(λ (,argument-name) ,body)
     continuation]
    #;[`(,function ,argument)
       ; TODO: (3) Function application.
       ]
    #;[variable
       ; TODO: (4) Variable reference.
       ]))
}

In the case of a function application, ◊code/inline{fill-hole} has to keep traverse the program to find the ◊technical-term{hole} deeper in it. It does so by recursively calling itself on the ◊code/inline{function} and the ◊code/inline{argument}. It is necessary to traverse both the ◊code/inline{function} and the ◊code/inline{argument} because we do not know where the ◊technical-term{hole} is. There is only ever one ◊technical-term{hole} in any given ◊code/inline{continuation}, so one of these two recursive calls only triggers the cases other than the first, and the result is the same program fragment, unaltered. This preserves the rest of the ◊code/inline{continuation}, aside from the ◊technical-term{hole} in it:

◊code/block/highlighted['racket]{
(define (fill-hole program-fragment continuation)
  (match continuation
    [`(hole)
     program-fragment]
    [`(λ (,argument-name) ,body)
     continuation]
    [`(,function ,argument)
     `(,(fill-hole program-fragment function)
       ,(fill-hole program-fragment argument))]
    #;[variable
       ; TODO: (4) Variable reference.
       ]))
}

Finally, if the ◊technical-term{pattern match} reaches the final case, it means the ◊technical-term{hole} is not there, so ◊code/inline{fill-hole} returns the ◊code/inline{continuation}, unaltered:

◊code/block/highlighted['racket]{
(define (fill-hole program-fragment continuation)
  (match continuation
    [`(hole)
     program-fragment]
    [`(λ (,argument-name) ,body)
     continuation]
    [`(,function ,argument)
     `(,(fill-hole program-fragment function)
       ,(fill-hole program-fragment argument))]
    [variable
     continuation]))
}

◊paragraph-separation[]

◊new-thought{We finished implementing} the auxiliary functions, so ◊code/inline{step} is complete:

◊code/block/highlighted['racket]{
> (step `(((λ (x) x) (λ (y) y)) (λ (z) z)))
'((λ (y) y) (λ (z) z))
> (step `((λ (y) y) (λ (z) z)))
'(λ (z) z)
> (step `(λ (z) z))
'(λ (z) z)
}

Each call to ◊code/inline{step} performs only a single function application, the first one available when traversing the program depth-first, from left to right. When the given ◊code/inline{expression} is already a value, ◊code/inline{step} returns it unaltered. This ◊technical-term{debugger-like interpreter} allows us to inspect interpretation and understand step-by-step how any given ◊code/inline{expression} is evaluated to a value. It is a better choice than our first interpreter for reasoning about interpretation itself, because it is more transparent.

To keep compatibility with our first interpreter, we implement an ◊code/inline{interpret} function, which works by repeatedly calling ◊code/inline{step} until it reaches a value:

◊code/block/highlighted['racket]{
(define (interpret expression)
  (match expression
    [`(λ (,argument-name) ,body)
     expression]
    [_
     (interpret (step expression))]))
}

This version of ◊code/inline{interpret} works similarly to most other functions: it ◊technical-term{pattern matches} on the given ◊code/inline{expression}; if it is already a value, then return it unaltered; otherwise, call ◊code/inline{step} and recurse. The effect is that ◊code/inline{interpret} calls ◊code/inline{step} as many times as necessary to completely evaluate the ◊code/inline{expression} into a value.

◊paragraph-separation[]

◊new-thought{In this section} we made explicit an important aspect of interpretation: evaluation of nested function applications occurs in steps, and the order in which they happen is meaningful. In our language, inner function applications are evaluated first, from left to right.

◊; NEXT: Explain the ‘_’ pattern, above.

◊; NEXT: Motivate environment-based interpreters: - more realistic - performance - compilers - environment. Reason about the meaning of names (bindings): Reference “What’s in a name?” Debugger-like with inspect variables—otherwise, “where’s my code?”

◊; TODO: Add a ‘trace’ function, which repeatedly calls ‘step’ and collects the intermediate results.

◊; TODO: APPENDIX: Well-formedness condition.

◊; TODO: Mention β-reduction.

◊; TODO: Motivation for study of interpretation: understand how communication occurs in programming languages. It’s about names! The bindings allow long-distance communication.

◊; TODO: Mention that, which ‘interpret’ might not terminate, ‘step’ always does.

◊; TODO: Mention that ‘reduction-expression’ is commonly abbreviated to ‘redex’.

◊; TODO: Update explanation of ‘fill-hole’ to use ‘_’ pattern. TEST IT, FIRST!

◊; TODO: Mention that, for a realistic implementation, we wouldn’t want to split and fill expressions along the way.

◊; TODO: Factor environment into binding environment and value environment. Mention the value environment could be global.

◊; TODO: Notes for CPS article:
◊;       1. Motivate by avoiding re-doing the work of ‘split-expression’.
◊;       2. A ‘continuation’ is the ‘context’ represented as a function.
◊;       3. “Alphatization”.

◊; TODO: References.
◊; - SEwPR.
◊; - SICP.
◊; - PL book.
◊; - Lambda papers.

◊; TODO: Appendix: well-formedness condition.