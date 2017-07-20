#lang pollen

◊define-meta[title]{Programming-Language Theory Explained for the Working Programmer: Debugger-Like Interpreter}
◊define-meta[date]{2017-06-08}

◊; TODO: ‘trace’.

◊margin-note{This article assumes knowledge in the ◊link/internal["/prose/programming-language-theory-explained-for-the-working-programmer--principles-of-programming-languages"]{essential features of programming languages}. Experience with functional programming languages in general and ◊link["https://racket-lang.org/"]{Racket} in particular are helpful, but not required. Refer to Racket’s ◊link["https://docs.racket-lang.org/quick/index.html"]{quick introduction} for more.}

◊margin-note{◊link["https://git.leafac.com/www.leafac.com/plain/source/prose/programming-language-theory-explained-for-the-working-programmer--interpretation/programming-language-theory-explained-for-the-working-programmer--interpretation.rkt"]{Here} is the code for this entire article.}

◊margin-note{
 In technical terms, our first interpreter is a ◊technical-term{big-step interpreter}, because the whole interpretation happens in a single big traversal of the program. One call to ◊code/inline{interpret} suffices to interpret a whole program to a value.

 The ◊technical-term{debugger-like interpreter} of this section, in opposition, is called a ◊technical-term{small-step interpreter}. Each call to ◊code/inline{step}—which we implement later in this section—takes a single step towards a value, resolving a single function application. For convenience, and to keep a compatible interface with the ◊technical-term{big-step interpreter}, we implement an ◊code/inline{interpret} function in this section. Like the ◊code/inline{interpret} from the ◊technical-term{big-step interpreter}, it also interprets programs to values in a single call, but it does so by repeatedly calling ◊code/inline{step}. If given a non-terminating program, then ◊code/inline{interpret} itself does not terminate, but only because it tries to call ◊code/inline{step} infinitely many times—each of the calls to ◊code/inline{step} are guaranteed to terminate. It is the ◊code/inline{step} function that characterizes the ◊technical-term{debugger-like interpreter} as a ◊technical-term{small-step interpreter}, not ◊code/inline{interpret} itself.
}

◊margin-note{Another motivation for a ◊technical-term{debugger-like interpreter} is that, in our first interpreter, the ◊technical-term{stack} of pending work was implicit in the base language (Racket) stack. In the ◊technical-term{debugger-like interpreter} the remaining work becomes a first-class citizen that we can reason about—in the form of ◊technical-term{contexts}, which we introduce later in this section.}

