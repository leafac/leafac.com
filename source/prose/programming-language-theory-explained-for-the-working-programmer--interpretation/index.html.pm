#lang pollen

◊define-meta[title]{Programming-Language Theory Explained for the Working Programmer: Interpretation}
◊define-meta[date]{2017-04-03}

◊margin-note{This article assumes knowledge in the ◊link/internal["/prose/programming-language-theory-explained-for-the-working-programmer--principles-of-programming-languages"]{essential features of programming languages}. Experience with functional programming languages in general and ◊link["https://racket-lang.org/"]{Racket} in particular are helpful, but not required. Refer to Racket’s ◊link["https://docs.racket-lang.org/quick/index.html"]{quick introduction} for more.}

◊margin-note{◊link["https://git.leafac.com/www.leafac.com/plain/source/prose/programming-language-theory-explained-for-the-working-programmer--interpretation/programming-language-theory-explained-for-the-working-programmer--interpretation.rkt"]{Here} is the code for this entire article.}

◊new-thought{Interpreters are programs} for running programs. They receive as input code, usually written by human programmers, and execute it, outputting the result of the computations defined by the code. How do interpreters work? In this article we address this question by writing a few different interpreters, with the goal of exploring the underlying principles of computing. In the process, we introduce techniques that are generally applicable to everyday problem solving. We avoid the mathematical notation and jargon usually associated with this kind of topic, driving the exposition by working code. So this article is approachable to all programmers.

◊section['language]{Language}

◊new-thought{We need to choose} a language in which to write our interpreters. We choose Racket because it has features that make interpreters easier to read, for example, pattern matching and quasiquoting—which we introduce later. But there is nothing special about Racket, this article could be rewritten in any other programming language.

More important than the choice of base language is the choice of target language. What language are we going to interpret? We are not interested in language design in this article, our objective is not understand how particular features are interpreted. Instead, we are interested in studying interpretation itself, understanding the fundamental principles behind computation. So the target language should be as ◊technical-term{simple} as possible.

We choose ◊technical-term{simplicity} over ◊technical-term{convenience}. Our target language preferably includes few features, so that our interpreters remain small and understandable, and we can change how they work with minimal effort. This entails that our target language is ◊technical-term{difficult} to use; programs written in it are verbose and unintelligible. It would be a bad choice for everyday programming tasks, but it is good target language for this article, as long as it remains a programming language with enough features to represent arbitrary computations.

◊margin-note{For more on our target language, refer to ◊link/internal["/prose/programming-language-theory-explained-for-the-working-programmer--principles-of-programming-languages"]{◊publication{Programming-Language Theory Explained for the Working Programmer: Principles of Programming Languages}}.}

There exist many languages that fit our requirements. From all of them, we choose one that is particularly elegant, for its compactness. This target language represents a minimal core with only the essential features of programming languages: (1) definitions of anonymous functions of single argument and single return value; (2) applications of these functions; and (3) variable references. The following listing is an example of a program in this language:

◊code/block/highlighted['racket]{
(λ (x) x)
}

◊margin-note{The lambda (◊code/inline{λ}) is the only Greek letter and the most unusual notation in this article. It is worth introducing a short notation for anonymous functions because we write them frequently. This notation also justifies the formal name for our target language: ◊technical-term{Lambda calculus}.}

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

This program is an application of the function ◊code/inline{(λ (x) x)} to the argument ◊code/inline{(λ (y) y)}. The interpretation of this is the same as in mathematics and most programming languages: replace every occurrence of the argument name ◊code/inline{x} in ◊code/inline{(λ (x) x)}’s body with the argument ◊code/inline{(λ (y) y)}. Because ◊code/inline{(λ (x) x)}’s body is just ◊code/inline{x}, the result of this program is ◊code/inline{(λ (y) y)}.

◊; TODO: There are many implicit design decisions. Strict vs. lazy, order in which to choose the next expression to evaluate, etc.
◊; TODO: Function application. Support communication.
◊; TODO: Substitution is the core of communication.
◊; TODO: Subset of Racket.
◊; TODO: Quote to represent programs.
◊; TODO: Open programs.

◊; TODO: References.
◊; - SEwPR.
◊; - SICP.
◊; - PL book.