◊new-thought{Our first interpreter} defined in the ◊reference['first-interpreter]{previous section} takes the simplest approach possible to interpretation. When considering a function application in which the ◊code/inline{function} or the ◊code/inline{argument} are function applications themselves, the ◊code/inline{interpret} function recursively calls itself. The effect is that the path the interpreter takes is opaque. The ◊code/inline{interpret} function receives a program and outputs a value, but the computations necessary to get to the result are not clear.

In this section, we rewrite our interpreter to take a different approach, more similar to that of ◊technical-term{step-debuggers}. ◊technical-term{Step-debuggers} are tools that aid program understanding and debugging, they allow the user to run a program step-by-step (line-by-line, expression-by-expression, and so forth). In our case, the level of granularity that is interesting is the function application, because function applications are the smallest pieces of computation that preserve meaning.

If we inspected interpretation in the midst of ◊code/inline{substitute}, we would potentially find meaningless program fragments in which there are undefined variables. For example, while substituting the argument name ◊code/inline{x} for the value ◊code/inline{(λ (y) y)} in the program fragment ◊code/inline{(x x)}, we could find the program fragment ◊code/inline{((λ (y) y) x)}, in which only the first use of ◊code/inline{x} has been substituted. The program fragment ◊code/inline{((λ (y) y) x)} has no meaning on its own, because the variable ◊code/inline{x} is undefined.

Alternatively, if we inspected interpretation after a few function applications, we would potentially miss some nuances of the process. So a single function application is the best level of granularity for a ◊technical-term{step} in our ◊technical-term{debugger-like interpreter}.

◊paragraph-separation[]

◊new-thought{We start with} a function called ◊code/inline{step}. It has this name because its purpose is to take a single ◊technical-term{step} towards evaluating an ◊code/inline{program} to a value, similar to the functionality of the ◊technical-term{step} button on a ◊technical-term{step-debugger}. The ◊code/inline{step} function is similar to ◊code/inline{interpret} as defined in the ◊reference['first-interpreter]{previous section}, but it only evaluates one function application, instead of all of them. We reuse the parts of our first interpreter that are not concerned with function application in ◊code/inline{step}’s definition:

◊code/block/highlighted['racket]{
(define (step program)
  (match program
    [`(λ (,argument-name) ,body)
     program]
    #;[`(,function ,argument)
       ; TODO: (2) Function application.
       ]))
}

The case of function application works in three parts: first, find which function application should happen at the current step; then, perform it, substituting the ◊code/inline{argument-name} for the ◊code/inline{argument} in the ◊code/inline{function} ◊code/inline{body}; finally, build the resulting partially interpreted program. This process is necessary because the components of a function application might be function applications themselves. For example, consider again the following program from the previous section:

◊code/block/highlighted['racket]{
(((λ (x) x) (λ (y) y)) (λ (z) z))
}

In this program, the function of the top-level application is ◊code/inline{((λ (x) x) (λ (y) y))}. This is a function application itself, and it needs to be resolved before we can perform the top-level application. The same issue would arise if the ◊code/inline{argument} was a function application. So, when given the ◊code/inline{program} above, the ◊code/inline{step} function does not evaluate it directly to a value as our first interpreter did. Instead, it identifies that the next computation immediately available is ◊code/inline{((λ (x) x) (λ (y) y))}, performs it, and outputs the partially interpreted program ◊code/inline{((λ (y) y) (λ (z) z))}. A subsequent call to ◊code/inline{step} with this intermediary result would then reach the final value of the program: ◊code/inline{(λ (z) z)}.

In the general case, function applications might be arbitrarily nested, and more than one inner application might be ready for resolution, when both their ◊code/inline{function} and ◊code/inline{argument} are already values. So we delegate this choice of which application to resolve next to an auxiliary function ◊code/inline{split-program}, which we define later. The function ◊code/inline{split-program} has this name because it ◊informal{splits} the given ◊code/inline{program} in two parts: the function application which we resolve next, and the rest of the program.

◊margin-note{The representation for ◊technical-term{holes} using ◊code/inline{(hole)} does not conflict with existing constructs in our target language, because function applications would include an argument in the parentheses and variable references would not have parentheses.}

◊margin-note{◊technical-term{Reduction expression} are commonly abbreviated to ◊technica-term{redex}.}

The function application which we resolve next is called ◊technical-term{reduction expression}, because ◊technical-term{reduction} is the technical term for what we have been informally calling ◊informal{resolving a function application}. We represent ◊technical-term{reduction expression} as any other program fragment, for example, ◊code/inline{`((λ (x) x) (λ (y) y))}. The rest of the ◊code/inline{program}, from which we extracted the ◊technical-term{reduction expression}, is called ◊technical-term{context}, because it represents the context in which the ◊technical-term{reduction expression} occurs. We represent ◊technical-term{contexts} as ◊informal{programs with a hole}, and the ◊technical-term{hole} is identified by ◊code/inline{(hole)}, for example:

◊code/block/highlighted['racket]{
`((hole) (λ (z) z))
}

The ◊code/inline{split-program} function has to return two values: the ◊technical-term{reduction expression} and the ◊technical-term{context}. In Racket, functions can return multiple values using the form ◊code/inline{values}, for example, ◊code/inline{(values `((λ (x) x) (λ (y) y)) `((hole) (λ (z) z)))}. To bind these results to variables, we use the ◊code/inline{define-values} form, for example:

◊code/block/highlighted['racket]{
(define-values (reduction-expression context)
  (values `((λ (x) x) (λ (y) y)) `((hole) (λ (z) z))))
}

The ◊code/inline{reduction-expression} returned by ◊code/inline{split-program} is guaranteed to be a function application in which both the ◊code/inline{function} and ◊code/inline{argument} are immediately available—they are values, not other function applications. Furthermore, if we fill the ◊technical-term{hole} in the ◊code/inline{context} with the ◊code/inline{reduction-expression}, then we have our original ◊code/inline{program} back. In other words, this decomposition does not lose any information.

Because the ◊code/inline{reduction-expression} is a function application ready for evaluation, we can use the same ◊code/inline{substitute} from the ◊reference['first-interpreter]{previous section} and substitute the ◊code/inline{argument-name} for the ◊code/inline{argument} in the ◊code/inline{body}. Then, we fill the ◊technical-term{hole} in the ◊code/inline{context} with the resulting program fragment. We use another auxiliary function ◊code/inline{fill-hole}, which we define later, for this last part. This is the complete listing for ◊code/inline{step}:

◊code/block/highlighted['racket]{
(define (step program)
  (match program
    [`(λ (,argument-name) ,body)
     program]
    [`(,function ,argument)
     (define-values (reduction-expression context) (split-program program))
     (match-define `((λ (,argument-name) ,body) ,argument) reduction-expression)
     (define reduced-expression (substitute body argument-name argument))
     (fill-hole reduced-expression context)]))
}

◊paragraph-separation[]

◊new-thought{There are still} two missing pieces in our ◊technical-term{debugger-like interpreter}: the auxiliary functions ◊code/inline{split-program} and ◊code/inline{fill-hole}. We start by addressing ◊code/inline{split-program}.

First, note that ◊code/inline{split-program} is only called with ◊code/inline{program-fragment}s which are function applications; otherwise, the ◊code/inline{program} given to ◊code/inline{step} would be an anonymous function definition, which it would return unaltered, without calling ◊code/inline{split-program}. The task of ◊code/inline{split-program} is to chose which of the potentially arbitrarily nested function applications to compute next. The only constraint is that the function application must be ready for computation, which means both the ◊code/inline{function} and the ◊code/inline{argument} must already be values, and not other nested function applications.

But multiple function applications in a given ◊code/inline{expression} might be in this state, ready to be processed by ◊code/inline{step}. The ◊code/inline{split-program} function could chose any of them. Which application to evaluate next is a design decision and we follow Racket’s approach: go from left to right, and chose the innermost function application first. Other orders would work equally well, but this corresponds more closely to programmers’ intuitions.

The structure of the ◊code/inline{split-program} function is similar to the ◊code/inline{traverse} pattern. It receives a ◊code/inline{program-fragment} as argument and ◊technical-term{pattern matches} on it using the ◊code/inline{match} form. But the ◊technical-term{patterns} in ◊code/inline{split-program} are different, because it considers different cases: (1) both the ◊code/inline{function} and the ◊code/inline{argument} are already values, so the given ◊code/inline{program-fragment} is ready for evaluation; (2) the ◊code/inline{function} is already a value, but the ◊code/inline{argument} is a nested application that needs to be resolved first; or (3) the ◊code/inline{function} is not a value yet, it needs to be resolved first:

◊code/block/highlighted['racket]{
(define (split-program program-fragment)
  (match program-fragment
    #;[`((λ (,argument-name/function) ,body/function) (λ (,argument-name/argument) ,body/argument))
       ; TODO: (1) Both function and argument are values.
       ]
    #;[`((λ (,argument-name/function) ,body/function) ,argument)
       ; TODO: (2) Function is a value, but argument is not.
       ]
    #;[`(,function ,argument)
       ; TODO: (3) Function is not a value.
       ]))
}

This order guarantees left-to-right evaluation, because we only consider the possibility of a ◊code/inline{function} which is not an immediate value in case (3), ◊emphasis{after} we have considered case (2), in which it ◊emphasis{is} an immediate value.

In the first case, both ◊code/inline{function} and ◊code/inline{argument} are already values—functions—which means the ◊code/inline{program-fragment} is ready for evaluation. So ◊code/inline{split-program} returns the ◊code/inline{program-fragment} as the ◊code/inline{reduction-expression} and the ◊code/inline{context} is just ◊code/inline{(hole)}, because there is no other context around the given ◊code/inline{expression}:

◊code/block/highlighted['racket]{
(define (split-program program-fragment)
  (match program-fragment
    [`((λ (,argument-name/function) ,body/function) (λ (,argument-name/argument) ,body/argument))
     (values program-fragment `(hole))]
    #;[`((λ (,argument-name/function) ,body/function) ,argument)
       ; TODO: (2) Function is a value, but argument is not.
       ]
    #;[`(,function ,argument)
       ; TODO: (3) Function is not a value.
       ]))
}

For example, if the ◊code/inline{program-fragment} is ◊code/inline{((λ (x) x) (λ (y) y))}, then it is ready for evaluation, and the context in which this computation is happening is just ◊code/inline{(hole)}:

◊margin-note{Each of the two values that ◊code/inline{split-program} outputs occupies a separate line in the output.}

◊code/block/highlighted['racket]{
> (split-program `((λ (x) x) (λ (y) y)))
'((λ (x) x) (λ (y) y))
'(hole)
}

In the second case, the ◊code/inline{function} is already a value, but the ◊code/inline{argument} is not, for example, ◊code/inline{((λ (x) x) ((λ (y) y) (λ (z) z)))}. The next immediately resolvable function application—the ◊code/inline{reduction-expression}—must be in the program fragment represented by ◊code/inline{argument}. In our example, that is ◊code/inline{((λ (y) y) (λ (z) z))}. The ◊code/inline{split-program} function recursively calls itself with ◊code/inline{argument} and propagates the resulting ◊code/inline{reduction-expression} and ◊code/inline{context}, taking care of wrapping the ◊code/inline{context} with the function application in ◊code/inline{expression}:

◊code/block/highlighted['racket]{
(define (split-program program-fragment)
  (match program-fragment
    [`((λ (,argument-name/function) ,body/function) (λ (,argument-name/argument) ,body/argument))
     (values program-fragment `(hole))]
    [`((λ (,argument-name/function) ,body/function) ,argument)
     (define-values (reduction-expression context) (split-program argument))
     (values reduction-expression `((λ (,argument-name/function) ,body/function) ,context))]
    #;[`(,function ,argument)
       ; TODO: (3) Function is not a value.
       ]))
}

We can test this implementation with our example:

◊code/block/highlighted['racket]{
> (split-program `((λ (x) x) ((λ (y) y) (λ (z) z))))
'((λ (y) y) (λ (z) z))
'((λ (x) x) (hole))
}

The final case is similar to the second, except that the subject of the recursive call is ◊code/inline{function}. The strategy is the same: call ◊code/inline{split-program} itself with the ◊code/inline{function} and forward the resulting ◊code/inline{reduction-expression} and ◊code/inline{context}, taking care of wrapping the ◊code/inline{context} with the function application in ◊code/inline{expression}:

◊code/block/highlighted['racket]{
(define (split-program program-fragment)
  (match program-fragment
    [`((λ (,argument-name/function) ,body/function) (λ (,argument-name/argument) ,body/argument))
     (values program-fragment `(hole))]
    [`((λ (,argument-name/function) ,body/function) ,argument)
     (define-values (reduction-expression context) (split-program argument))
     (values reduction-expression `((λ (,argument-name/function) ,body/function) ,context))]
    [`(,function ,argument)
     (define-values (reduction-expression context) (split-program function))
     (values reduction-expression `(,context ,argument))]))
}

We can test this final case with a ◊code/inline{program-fragment} similar to our previous example:

◊code/block/highlighted['racket]{
> (split-program `(((λ (x) x) (λ (y) y)) (λ (z) z)))
'((λ (x) x) (λ (y) y))
'((hole) (λ (z) z))
}

◊paragraph-separation[]

◊new-thought{The final auxiliary function} is ◊code/inline{fill-hole}, which receives as arguments a ◊code/inline{program-fragment} and a ◊code/inline{context}. It is called by ◊code/inline{step} after evaluating the ◊code/inline{reduction-expression} selected by ◊code/inline{split-program} and fills the ◊technical-term{hole} in the ◊code/inline{context} with the ◊code/inline{program-fragment}. For example, when given the ◊code/inline{program-fragment} ◊code/inline{(λ (y) y)} and the ◊code/inline{context} ◊code/inline{((hole) (λ (z) z))}, then ◊code/inline{fill-hole} returns ◊code/inline{((λ (y) y) (λ (z) z))}.

The structure for the implementation of ◊code/inline{fill-hole} is similar to ◊code/inline{traverse}, but it considers different ◊technical-term{patterns}:

◊margin-note{The ◊code/inline{_} pattern matches anything.}

◊code/block/highlighted['racket]{
(define (fill-hole program-fragment context)
  (match context
    #;[`(hole)
       ; TODO: (1) Hole.
       ]
    #;[`(,function ,argument)
       ; TODO: (2) Function application.
       ]
    #;[_
       ; TODO: (3) Anything else.
       ]))
}

When the context is just a ◊technical-term{hole}, then ◊code/inline{fill-hole} returns the given ◊code/inline{program-fragment}:

◊code/block/highlighted['racket]{
(define (fill-hole program-fragment context)
  (match context
    [`(hole)
     program-fragment]
    #;[`(,function ,argument)
       ; TODO: (2) Function application.
       ]
    #;[_
       ; TODO: (3) Anything else.
       ]))
}

For example:

◊code/block/highlighted['racket]{
> (fill-hole `(λ (y) y) `(hole))
'(λ (y) y)
}

In the case of a function application, ◊code/inline{fill-hole} does not know if the ◊technical-term{hole} is in the ◊code/inline{function} or the ◊code/inline{argument}, so it just continues traversing the ◊code/inline{program-fragment} via recursive calls:

◊code/block/highlighted['racket]{
(define (fill-hole program-fragment context)
  (match context
    [`(hole)
     program-fragment]
    [`(,function ,argument)
     `(,(fill-hole program-fragment function) ,(fill-hole program-fragment argument))]
    #;[_
       ; TODO: (3) Anything else.
       ]))
}

Finally, if the ◊technical-term{pattern match} reaches the final case, it means the ◊technical-term{hole} is not in the given ◊code/inline{program-fragment}. In this case, ◊code/inline{fill-hole} returns the ◊code/inline{context}, unaltered:

◊code/block/highlighted['racket]{
(define (fill-hole program-fragment context)
  (match context
    [`(hole)
     program-fragment]
    [`(,function ,argument)
     `(,(fill-hole program-fragment function) ,(fill-hole program-fragment argument))]
    [_
     context]))
}

We can now test ◊code/inline{fill-hole} in the general case:

◊code/block/highlighted['racket]{
> (fill-hole `(λ (z) z) `(λ (x) x))
'(λ (x) x)
> (fill-hole `(λ (z) z) `((λ (x) x) (hole)))
'((λ (x) x) (λ (z) z))
> (fill-hole `(λ (z) z) `((hole) (λ (x) x)))
'((λ (z) z) (λ (x) x))
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

Each call to ◊code/inline{step} evaluates only a single function application, the first one available when traversing the program depth-first, from left to right. When the given ◊code/inline{program} is already a value, ◊code/inline{step} returns it unaltered. This ◊technical-term{debugger-like interpreter} allows us to inspect interpretation and understand step-by-step how any given ◊code/inline{program} is evaluated to a value. It is a better choice than our first interpreter for reasoning about interpretation itself, because it is more transparent.

To keep compatibility with our first interpreter, we implement an ◊code/inline{interpret} function, which works by repeatedly calling ◊code/inline{step} until it reaches a value:

◊code/block/highlighted['racket]{
(define (interpret program)
  (match program
    [`(λ (,argument-name) ,body)
     program]
    [_
     (interpret (step program))]))
}

This version of ◊code/inline{interpret} follows the ◊code/inline{traverse} form: it ◊technical-term{pattern matches} on the given ◊code/inline{program}; if it is already a value, then return it unaltered; otherwise, call ◊code/inline{step} and recurse. The effect is that ◊code/inline{interpret} calls ◊code/inline{step} as many times as necessary to completely evaluate the ◊code/inline{expression} into a value. While the calls to ◊code/inline{step} are guaranteed to terminate, ◊code/inline{interpret} might run forever, if given a non-terminating ◊code/inline{program}, because it might need to call ◊code/inline{step} infinitely many times. But, with our current implementation, we could inspect the process, by looking at the intermediary ◊code/inline{program} after any number of calls to ◊code/inline{step}, whereas in our first interpreter, the whole process was opaque.

◊paragraph-separation[]

◊new-thought{In this section} we made explicit an important aspect of interpretation: evaluation of nested function applications occurs in steps, and the order in which they happen is meaningful. In our language, inner function applications are evaluated first, from left to right.

Our ◊technical-term{debugger-like interpreter} allows us to reason about the interpretation of function application in terms of substitution. When the ◊code/inline{function} ◊code/inline{(λ (x) ___)} is applied, every occurrence of ◊code/inline{x} in the body ◊code/inline{___} is substituted by the ◊code/inline{argument}. After a number of ◊code/inline{step}s, the intermediary ◊code/inline{program} has been through several substitutions, and might become unrecognizable with respect to the original ◊code/inline{program} under interpretation. While our ◊technical-term{debugger-like interpreter} clarifies what are the exact ◊code/inline{program-fragment}s as interpretation progresses, it conceals the relationship between these ◊code/inline{program-fragment}s and those originally written by the programmer. The interpreter in the next section explores the other end of this trade-off.

◊section['variable-inspecting-debugger-like-interpreter]{Variable-Inspecting Debugger-Like Interpreter}

◊new-thought{Interpreters and debuggers} generally do not work by substituting arguments in place and creating new program fragments. First, because this can disorient programmers, as the original program they wrote is no longer recognizable after some steps of interpretation. Also, it is inefficient to create program fragments, which tend to be big data structures.

◊margin-note{Technically, the interpreters we wrote in previous sections are called ◊technical-term{substitution-based interpreters}, and the one write in section is a ◊technical-term{environment-based interpreter}.}

◊margin-note{Compilers generally follow the ◊technical-term{environment-based} approach, because they cannot generate code at run-time.}

The alternative approach is to ◊emphasis{delay} the substitution, storing the necessary information on the side. For example, suppose the function ◊code/inline{(λ (x) ___ x ___)} is being applied to the argument ◊code/inline{(λ (y) y)}. To this point in the article, interpretation proceeded by substituting every (free) occurrence of the argument name ◊code/inline{x} for the argument in the body, resulting in ◊code/inline{___ (λ (y) y) ___}. In our ◊technical-term{variable-inspecting debugger-like interpreter}, we keep the body ◊code/inline{___ x ___} unaltered, and keep a data structure on the side to record that any free ◊code/inline{x} means ◊code/inline{(λ (y) y)}. When we need to interpret that free ◊code/inline{x}, we consult this data structure.

This solution is similar to most ◊technical-term{step-debuggers}, which do not work by substitution. They show the current execution point in terms of the original program the programmer wrote, and have a panel showing the current values of the variables. These mappings between free variables and values are called ◊technical-term{environments}.

◊paragraph-separation[]

◊new-thought{The implementation of our} ◊technical-term{variable-inspecting debugger-like interpreter} is similar in structure to our ◊technical-term{debugger-like interpreter}. The most important function is ◊code/inline{step}, which evaluates the next ◊technical-term{reduction expression}. There is one important difference between this interpreter and the previous, though. For interpreters up to this point in the article, all information necessary to evaluate the program was present in the intermediary programs generated during interpretation. The ◊code/inline{step} function received a ◊code/inline{program} as argument. Now, besides the intermediary program, it is also necessary to have information about the ◊technical-term{environment}. Together, they represent the current ◊technical-term{state} of computation. We start our implementation by defining a data structure for ◊technical-term{states}:

◊margin-note{The ◊code/inline{#:transparent} flag is there just to make the data structure print nicely for debugging.}

◊code/block/highlighted['racket]{
(struct state (program environment) #:transparent)
}

◊margin-note{In other programming languages, ◊technical-term{dictionaries} are also called maps, hash maps, association lists, associative arrays and so forth.}

The snippet above defines a data structure called ◊code/inline{state}, which has two fields named ◊code/inline{program} and ◊code/inline{environment}. The ◊code/inline{program}s are represented using quasiquoting, the same they have been to this point. The ◊code/inline{environment}s are dictionaries, which map variable names to values in our language.

To start interpretation, it is necessary to inject the given ◊code/inline{program} into an ◊code/inline{initial-state}. No ◊code/inline{environment} information is available yet, so we use the empty ◊code/inline{environment}:

◊code/block/highlighted['racket]{
(define (initial-state program)
  (state program empty))
}

For example, given the program ◊code/inline{(λ (x) x)}, the initial state is:

◊code/block/highlighted['racket]{
> (initial-state `(λ (x) x))
(state '(λ (x) x) '())
}

◊paragraph-separation[]

◊new-thought{The next big change} in our interpreter is that ◊emphasis{functions are no longer values in our language}! A function in an intermediary program might include references to variables which have not been substituted yet; the information for that substitution is in an ◊code/inline{environment}. For example, consider the program ◊code/inline{((λ (x) (λ (y) x)) (λ (z) z))}. In the interpreters we implemented in previous sections, this evaluates to ◊code/inline{(λ (y) (λ (z) z))}, because the ◊code/inline{x} in ◊code/inline{(λ (y) x)} is substituted for the argument ◊code/inline{(λ (z) z)}. But in our current interpreter this does not happen, the resulting program would be ◊code/inline{(λ (y) x)}, which cannot be a value because the variable ◊code/inline{x} is free and, consequently, the program is open.

The solution is to pair functions with ◊code/inline{environment}s, which contain mappings for the variables free in the function body. In the running example, the function ◊code/inline{(λ (y) x)} is paired with an ◊code/inline{environment} containing a mapping for name ◊code/inline{x}. When the interpreter has to evaluate the variable reference ◊code/inline{x} in ◊code/inline{(λ (y) x)}, it looks up the name in the ◊code/inline{environment} associated with that function. This construct comprising a function and a corresponding ◊code/inline{environment} is called a ◊technical-term{closure}.

◊emphasis{Functions are no longer values in our language, but closures are}!

Why do we need closures to hold ◊code/inline{environment}s, instead of using the ◊code/inline{environment} already present in the interpretation ◊code/inline{state}, as defined above? Functions can be passed around as arguments to other functions or returned from calls to other functions; they transit freely through the program and may finally be called in a ◊technical-term{context} entirely different from the one in which it was created. The ◊code/inline{environment} in the interpretation ◊code/inline{state} has information about the context at the call site, and the ◊code/inline{environment} in the ◊technical-term{closure} has information about the context in which the function was defined.

◊margin-note{An example of a language which has dynamic scoping is ◊emphasis{Emacs Lisp}.}

◊margin-note{Lexical scoping is also called static scoping.}

Which ◊code/inline{environment} to use (calling site or definition site) is a matter of language design, and there are languages in both fronts. If a language uses the ◊code/inline{environment} from the calling site (the one in the interpretation ◊code/inline{state}), then it has ◊technical-term{dynamic scoping}. If a language uses the ◊code/inline{environment} from the definition site (the one in the ◊technical-term{closure}), then it has ◊technical-term{lexical scoping}. Most programming languages—including Racket—feature ◊technical-term{lexical scoping}, because it allows programmers to reason about functions locally; they only have to think about the ◊code/inline{environment} in which the function is defined, as opposed to every ◊code/inline{environment} in which the function might possibly be called. As a result, functions are easier to compose and use in ways not anticipated by their designers.

Our language has lexical scoping, and that is why we need closures: to carry around the ◊code/inline{environment} in which a function was defined along with the function itself, to be used at the calling sites. We represent closures as values in our language using the form ◊code/inline{`(closure (λ (,argument-name) ,body) ,closure-environment)}. Coming back to our example above, the following is a value in our language:

◊code/block/highlighted['racket]{
`(closure (λ (y) x) ((x . (closure (λ (z) z) ()))))
}

This is a closure over the function ◊code/inline{(λ (y) x)}, in which the ◊code/inline{environment} maps the name ◊code/inline{x} to its corresponding value. Note that values in the ◊code/inline{environment} are closures themselves, as closures are the only kind of value in our language.

◊; ---------------------------------------------------------------------------------------------------

◊; TODO: Draw “trees with holes.”

◊; TODO: ◊margin-note{The Racket ◊code/inline{cond} form is similar to ◊code/inline{if}, except that each of the branches might have multiple expressions.}

◊; TODO: Section about realistic implementation:
◊;       1. Don’t split and fill.
◊;       2. The value environment could be global (widening).

◊; TODO: Notes for CPS article:
◊;       1. Motivate by avoiding re-doing the work of ‘split-program’.
◊;       2. A ‘continuation’ is the ‘context’ represented as a function.
◊;       3. “Alphatization”.